# Code for accessing and managing the Claims database

# import
import sqlite3
from pathlib import Path
from defs import *
import helpers


# functions ===========================================================

def connect_to_database() -> tuple[sqlite3.Connection, sqlite3.Cursor]:
    """Connect to the SQLite database at the specified path.
    Returns:
        A tuple containing the database connection and cursor.
    """
    # creates the parent directory for the database file if it doesn't exist
    Path(DB_PATH).parent.mkdir(parents=True, exist_ok=True)
    
    connection = sqlite3.connect(DB_PATH)
    cursor = connection.cursor()
    return connection, cursor


# Creation and deletion of database and tables ----------------------------------------

def initialize_database() -> None:
    """Initialize the database by creating the claims table if it doesn't exist.
    """
    print("Initializing database...")
    
    connection, cursor = connect_to_database()
    
    # create employees table
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS Employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
        )
        """
    )

    # create claims table
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS claims (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            claim_date DATE NOT NULL,
            venue TEXT NOT NULL,
            claim_type TEXT NOT NULL,
            amount REAL NOT NULL,
            note TEXT,
            receipt_path TEXT,
            approved_by_finance BOOLEAN DEFAULT FALSE,
            approved_by_ceo BOOLEAN DEFAULT FALSE,
            FOREIGN KEY (employee_id) REFERENCES Employees(id) ON DELETE CASCADE
        )
        """
    )
    
    
    connection.commit()
    connection.close()


def initialize_entries() -> None:
    """Initialize the database with sample entries for testing.
    """
    print("Initializing sample entries...")
    
    connection, cursor = connect_to_database()
    
    # Insert sample employees
    if USE_SAMPLE_EMPLOYEES:
        for employee in sample_employees:
            insert_employee(employee, connection=connection, cursor=cursor)
    
    # Insert sample claims for testing
    if USE_SAMPLE_CLAIMS:
        for claim in sample_claims:
            insert_claim(claim, connection=connection, cursor=cursor)
    
    connection.commit()
    connection.close()


def delete_database() -> None:
    """Delete the entire database file."""
    # Delete the database file if it exists
    import os
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
        
    # Clears Image directory
    helpers.clear_image_directory()


def initialize() -> None:
    """Initialize the database and populate it with sample entries."""
    initialize_database()
    initialize_entries()


def reset_database() -> None:
    """Reset the database by deleting all tables and reinitializing them."""
    delete_database()
    initialize()
    


# database access ----------------------------------------


# claims --------------------------

# INSERT

# Insert new claim
def insert_claim(claim: Claim, connection=None, cursor=None) -> None:
    """Insert a new claim into the database.

    Args:
        claim: A Claim object representing the claim to be inserted.
        Connection: Optional database connection to use (for batch inserts).
        Cursor: Optional database cursor to use (for batch inserts).
    """
    # create new connection and cursor if not provided
    new_connection = False
    if connection is None or cursor is None:
        connection, cursor = connect_to_database()
        new_connection = True  # Flag to indicate new connection and cursor are created

    # extract claim data
    employee_id = claim.employee_id
    claim_date = claim.claim_date.isoformat()  # Convert date to string
    venue = claim.venue
    claim_type = claim.claim_type
    amount = claim.amount
    note = claim.note
    receipt_path = claim.receipt_path
    
    # insert into database
    cursor.execute(
        "INSERT INTO claims (employee_id, claim_date, venue, claim_type, amount, note, receipt_path) VALUES (?, ?, ?, ?, ?, ?, ?)",
        (employee_id, claim_date, venue, claim_type.name, amount, note, receipt_path)
    )
    
    if new_connection:
        connection.commit()
        connection.close()
    

# DELETE

# delete claim by id
def delete_claim(claim_id: int) -> None:
    """Delete a claim from the database by its ID.

    Args:
        claim_id: ID of the claim to be deleted.
    """
    connection, cursor = connect_to_database()
    
    # get image path of claim to delete image file
    cursor.execute("SELECT receipt_path FROM claims WHERE id = ?", (claim_id,))
    receipt_path = cursor.fetchone()
    
    cursor.execute("DELETE FROM claims WHERE id = ?", (claim_id,))
    
    connection.commit()
    connection.close()
    
    # delete the associated image file
    if receipt_path:
        helpers.remove_image_file(receipt_path[0])
    

# delete all claims
def delete_all_claims() -> None:
    """Delete all claims from the database."""
    print("Deleting all claims...")
    
    connection, cursor = connect_to_database()
    
    cursor.execute("DELETE FROM claims")
    
    connection.commit()
    connection.close()
    
    # delete all images in the image directory
    helpers.clear_image_directory()


