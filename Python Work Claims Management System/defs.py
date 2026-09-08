# Define file
# Stores constants and parameters used in the project

# import
from dataclasses import dataclass
from datetime import date
from enum import Enum, auto


# Paths ========================================================================

# Database
DB_PATH = "database/claims.db"

# Image file path
IMAGE_FILE_PATH = "images/"


# Configs ========================================================================

USE_SAMPLE_EMPLOYEES = True # True to insert sample employees during init
USE_SAMPLE_CLAIMS = True    # True to insert sample claims during init

YEARLY_CLAIM_LIMIT = 10000.00 # Maximum claim amount allowed for a year


# Claim Enums ========================================================================

# Claim types
class ClaimType(Enum):
    """Enumeration for different types of claims."""

    MEDICAL = auto()
    TRAVEL = auto()
    ACCIDENT = auto()
    FOOD = auto()
    MSIC = auto()


# Claim approvers
class Approver(Enum):
    """Enumeration for different approvers of claims."""

    CEO = auto()
    Finance = auto()
    

# Claim Data Class ========================================================================
@dataclass
class Claim:
    """Data class representing a claim."""

    claim_id: int = None
    employee_id: int = ""
    claim_date: date = None
    venue: str = ""
    claim_type: ClaimType = None
    amount: float = 0.0
    note: str = ""
    receipt_path: str = ""
    approved_by_finance: bool = False
    approved_by_ceo: bool = False
    
    
# database test data ==============================================================

# employees
sample_employees = [
    ("Alice"),
    ("Bob"),
    ("Charlie"),
    ("David")
]

