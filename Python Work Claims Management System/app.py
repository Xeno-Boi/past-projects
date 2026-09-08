# Code for user interface
# Collects user input data and send to backend for processing

# import
from datetime import date, datetime
import tkinter as tk
from tkinter import messagebox, ttk, filedialog
from pathlib import Path
from defs import Claim, ClaimType
import backend


# functions

def validate_claim_data(employee_id, employee_name, claim_date, venue, claim_type, amount, note, receipt_path) -> tuple[Claim, str]:
    """
    Validate obtained form values are in correct type and correct range.

    Raises ValueError with a user-friendly message when a value is invalid.
    """
    # strip whitespace
    employee_name = employee_name.strip()
    venue = venue.strip()
    note = note.strip()
    receipt_path = receipt_path.strip()

    # employee name
    if not employee_name:
        raise ValueError("Employee name is required.")
    if len(employee_name) > 100:
        raise ValueError("Employee name must be 100 characters or fewer.")

    # employee id
    try:
        employee_id = int(employee_id)
    except ValueError:
        raise ValueError("Employee ID must be a whole number.")
    if employee_id <= 0:
        raise ValueError("Employee ID must be greater than zero.")

    # claim date
    try:
        claim_date = datetime.strptime(claim_date.strip(), "%Y-%m-%d").date()
    except ValueError:
        raise ValueError("Claim date must be a valid date in YYYY-MM-DD format.")
    if claim_date > date.today():
        raise ValueError("Claim date cannot be in the future.")

    # venue
    if not venue:
        raise ValueError("Venue is required.")
    if len(venue) > 150:
        raise ValueError("Venue must be 150 characters or fewer.")

    # claim type
    try:
        claim_type = ClaimType[claim_type]
    except KeyError:
        raise ValueError("Please select a valid claim type.")

    # amount
    try:
        amount = float(amount)
    except ValueError:
        raise ValueError("Amount must be a number.")
    if amount <= 0:
        raise ValueError(
            "Amount must be greater than 0."
        )

    # note
    if len(note) > 500:
        raise ValueError("Note must be 500 characters or fewer.")
    
    # image
    if not receipt_path:
        raise ValueError("Receipt image is required.")

    return Claim(
        employee_id = employee_id,
        claim_date = claim_date,
        venue = venue,
        claim_type = claim_type,
        amount = round(amount, 2),
        note = note,
        receipt_path = receipt_path
        ), employee_name


class ClaimForm:
    """Tkinter form used to collect a new claim."""

    def __init__(self, root):
        self.root = root
        
        # parameters
        ENTRY_WIDTH = 36
        COMBOBOX_WIDTH = 33

        root.title("New Claim")
        root.resizable(False, False)

        # create frame container
        frame = ttk.Frame(root, padding=20)
        frame.grid(row=0, column=0, sticky="nsew")

        # initialize form variables
        self.employee_name = tk.StringVar()
        self.employee_id = tk.StringVar()
        self.claim_date = tk.StringVar(value=date.today().isoformat())
        self.venue = tk.StringVar()
        self.claim_type = tk.StringVar(value=None)
        self.amount = tk.StringVar()
        self.receipt_path = tk.StringVar()
        self.receipt_name = tk.StringVar(value="No file selected")

        # text fields
        fields = [
            ("Employee name", self.employee_name),
            ("Employee ID", self.employee_id),
            ("Claim date (YYYY-MM-DD)", self.claim_date),
            ("Venue", self.venue),
            ("Amount", self.amount),
        ]

        for row, (label, variable) in enumerate(fields):
            ttk.Label(frame, text=label).grid(row=row, column=0, sticky="w", padx=10, pady=5)
            ttk.Entry(frame, textvariable=variable, width=ENTRY_WIDTH).grid(
                row=row, column=1, sticky="ew", padx=(12, 0), pady=5
            )

        # Claim type combobox
        ttk.Label(frame, text="Claim type").grid(row=5, column=0, sticky="w", pady=5)
        type_box = ttk.Combobox(
            frame,
            textvariable=self.claim_type,
            values=[claim_type.name for claim_type in ClaimType],
            state="readonly",
            width=COMBOBOX_WIDTH,
        )
        type_box.grid(row=5, column=1, sticky="ew", padx=(12, 0), pady=5)

        # Note text area
        ttk.Label(frame, text="Note (optional)").grid(row=6, column=0, sticky="nw", pady=5)
        self.note = tk.Text(frame, width=ENTRY_WIDTH, height=5)
        self.note.grid(row=6, column=1, sticky="ew", padx=(12, 0), pady=5)

        self.status = ttk.Label(frame, text="", foreground="green")
        self.status.grid(row=7, column=0, columnspan=2, pady=(8, 0))
        
        # Receipt image selection
        ttk.Label(frame, text="Receipt image").grid(
            row=8, column=0, sticky="w", pady=5
        )
        ttk.Button(frame, text="Choose image", command=self.choose_image).grid(
            row=8, column=1, sticky="w", padx=(12, 0), pady=5
        )
        ttk.Label(frame, text="Selected file:").grid(
            row=9, column=0, sticky="w", pady=5
            )
        ttk.Label(frame, textvariable=self.receipt_name).grid(
            row=9, column=1, sticky="w", padx=(12, 0), pady=5
        )

        # Submit button
        ttk.Button(frame, text="Create claim", command=self.submit).grid(
            row=10, column=0, columnspan=2, pady=(15, 0)
        )
        
        self.clear_form()


    def choose_image(self):
        # clear previous selection
        self.receipt_path.set("")
        self.receipt_name.set("No file selected")
        
        path = filedialog.askopenfilename(
            title="Choose receipt image",
            filetypes=[
                ("Image files", "*.png *.jpg *.jpeg"),
                ("All files", "*.*")
            ]
        )

        if path:
            self.receipt_path.set(path)

            # Show only the file name
            self.receipt_name.set(Path(path).name)


    def submit(self):
        """Validate the form and create a Claim object."""
        try:
            claim, employee_name = validate_claim_data(
                self.employee_id.get(),
                self.employee_name.get(),
                self.claim_date.get(),
                self.venue.get(),
                self.claim_type.get(),
                self.amount.get(),
                self.note.get("1.0", "end-1c"),
                self.receipt_path.get()
            )
        except ValueError as error:
            self.status.config(text="")
            messagebox.showerror("Invalid claim", str(error), parent=self.root)
            return

        # Sends claim to backend
        try:
            backend.receive_claim_data(claim, employee_name)
        except Exception as error:
            messagebox.showerror("Invalid claim", str(error), parent=self.root)
            return

        # claim submit successful
        self.status.config(text="Claim submitted successfully.")
        messagebox.showinfo(
            "Success",
            f"Claim for {employee_name} was submitted successfully.",
            parent=self.root,
        )
        self.clear_form()


    def clear_form(self):
        """Clear the form while keeping today's date."""
        self.employee_name.set("")
        self.employee_id.set("")
        self.claim_date.set(date.today().isoformat())
        self.venue.set("")
        self.claim_type.set(None)
        self.amount.set("")
        self.note.delete("1.0", tk.END)
        self.receipt_path.set("")
        self.receipt_name.set("No file selected")


def main():
    root = tk.Tk()
    ClaimForm(root)
    root.mainloop()


if __name__ == "__main__":
    main()