# GET

# get all claims
def get_all_claims() -> list[Claim]:
    '''
    Get all claims from the database.
    Returns:
        A list of Claim objects representing all claims in the database.
    '''
    connection, cursor = connect_to_database()
    
    cursor.execute("SELECT * FROM claims")
    claims = cursor.fetchall()
    
    connection.close()
    return helpers.claim_list_to_objects(claims)


# get all claims that are approved by both finance and CEO
def get_approved_claims() -> list[Claim]:
    '''
    Get all claims that are approved by both finance and CEO.
    Returns:
        A list of Claim objects representing all claims in the database.
    '''
    
    connection, cursor = connect_to_database()
    
    cursor.execute("SELECT * FROM claims WHERE approved_by_finance = TRUE AND approved_by_ceo = TRUE")
    approved_claims = cursor.fetchall()
    
    connection.close()
    return helpers.claim_list_to_objects(approved_claims)


# get all claims that are not approved by finance or CEO
def get_unapproved_claims() -> list[Claim]:
    '''
    Get all claims that are not approved by finance or CEO.
    Returns:
        A list of Claim objects representing all claims in the database.
    '''
    connection, cursor = connect_to_database()
    
    cursor.execute("SELECT * FROM claims WHERE approved_by_finance = FALSE OR approved_by_ceo = FALSE")
    unapproved_claims = cursor.fetchall()
    
    connection.close()
    return helpers.claim_list_to_objects(unapproved_claims)


# get all claims approved by specific approver
def get_approved_claims_by(approver: Approver) -> list[Claim]:
    """Get all claims approved by a specific approver.

    Args:
        approver: The approver (from Approver enum) to filter claims by.

    Returns:
        A list of Claim objects representing the approved claims.
    """
    connection, cursor = connect_to_database()
    
    if approver == Approver.CEO:
        cursor.execute("SELECT * FROM claims WHERE approved_by_ceo = TRUE")
    elif approver == Approver.Finance:
        cursor.execute("SELECT * FROM claims WHERE approved_by_finance = TRUE")
    else:
        raise ValueError("Invalid approver specified.")
    
    approved_claims = cursor.fetchall()
    
    connection.close()
    return helpers.claim_list_to_objects(approved_claims)


# get all claims not approved by specific approver
def get_unapproved_claims_by(approver: Approver) -> list[Claim]:
    """Get all claims not approved by a specific approver.

    Args:
        approver: The approver (from Approver enum) to filter claims by.

    Returns:
        A list of Claim objects representing the unapproved claims.
    """
    connection, cursor = connect_to_database()
    
    if approver == Approver.CEO:
        cursor.execute("SELECT * FROM claims WHERE approved_by_ceo = FALSE")
    elif approver == Approver.Finance:
        cursor.execute("SELECT * FROM claims WHERE approved_by_finance = FALSE")
    else:
        raise ValueError("Invalid approver specified.")
    
    unapproved_claims = cursor.fetchall()
    
    connection.close()
    return helpers.claim_list_to_objects(unapproved_claims)


# get all claims by employee id
def get_claims_by_employee(employee_id: int) -> list[Claim]:
    '''Get all claims made by a specific employee.'''
    connection, cursor = connect_to_database()
    
    cursor.execute("SELECT * FROM claims WHERE employee_id = ?", (employee_id,))
    employee_claims = cursor.fetchall()
    
    connection.close()
    return helpers.claim_list_to_objects(employee_claims)


# get sum of claims by employee id for current year
def get_total_claim_amount(employee_id: int) -> float:
    '''Get the total sum of new claims made by a specific employee in the current year.
    
    Args:
        employee_id: ID of the employee whose claims should be totaled.

    Returns:
        The total claim amount, or ``0.0`` if there are no matching claims.
    '''
    connection, cursor = connect_to_database()
    
    cursor.execute("""
        SELECT SUM(amount) FROM claims 
        WHERE employee_id = ? AND claim_date >= date('now', 'start of year') AND claim_date <= date('now', 'start of year', '+1 year')
    """, (employee_id,))
    total_sum = cursor.fetchone()[0]
    
    connection.close()
    return total_sum if total_sum is not None else 0.0