# claims
sample_claims_data = [
    (1, date(2024, 1, 5), "City Hospital", ClaimType.MEDICAL, 150.00, "Annual checkup", "images/receipt01.jpg"),
    (2, date(2024, 1, 12), "Central Cafe", ClaimType.FOOD, 42.50, "Client lunch", "images/receipt02.jpg"),
    (3, date(2024, 2, 3), "Metro Rail", ClaimType.TRAVEL, 18.00, "Travel to meeting", "images/receipt03.jpg"),
    (4, date(2024, 2, 18), "Westside Clinic", ClaimType.MEDICAL, 86.75, "Doctor consultation", "images/receipt04.jpg"),
    (1, date(2024, 3, 7), "Grand Hotel", ClaimType.TRAVEL, 320.00, "Conference hotel", "images/receipt05.jpg"),
    (2, date(2024, 3, 15), "Office Bistro", ClaimType.FOOD, 65.20, "Team dinner", "images/receipt06.jpg"),
    (3, date(2024, 4, 2), "Health Pharmacy", ClaimType.MEDICAL, 34.90, "Prescription medicine", "images/receipt07.jpg"),
    (4, date(2024, 4, 21), "City Taxi", ClaimType.TRAVEL, 27.50, "Airport transfer", "images/receipt08.jpg"),
    (1, date(2024, 5, 9), "Tech Supplies", ClaimType.MSIC, 49.99, "USB adapters", "images/receipt09.jpg"),
    (2, date(2024, 5, 25), "Emergency Clinic", ClaimType.ACCIDENT, 210.00, "Minor workplace injury", "images/receipt10.jpg"),
    (3, date(2024, 6, 4), "Harbour Restaurant", ClaimType.FOOD, 91.30, "Client meeting", "images/receipt11.jpg"),
    (4, date(2024, 6, 19), "Express Airline", ClaimType.TRAVEL, 480.00, "Regional business trip", "images/receipt12.jpg"),
    (1, date(2024, 7, 8), "Dental Centre", ClaimType.MEDICAL, 175.00, "Dental treatment", "images/receipt13.jpg"),
    (2, date(2024, 7, 23), "Stationery World", ClaimType.MSIC, 28.40, "Office stationery", "images/receipt14.jpg"),
    (3, date(2024, 8, 6), "Garden Cafe", ClaimType.FOOD, 38.60, "Working lunch", "images/receipt15.jpg"),
    (4, date(2024, 8, 17), "City Hospital", ClaimType.ACCIDENT, 350.00, "Emergency treatment", "images/receipt16.jpg"),
    (1, date(2024, 9, 10), "Metro Rail", ClaimType.TRAVEL, 22.00, "Customer site visit", "images/receipt17.jpg"),
    (2, date(2024, 9, 28), "Vision Clinic", ClaimType.MEDICAL, 120.00, "Eye examination", "images/receipt18.jpg"),
    (3, date(2024, 10, 11), "Grand Hotel", ClaimType.TRAVEL, 295.00, "Training accommodation", "images/receipt19.jpg"),
    (4, date(2024, 10, 26), "Central Cafe", ClaimType.FOOD, 54.80, "Project lunch", "images/receipt20.jpg"),
    (1, date(2024, 11, 5), "Computer Store", ClaimType.MSIC, 79.90, "Keyboard replacement", "images/receipt21.jpg"),
    (2, date(2024, 11, 20), "Physio Centre", ClaimType.ACCIDENT, 165.00, "Injury physiotherapy", "images/receipt22.jpg"),
    (3, date(2024, 12, 9), "Office Bistro", ClaimType.FOOD, 103.25, "Year-end team meal", "images/receipt23.jpg"),
    (4, date(2024, 12, 18), "City Taxi", ClaimType.TRAVEL, 31.00, "Late-night transport", "images/receipt24.jpg"),
    (1, date(2025, 1, 8), "Westside Clinic", ClaimType.MEDICAL, 95.00, "Medical consultation", "images/receipt25.jpg"),
    (2, date(2025, 1, 24), "Express Airline", ClaimType.TRAVEL, 525.00, "Overseas client visit", "images/receipt26.jpg"),
    (3, date(2025, 2, 6), "Harbour Restaurant", ClaimType.FOOD, 76.40, "Supplier lunch", "images/receipt27.jpg"),
    (4, date(2025, 2, 22), "Tech Supplies", ClaimType.MSIC, 19.95, "Laptop cable", "images/receipt28.jpg"),
    (1, date(2025, 3, 4), "Emergency Clinic", ClaimType.ACCIDENT, 275.00, "Sprained ankle treatment", "images/receipt29.jpg"),
    (2, date(2025, 3, 19), "Metro Rail", ClaimType.TRAVEL, 24.00, "Office travel", "images/receipt30.jpg"),
    (3, date(2025, 4, 12), "Health Pharmacy", ClaimType.MEDICAL, 41.60, "Cold medicine", "images/receipt31.jpg"),
    (4, date(2025, 4, 27), "Garden Cafe", ClaimType.FOOD, 47.90, "Breakfast meeting", "images/receipt32.jpg"),
    (1, date(2025, 5, 3), "Grand Hotel", ClaimType.TRAVEL, 410.00, "Sales conference", "images/receipt33.jpg"),
    (2, date(2025, 5, 16), "Dental Centre", ClaimType.MEDICAL, 230.00, "Dental procedure", "images/receipt34.jpg"),
    (3, date(2025, 6, 8), "Stationery World", ClaimType.MSIC, 36.75, "Presentation materials", "images/receipt35.jpg"),
    (4, date(2025, 6, 29), "City Hospital", ClaimType.ACCIDENT, 425.00, "Accident examination", "images/receipt36.jpg"),
    (1, date(2025, 7, 7), "Central Cafe", ClaimType.FOOD, 59.50, "Department lunch", "images/receipt37.jpg"),
    (2, date(2025, 7, 21), "City Taxi", ClaimType.TRAVEL, 44.00, "Client transport", "images/receipt38.jpg"),
    (3, date(2025, 8, 13), "Vision Clinic", ClaimType.MEDICAL, 135.00, "New glasses examination", "images/receipt39.jpg"),
    (4, date(2025, 8, 30), "Express Airline", ClaimType.TRAVEL, 610.00, "Annual conference flight", "images/receipt40.jpg"),
    (1, date(2026, 1, 14), "Office Bistro", ClaimType.FOOD, 82.10, "Planning meeting", "images/receipt41.jpg"),
    (2, date(2026, 2, 9), "Computer Store", ClaimType.MSIC, 125.00, "External hard drive", "images/receipt42.jpg"),
    (3, date(2026, 3, 18), "Physio Centre", ClaimType.ACCIDENT, 190.00, "Back injury treatment", "images/receipt43.jpg"),
    (4, date(2026, 4, 5), "Metro Rail", ClaimType.TRAVEL, 16.50, "Local business travel", "images/receipt44.jpg"),
    (1, date(2026, 5, 22), "City Hospital", ClaimType.MEDICAL, 205.00, "Specialist appointment", "images/receipt45.jpg"),
    (2, date(2026, 6, 11), "Harbour Restaurant", ClaimType.FOOD, 112.80, "Customer dinner", "images/receipt46.jpg"),
    (3, date(2026, 7, 3), "Grand Hotel", ClaimType.TRAVEL, 365.00, "Project workshop hotel", "images/receipt47.jpg"),
    (4, date(2026, 7, 25), "Tech Supplies", ClaimType.MSIC, 58.30, "Computer accessories", "images/receipt48.jpg"),
    (1, date(2026, 8, 15), "Westside Clinic", ClaimType.MEDICAL, 145.00, "Routine checkup", "images/receipt49.jpg"),
    (2, date(2026, 8, 20), "Garden Cafe", ClaimType.FOOD, 68.75, "Business lunch", "images/receipt50.jpg"),
]

sample_claims = [Claim(None, *data) for data in sample_claims_data]
