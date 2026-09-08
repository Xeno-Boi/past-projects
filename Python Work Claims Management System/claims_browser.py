# Code for claims browser user interface
# Displays all claims stored in the database

# import
from pathlib import Path
import tkinter as tk
from tkinter import messagebox, ttk
from defs import Approver, Claim
import database
from PIL import Image, ImageTk


# constants
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 750
IMAGE_WIDTH = 320
IMAGE_HEIGHT = 220


# functions

class ClaimsBrowser:
    """Tkinter browser used to display all claims."""

    def __init__(self, root):
        self.root = root
        self.claims: list[Claim] = []
        self.employees: dict[int, str] = {}
        self.receipt_image = None

        root.title("Claims Browser")
        root.geometry(f"{WINDOW_WIDTH}x{WINDOW_HEIGHT}")
        root.minsize(900, 500)

        # create main frame container
        frame = ttk.Frame(root, padding=15)
        frame.pack(fill="both", expand=True)

        # create heading and refresh button
        heading_frame = ttk.Frame(frame)
        heading_frame.pack(fill="x", pady=(0, 10))

        ttk.Label(
            heading_frame,
            text="All Claims",
            font=("TkDefaultFont", 16, "bold")
        ).pack(side="left")

        # create approval filters
        self.show_both_unapproved = tk.BooleanVar(value=True)
        self.show_finance_approved = tk.BooleanVar(value=True)
        self.show_finance_unapproved = tk.BooleanVar(value=True)
        self.show_ceo_approved = tk.BooleanVar(value=True)
        self.show_ceo_unapproved = tk.BooleanVar(value=True)
        self.show_both_approved = tk.BooleanVar(value=True)
        self.show_all = tk.BooleanVar(value=True)

        filter_frame = ttk.Frame(heading_frame)
        filter_frame.pack(side="left", padx=(12, 0))

        filters = (
            ("Both unapproved", self.show_both_unapproved, self.set_both_unapproved, 0, 0),
            ("Both approved", self.show_both_approved, self.set_both_approved, 1, 0),
            ("Finance approved", self.show_finance_approved, self.filter_changed, 0, 1),
            ("Finance unapproved", self.show_finance_unapproved, self.filter_changed, 1, 1),
            ("CEO approved", self.show_ceo_approved, self.filter_changed, 0, 2),
            ("CEO unapproved", self.show_ceo_unapproved, self.filter_changed, 1, 2)
        )

        for text, variable, command, row, column in filters:
            ttk.Checkbutton(
                filter_frame,
                text=text,
                variable=variable,
                command=command
            ).grid(row=row, column=column, sticky="w", padx=(0, 10))

        ttk.Checkbutton(
            filter_frame,
            text="All",
            variable=self.show_all,
            command=self.set_all_filters
        ).grid(row=0, column=3, rowspan=2, sticky="w")

        ttk.Button(
            heading_frame,
            text="Refresh",
            command=self.load_claims
        ).pack(side="right")

        ttk.Button(
            heading_frame,
            text="Back",
            command=self.go_back
        ).pack(side="right", padx=(0, 8))

        ttk.Button(
            heading_frame,
            text="Delete Claim",
            command=self.delete_selected_claim
        ).pack(side="right", padx=(0, 8))

        ttk.Button(
            heading_frame,
            text="Approve Claim",
            command=self.approve_selected_claim
        ).pack(side="right", padx=(0, 8))

        self.status = ttk.Label(heading_frame, text="")
        self.status.pack(side="right", padx=15)

        # create claim table
        table_frame = ttk.Frame(frame)
        table_frame.pack(fill="both", expand=True)

        columns = (
            "claim_id",
            "employee_id",
            "employee_name",
            "claim_date",
            "venue",
            "claim_type",
            "amount",
            "finance",
            "ceo"
        )

        self.claim_table = ttk.Treeview(
            table_frame,
            columns=columns,
            show="headings",
            selectmode="browse"
        )

        headings = {
            "claim_id": "Claim ID",
            "employee_id": "Employee ID",
            "employee_name": "Employee Name",
            "claim_date": "Date",
            "venue": "Venue",
            "claim_type": "Type",
            "amount": "Amount",
            "finance": "Finance Approved",
            "ceo": "CEO Approved"
        }

        widths = {
            "claim_id": 70,
            "employee_id": 85,
            "employee_name": 120,
            "claim_date": 95,
            "venue": 170,
            "claim_type": 90,
            "amount": 90,
            "finance": 115,
            "ceo": 105
        }

        for column in columns:
            self.claim_table.heading(column, text=headings[column])
            self.claim_table.column(
                column,
                width=widths[column],
                minwidth=60,
                anchor="center"
            )

        self.claim_table.column("employee_name", anchor="w")
        self.claim_table.column("venue", anchor="w")
        self.claim_table.bind("<<TreeviewSelect>>", self.show_claim_details)

        # create table scrollbars
        vertical_scrollbar = ttk.Scrollbar(
            table_frame,
            orient="vertical",
            command=self.claim_table.yview
        )
        horizontal_scrollbar = ttk.Scrollbar(
            table_frame,
            orient="horizontal",
            command=self.claim_table.xview
        )

        self.claim_table.configure(
            yscrollcommand=vertical_scrollbar.set,
            xscrollcommand=horizontal_scrollbar.set
        )

        self.claim_table.grid(row=0, column=0, sticky="nsew")
        vertical_scrollbar.grid(row=0, column=1, sticky="ns")
        horizontal_scrollbar.grid(row=1, column=0, sticky="ew")
        table_frame.rowconfigure(0, weight=1)
        table_frame.columnconfigure(0, weight=1)

        # create selected claim details area
        details_frame = ttk.LabelFrame(frame, text="Selected Claim Details", padding=10)
        details_frame.pack(fill="x", pady=(12, 0))

        self.details = tk.Text(details_frame, height=5, wrap="word", state="disabled")
        self.details.pack(side="left", fill="both", expand=True, padx=(0, 10))

        self.image_label = ttk.Label(
            details_frame,
            text="Select a claim to view its receipt image.",
            width=45,
            anchor="center"
        )
        self.image_label.pack(side="right", fill="both")

        self.load_claims()


    def load_claims(self):
        """Load all claims from the database into the table."""
        try:
            claims = database.get_all_claims()
            employees = dict(database.get_all_employees())
        except Exception as error:
            messagebox.showerror(
                "Database Error",
                f"Could not load claims.\n\n{error}",
                parent=self.root
            )
            return

        # clear old table rows
        for item in self.claim_table.get_children():
            self.claim_table.delete(item)

        self.claims = claims
        self.employees = employees

        self.apply_filters()


    def apply_filters(self):
        """Display claims matching the selected approval filters."""
        # clear old table rows
        for item in self.claim_table.get_children():
            self.claim_table.delete(item)

        displayed_claims = 0

        # insert matching claims into table
        for row, claim in enumerate(self.claims):
            if not self.claim_matches_filters(claim):
                continue

            employee_name = self.employees.get(claim.employee_id, "Unknown")
            self.claim_table.insert(
                "",
                "end",
                iid=str(row),
                values=(
                    claim.claim_id,
                    claim.employee_id,
                    employee_name,
                    claim.claim_date.isoformat(),
                    claim.venue,
                    claim.claim_type.name,
                    f"{claim.amount:,.2f}",
                    self.format_approval(claim.approved_by_finance),
                    self.format_approval(claim.approved_by_ceo)
                )
            )
            displayed_claims += 1

        self.status.config(
            text=f"{displayed_claims} of {len(self.claims)} claim(s)"
        )
        self.clear_claim_details()


    def filter_changed(self):
        """Update shortcut checkboxes and apply the current filters."""
        self.sync_filter_buttons()
        self.apply_filters()


    def set_both_unapproved(self):
        """Set both unapproved filters to the shortcut checkbox value."""
        selected = self.show_both_unapproved.get()
        self.show_finance_unapproved.set(selected)
        self.show_ceo_unapproved.set(selected)
        self.sync_filter_buttons()
        self.apply_filters()


    def set_both_approved(self):
        """Set both approved filters to the shortcut checkbox value."""
        selected = self.show_both_approved.get()
        self.show_finance_approved.set(selected)
        self.show_ceo_approved.set(selected)
        self.sync_filter_buttons()
        self.apply_filters()


    def set_all_filters(self):
        """Set every approval filter to the All checkbox value."""
        selected = self.show_all.get()
        self.show_finance_approved.set(selected)
        self.show_finance_unapproved.set(selected)
        self.show_ceo_approved.set(selected)
        self.show_ceo_unapproved.set(selected)
        self.sync_filter_buttons()
        self.apply_filters()


    def sync_filter_buttons(self):
        """Synchronize the shortcut checkboxes with the approval filters."""
        both_unapproved = (
            self.show_finance_unapproved.get()
            and self.show_ceo_unapproved.get()
        )
        both_approved = (
            self.show_finance_approved.get()
            and self.show_ceo_approved.get()
        )
        all_selected = (
            self.show_finance_approved.get()
            and self.show_finance_unapproved.get()
            and self.show_ceo_approved.get()
            and self.show_ceo_unapproved.get()
        )

        self.show_both_unapproved.set(both_unapproved)
        self.show_both_approved.set(both_approved)
        self.show_all.set(all_selected)


    def claim_matches_filters(self, claim: Claim) -> bool:
        """Return True when a claim matches an enabled approval filter."""
        finance_matches = (
            claim.approved_by_finance and self.show_finance_approved.get()
        ) or (
            not claim.approved_by_finance and self.show_finance_unapproved.get()
        )
        ceo_matches = (
            claim.approved_by_ceo and self.show_ceo_approved.get()
        ) or (
            not claim.approved_by_ceo and self.show_ceo_unapproved.get()
        )

        return finance_matches and ceo_matches


    def show_claim_details(self, event=None):
        """Display the note and receipt path for the selected claim."""
        selected_items = self.claim_table.selection()
        if not selected_items:
            self.clear_claim_details()
            return

        claim = self.claims[int(selected_items[0])]
        note = claim.note if claim.note else "No note"
        receipt_path = claim.receipt_path if claim.receipt_path else "No receipt"

        details_text = (
            f"Claim ID: {claim.claim_id}\n"
            f"Note: {note}\n"
            f"Receipt: {receipt_path}"
        )

        self.details.config(state="normal")
        self.details.delete("1.0", tk.END)
        self.details.insert("1.0", details_text)
        self.details.config(state="disabled")

        self.load_receipt_image(claim.receipt_path)


    def load_receipt_image(self, receipt_path: str):
        """Load and display the selected claim receipt image."""
        self.receipt_image = None

        try:
            image_path = Path(receipt_path)
            if not image_path.is_absolute():
                image_path = Path(__file__).parent / image_path

            if not image_path.is_file():
                raise FileNotFoundError

            image = Image.open(image_path)
            image.thumbnail((IMAGE_WIDTH, IMAGE_HEIGHT))
            self.receipt_image = ImageTk.PhotoImage(image)

            self.image_label.config(image=self.receipt_image, text="")
        except Exception:
            self.image_label.config(image="", text="Image Inaccessable")


    def clear_claim_details(self):
        """Clear the selected claim details area."""
        self.details.config(state="normal")
        self.details.delete("1.0", tk.END)
        self.details.insert("1.0", "Select a claim to view its note and receipt path.")
        self.details.config(state="disabled")
        self.receipt_image = None
        self.image_label.config(
            image="",
            text="Select a claim to view its receipt image."
        )


    def format_approval(self, approved: bool) -> str:
        """Convert an approval value into display text."""
        return "Yes" if approved else "No"


    def delete_selected_claim(self):
        """Delete the selected claim from the database."""
        selected_items = self.claim_table.selection()
        if not selected_items:
            messagebox.showwarning(
                "No Claim Selected",
                "Please select a claim to delete.",
                parent=self.root
            )
            return

        claim = self.claims[int(selected_items[0])]

        confirmed = messagebox.askyesno(
            "Delete Claim",
            f"Are you sure you want to delete claim {claim.claim_id}?",
            parent=self.root
        )
        if not confirmed:
            return

        try:
            database.delete_claim(claim.claim_id)
        except Exception as error:
            messagebox.showerror(
                "Database Error",
                f"Could not delete claim.\n\n{error}",
                parent=self.root
            )
            return

        messagebox.showinfo(
            "Claim Deleted",
            f"Claim {claim.claim_id} was deleted successfully.",
            parent=self.root
        )
        self.load_claims()


    def approve_selected_claim(self):
        """Approve the selected claim as the chosen approver."""
        selected_items = self.claim_table.selection()
        if not selected_items:
            messagebox.showwarning(
                "No Claim Selected",
                "Please select a claim to approve.",
                parent=self.root
            )
            return

        claim = self.claims[int(selected_items[0])]
        approver = self.choose_approver()

        if approver is None:
            return

        try:
            database.approve_claim(claim.claim_id, approver)
        except Exception as error:
            messagebox.showerror(
                "Database Error",
                f"Could not approve claim.\n\n{error}",
                parent=self.root
            )
            return

        messagebox.showinfo(
            "Claim Approved",
            f"Claim {claim.claim_id} was approved by {approver.name}.",
            parent=self.root
        )
        self.load_claims()


    def choose_approver(self) -> Approver | None:
        """Show an approver selection window and return the chosen approver."""
        selected_approver = None

        # create approver selection window
        selection_window = tk.Toplevel(self.root)
        selection_window.title("Choose Approver")
        selection_window.resizable(False, False)
        selection_window.transient(self.root)
        selection_window.grab_set()

        frame = ttk.Frame(selection_window, padding=20)
        frame.pack(fill="both", expand=True)

        ttk.Label(frame, text="Approve this claim as:").pack(pady=(0, 10))

        approver_name = tk.StringVar()
        approver_box = ttk.Combobox(
            frame,
            textvariable=approver_name,
            values=[approver.name for approver in Approver],
            state="readonly",
            width=20
        )
        approver_box.pack(pady=(0, 15))
        approver_box.current(0)

        button_frame = ttk.Frame(frame)
        button_frame.pack()

        def confirm_selection():
            nonlocal selected_approver
            selected_approver = Approver[approver_name.get()]
            selection_window.destroy()

        ttk.Button(
            button_frame,
            text="Approve",
            command=confirm_selection
        ).pack(side="left", padx=5)

        ttk.Button(
            button_frame,
            text="Cancel",
            command=selection_window.destroy
        ).pack(side="left", padx=5)

        selection_window.protocol("WM_DELETE_WINDOW", selection_window.destroy)
        self.root.wait_window(selection_window)

        return selected_approver


    def go_back(self):
        """Close the claims browser and return to the browser menu."""
        self.root.destroy()

        import browser
        browser.main()


def main():
    root = tk.Tk()
    ClaimsBrowser(root)
    root.mainloop()


if __name__ == "__main__":
    main()