# get sum of claims by employee id for a specific year
def get_total_claim_amount_at(employee_id: int, year: int) -> float:
    """Get an employee's total claim amount for a specific year.

    Args:
        employee_id: ID of the employee whose claims should be totaled.
        year: Four-digit calendar year.

    Returns:
        The total claim amount, or ``0.0`` if there are no matching claims.

    Raises:
        ValueError: If ``year`` is outside its valid range.
    """
    if not isinstance(year, int) or isinstance(year, bool) or not 1 <= year <= 9999:
        raise ValueError("year must be an integer between 1 and 9999")

    connection, cursor = connect_to_database()
    cursor.execute(
        """
        SELECT COALESCE(SUM(amount), 0.0)
        FROM claims
        WHERE employee_id = ?
          AND CAST(strftime('%Y', claim_date) AS INTEGER) = ?
        """,
        (employee_id, year),
    )
    total_sum = cursor.fetchone()[0]

    connection.close()
    return float(total_sum)


# approve claim by id and approver
def approve_claim(claim_id: int, approver: Approver) -> None:
    """Approve a claim on behalf of the specified approver.

    Args:
        claim_id: ID of the claim to approve.
        approver: ``Approver.CEO`` or ``Approver.Finance``.

    Raises:
        ValueError: If ``approver`` is not a supported :class:`Approver` value.
    """
    if approver == Approver.CEO:
        approval_column = "approved_by_ceo"
    elif approver == Approver.Finance:
        approval_column = "approved_by_finance"
    else:
        raise ValueError("Invalid approver specified.")

    connection, cursor = connect_to_database()
    cursor.execute(
        f"UPDATE claims SET {approval_column} = TRUE WHERE id = ?",
        (claim_id,),
    )

    connection.commit()
    connection.close()


# employees --------------------------

# INSERT

# Insert new employee
def insert_employee(name: str, connection=None, cursor=None) -> None:
    """Insert a new employee into the database.

    Args:
        name: Name of the employee to be added.
        Connection: Optional database connection to use (for batch inserts).
        Cursor: Optional database cursor to use (for batch inserts).
    """
    new_connection = False
    if connection is None or cursor is None:
        connection, cursor = connect_to_database()
        new_connection = True  # Flag to indicate new connection and cursor are created

    cursor.execute("INSERT INTO Employees (name) VALUES (?)", (name,))
    
    if new_connection:
        connection.commit()
        connection.close()


# DELETE

# Delete employee by id
def delete_employee(employee_id: int) -> None:
    """Delete an employee from the database by their ID.

    Args:
        employee_id: ID of the employee to be deleted.
    """
    connection, cursor = connect_to_database()
    
    cursor.execute("DELETE FROM Employees WHERE id = ?", (employee_id,))
    
    connection.commit()
    connection.close()
    

# delete all employees
def delete_all_employees() -> None:
    """Delete all employees from the database."""
    print("Deleting all employees...")
    
    connection, cursor = connect_to_database()
    
    cursor.execute("DELETE FROM Employees")
    
    connection.commit()
    connection.close()
    

# GET

# get all employees
def get_all_employees() -> list[tuple]:
    '''Get all employees from the database.
    Returns:
        A list of tuples representing all employees.
    '''
    connection, cursor = connect_to_database()
    
    cursor.execute("SELECT * FROM Employees")
    employees = cursor.fetchall()
    
    connection.close()
    return employees


# get employee by id
def get_employee_by_id(employee_id: int) -> tuple:
    '''Get an employee by their ID.
    Args:
        employee_id: ID of the employee to retrieve.
    Returns:
        A tuple representing the employee, or None if not found.
    '''
    connection, cursor = connect_to_database()
    
    cursor.execute("SELECT * FROM Employees WHERE id = ?", (employee_id,))
    employee = cursor.fetchone()
    
    connection.close()
    return employee


# check if employee exists by id and name
def employee_exists(employee_id: int, name: str = None) -> bool:
    '''Check if an employee exists in the database by their ID and name.
    Args:
        employee_id: ID of the employee to check.
        name: Optional name of the employee to check.
    Returns:
        True if the employee exists, False otherwise.
    '''
    connection, cursor = connect_to_database()
    
    if name is not None:
        cursor.execute("SELECT 1 FROM Employees WHERE id = ? AND name = ?", (employee_id, name))
    else:
        cursor.execute("SELECT 1 FROM Employees WHERE id = ?", (employee_id,))
    exists = cursor.fetchone() is not None
    
    connection.close()
    return exists


# Other query functions
def query(query: str, params: tuple = ()) -> list[tuple]:
    """Execute a custom SQL query on the database.

    Args:
        query: The SQL query string to execute.
        params: Optional tuple of parameters to pass to the query.

    Returns:
        A list of tuples representing the query results.
    """
    connection, cursor = connect_to_database()
    
    cursor.execute(query, params)
    results = cursor.fetchall()
    
    connection.close()
    return results