# Code for browser selection user interface
# Opens the claims browser or employees browser

# import
import tkinter as tk
from tkinter import ttk


# constants
WINDOW_WIDTH = 400
WINDOW_HEIGHT = 220


# functions

class BrowserMenu:
    """Tkinter menu used to select a browser."""

    def __init__(self, root):
        self.root = root

        root.title("Database Browser")
        root.geometry(f"{WINDOW_WIDTH}x{WINDOW_HEIGHT}")
        root.resizable(False, False)

        # create main frame container
        frame = ttk.Frame(root, padding=25)
        frame.pack(fill="both", expand=True)

        ttk.Label(
            frame,
            text="Select a Browser",
            font=("TkDefaultFont", 16, "bold")
        ).pack(pady=(5, 20))

        # create browser buttons
        ttk.Button(
            frame,
            text="Claims Browser",
            command=self.open_claims_browser
        ).pack(fill="x", pady=5)

        ttk.Button(
            frame,
            text="Employees Browser",
            command=self.open_employees_browser
        ).pack(fill="x", pady=5)


    def open_claims_browser(self):
        """Close the menu and open the claims browser."""
        self.root.destroy()

        import claims_browser
        claims_browser.main()


    def open_employees_browser(self):
        """Close the menu and open the employees browser."""
        self.root.destroy()

        import employees_browser
        employees_browser.main()


def main():
    root = tk.Tk()
    BrowserMenu(root)
    root.mainloop()


if __name__ == "__main__":
    main()
