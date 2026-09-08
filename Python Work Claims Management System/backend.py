# Code for the backend logic of the application
# Connects the user interface with the database and handles user inputs

# import
from defs import *
import database
import helpers


# variables


# functions

# Function to receive data from user interface
def receive_claim_data(claim: Claim, employee_name: str) -> None:
    """
    Receive claim data from the user interface and process it.
    Args:
        claim (Claim): A Claim object containing the claim data.
        employee_name (str): The name of the employee submitting the claim.
    """
    # Validate the claim data
    validate_claim_data(claim, employee_name)

    # Claim successfully validated
    
    # Copy the receipt image to the designated directory
    new_receipt_path = helpers.copy_image_to_directory(claim.receipt_path)
    claim.receipt_path = new_receipt_path
    
    # Send the validated claim data to the database
    database.insert_claim(claim)


# Function to validate data received from the user interface
def validate_claim_data(claim: Claim, employee_name: str) -> None:
    '''
    Validate the claim data received from the user interface.
    Throws ValueError with a user-friendly message when a value is invalid.
    '''
    # Validate employee exist
    if not database.employee_exists(claim.employee_id, employee_name):
        raise ValueError(f"Employee with ID {claim.employee_id} and name '{employee_name}' does not exist.")
    
    # Checks if the yearly claim limit has been exceeded for the employee
    claim_year = claim.claim_date.year
    claimed_amount = database.get_total_claim_amount_at(claim.employee_id, claim_year)
    if claimed_amount + claim.amount > YEARLY_CLAIM_LIMIT:
        raise ValueError(f'''Yearly claim limit of {YEARLY_CLAIM_LIMIT} exceeded for employee {employee_name}.\n
                         Current claimed amount: {claimed_amount}\n
                         Claimable amount left: {YEARLY_CLAIM_LIMIT - claimed_amount}\n
                         Attempted claim amount: {claim.amount}.''')
