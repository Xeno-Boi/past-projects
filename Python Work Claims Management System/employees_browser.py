# Code for employees browser user interface
# Displays all employees stored in the database

# import
import tkinter as tk
from tkinter import messagebox, ttk
from defs import Claim
import database


# constants
WINDOW_WIDTH = 900
WINDOW_HEIGHT = 600


# functions

class EmployeesBrowser:
    """Tkinter browser used to display all employees."""

    def __init__(self, root):
        self.root = root
        self.employees: list[tuple] = []
        self.employee_claims: dict[int, list[Claim]] = {}

        root.title("Employees Browser")
        root.geometry(f"{WINDOW_WIDTH}x{WINDOW_HEIGHT}")
        root.minsize(700, 450)

        # create main frame container
        frame = ttk.Frame(root, padding=15)
        frame.pack(fill="both", expand=True)

        # create heading and navigation buttons
        heading_frame = ttk.Frame(frame)
        heading_frame.pack(fill="x", pady=(0, 10))

        ttk.Label(
            heading_frame,
            text="All Employees",
            font=("TkDefaultFont", 16, "bold")
        ).pack(side="left")

        ttk.Button(
            heading_frame,
            text="Refresh",
            command=self.load_employees
        ).pack(side="right")

        ttk.Button(
            heading_frame,
            text="Back",
            command=self.go_back
        ).pack(side="right", padx=(0, 8))

        self.status = ttk.Label(heading_frame, text="")
        self.status.pack(side="right", padx=15)

        # create employee table
        table_frame = ttk.Frame(frame)
        table_frame.pack(fill="both", expand=True)

        columns = (
            "employee_id",
            "employee_name",
            "claim_count",
            "total_amount"
        )

        self.employee_table = ttk.Treeview(
            table_frame,
            columns=columns,
            show="headings",
            selectmode="browse"
        )

        headings = {
            "employee_id": "Employee ID",
            "employee_name": "Employee Name",
            "claim_count": "Number of Claims",
            "total_amount": "Total Claimed"
        }

        widths = {
            "employee_id": 100,
            "employee_name": 250,
            "claim_count": 130,
            "total_amount": 140
        }

        for column in columns:
            self.employee_table.heading(column, text=headings[column])
            self.employee_table.column(
                column,
                width=widths[column],
                minwidth=80,
                anchor="center"
            )

        self.employee_table.column("employee_name", anchor="w")
        self.employee_table.bind("<<TreeviewSelect>>", self.show_employee_details)

        # create table scrollbar
        vertical_scrollbar = ttk.Scrollbar(
            table_frame,
            orient="vertical",
            command=self.employee_table.yview
        )

        self.employee_table.configure(
            yscrollcommand=vertical_scrollbar.set
        )

        self.employee_table.grid(row=0, column=0, sticky="nsew")
        vertical_scrollbar.grid(row=0, column=1, sticky="ns")
        table_frame.rowconfigure(0, weight=1)
        table_frame.columnconfigure(0, weight=1)

        # create selected employee details area
        details_frame = ttk.LabelFrame(
            frame,
            text="Selected Employee Details",
            padding=10
        )
        details_frame.pack(fill="x", pady=(12, 0))

        self.details = tk.Text(
            details_frame,
            height=7,
            wrap="word",
            state="disabled"
        )
        self.details.pack(fill="x")

        self.load_employees()


    def load_employees(self):
        """Load all employees and their claims into the table."""
        try:
            employees = database.get_all_employees()
            claims = database.get_all_claims()
        except Exception as error:
            messagebox.showerror(
                "Database Error",
                f"Could not load employees.\n\n{error}",
                parent=self.root
            )
            return

        # clear old table rows
        for item in self.employee_table.get_children():
            self.employee_table.delete(item)

        self.employees = employees
        self.employee_claims = {
            employee_id: [] for employee_id, employee_name in employees
        }

        # group claims by employee id
        for claim in claims:
            if claim.employee_id in self.employee_claims:
                self.employee_claims[claim.employee_id].append(claim)

        # insert current employees into table
        for row, (employee_id, employee_name) in enumerate(self.employees):
            employee_claims = self.employee_claims[employee_id]
            total_amount = sum(claim.amount for claim in employee_claims)

            self.employee_table.insert(
                "",
                "end",
                iid=str(row),
                values=(
                    employee_id,
                    employee_name,
                    len(employee_claims),
                    f"{total_amount:,.2f}"
                )
            )

        self.status.config(text=f"{len(self.employees)} employee(s)")
        self.clear_employee_details()


    def show_employee_details(self, event=None):
        """Display details for the selected employee."""
        selected_items = self.employee_table.selection()
        if not selected_items:
            self.clear_employee_details()
            return

        employee_id, employee_name = self.employees[int(selected_items[0])]
        claims = self.employee_claims[employee_id]
        total_amount = sum(claim.amount for claim in claims)
        approved_claims = sum(
            1 for claim in claims
            if claim.approved_by_finance and claim.approved_by_ceo
        )
        claim_ids = ", ".join(str(claim.claim_id) for claim in claims)

        if not claim_ids:
            claim_ids = "No claims"

        details_text = (
            f"Employee ID: {employee_id}\n"
            f"Employee name: {employee_name}\n"
            f"Number of claims: {len(claims)}\n"
            f"Fully approved claims: {approved_claims}\n"
            f"Total claimed: {total_amount:,.2f}\n"
            f"Claim IDs: {claim_ids}"
        )

        self.details.config(state="normal")
        self.details.delete("1.0", tk.END)
        self.details.insert("1.0", details_text)
        self.details.config(state="disabled")


    def clear_employee_details(self):
        """Clear the selected employee details area."""
        self.details.config(state="normal")
        self.details.delete("1.0", tk.END)
        self.details.insert("1.0", "Select an employee to view their details.")
        self.details.config(state="disabled")


    def go_back(self):
        """Close the employees browser and return to the browser menu."""
        self.root.destroy()

        import browser
        browser.main()


def main():
    root = tk.Tk()
    EmployeesBrowser(root)
    root.mainloop()


if __name__ == "__main__":
    main()
