# Work Claims Management System

The Work Claims Management System is a desktop application for submitting, documenting, viewing, and approving workplace expense claims. It provides a claim-submission form for employees, a claims browser for reviewers, and an employee browser for viewing claim summaries. Claim data is stored locally in SQLite, while receipt images are copied into the application's image directory.

The application helps replace a manual claims process with a consistent workflow that validates employee details, records supporting information, enforces a yearly claim limit, and tracks separate Finance and CEO approvals.

## Dependencies

The supplied development environment uses **Python 3.13.9**. Use that version to match the environment.

- `Pillow` = `12.0.0`
	Loads and resizes receipt images in the claims browser.

`requirements.txt` pins the application's only third-party Python dependency.

The modules `sqlite3`, `tkinter`, `datetime`, `dataclasses`, `enum`, `pathlib`, and `uuid` are part of Python's standard library and need no separate installation. SQLite is provided by Python, and Tkinter is included when Python is installed with its Tcl/Tk component.

## Instructions to Run

### 1. Open a terminal in the project folder

Run the following commands from the folder containing `app.py` and `database_initialization.py`. The database and image paths are relative to the current working directory.

### 2. Install Python

Install Python 3.13.9. On Windows, make sure the optional Tcl/Tk component is selected during installation so that Tkinter is available.

Confirm the Python version:

```powershell
python --version
```

### 3. Install dependencies

Upgrade pip and install the pinned dependency list:

```powershell
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Do not install `sqlite3` or `tkinter` with pip. They are supplied by Python.

### 4. Initialize the database

Create the database tables and insert the sample data configured in `defs.py`:

```powershell
python database_initialization.py
```

Only run this script when initializing a new database. Running it repeatedly against an existing populated database can insert the configured sample records more than once.

### 5. Start the application

Open the employee claim-submission form:

```powershell
python app.py
```

Open the browser menu for claims and employee records:

```powershell
python browser.py
```

The individual browsers can also be started directly:

```powershell
python claims_browser.py
python employees_browser.py
```

The application requires a graphical desktop session because it uses Tkinter.

## Database Setup

The active database is stored at `database/claims.db`.

### First-time initialization

Create the database tables and add the sample data configured in `defs.py` by running:

```powershell
python database_initialization.py
```

Only run this script when initializing a new database. Running it repeatedly against an existing populated database can insert the configured sample records more than once.

### Resetting the database

To reset the database programmatically, run:

```powershell
python -c "import database; database.reset_database()"
```

This deletes the current database and stored receipt images, recreates the database tables, and inserts the configured sample data. Existing claims and receipt files are permanently removed.

Alternatively, manually delete `database/claims.db` and remove all files from the `images/` directory. Then recreate and initialize the database with:

```powershell
python database_initialization.py
```

Clearing both locations prevents receipt images belonging to deleted claim records from remaining in the application.

## Running the Application

### Submit claims

Open the claim-submission form with:

```powershell
python app.py
```

The form collects the employee name and ID, claim date, venue, claim type, amount, optional note, and receipt image. It validates the form values, verifies the employee against the database, checks the yearly claim limit, copies the receipt image, and stores the claim.

### Browse database records

Open the browser menu with:

```powershell
python browser.py
```

The menu provides access to the Claims Browser and Employees Browser. Opening either browser closes the menu window. The Back button in each browser returns to the menu.

The individual browsers can also be started directly:

```powershell
python claims_browser.py
python employees_browser.py
```

## Browser Features

### Claims Browser

The claims browser can:

- Display claim IDs, employees, dates, venues, types, amounts, and approval states
- Display the selected claim's note, receipt path, and receipt image
- Filter records by Finance and CEO approval status
- Use synchronized shortcuts for both approved, both unapproved, and all records
- Approve a selected claim as Finance or CEO
- Delete a selected claim and its stored receipt image
- Refresh the displayed database records
- Return to the main browser menu

### Employees Browser

The employees browser can:

- Display every employee's ID and name
- Display each employee's claim count and total claimed amount
- Show the selected employee's fully approved claim count
- Show the claim IDs associated with the selected employee
- Refresh the displayed database records
- Return to the main browser menu

## Configuration

Application configuration and shared data structures are stored in `defs.py`.

The main configurable values are:

- `DB_PATH`
    path to the SQLite database

- `IMAGE_FILE_PATH`
    directory used to store copied receipt images

- `YEARLY_CLAIM_LIMIT`
    maximum total amount an employee can claim in one year

- `USE_SAMPLE_EMPLOYEES`
    controls whether initialization inserts sample employees

- `USE_SAMPLE_CLAIMS`
    controls whether initialization inserts sample claims

- `ClaimType`
    available claim categories

Update these settings before initializing the database when different initial data or application limits are required.

## Project Files and Directories

```text
py project/
|-- app.py
|-- backend.py
|-- browser.py
|-- claims_browser.py
|-- database.py
|-- database_initialization.py
|-- defs.py
|-- employees_browser.py
|-- helpers.py
|-- README.md
|-- database/
|   `-- claims.db
`-- images/
```

### Python files

- `app.py`
    Builds the Tkinter claim-submission form and performs client-side input validation.

- `backend.py`
    Validates employee identity and yearly claim limits, copies receipt images, and sends accepted claims to the database layer.

- `browser.py`
    Provides the main Tkinter menu for opening the claims browser or employees browser.

- `claims_browser.py`
    Displays, filters, approves, and deletes claims and shows claim details and receipt images.

- `database.py`
    Creates and manages the SQLite database and provides claim and employee operations.

- `database_initialization.py`
    Initializes the database and inserts the sample data enabled in `defs.py`.

- `defs.py`
    Stores configuration, enums, the `Claim` data class, and sample employee and claim records.

- `employees_browser.py`
    Displays employee claim counts, totals, approval summaries, and associated claim IDs.

- `helpers.py`
    Converts database claim rows into `Claim` objects and manages copied receipt-image files.


### Directories

- `database/`
    Contains the active SQLite database specified by `DB_PATH`.

- `images/`
    Contains receipt images copied into the project when claims are submitted.
