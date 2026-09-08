# Helper functions for the application

# import
from defs import Claim, ClaimType, IMAGE_FILE_PATH
from datetime import date
from pathlib import Path
import uuid


def claim_tuple_to_object(claim_tuple) -> Claim:
    """
    Convert a claim tuple from the database to a Claim object.
    Args:
        claim_tuple (tuple): A tuple representing a claim from the database.
    Returns:
        Claim: A Claim object with the corresponding data.
    """
    return Claim(
        claim_id=claim_tuple[0],
        employee_id=claim_tuple[1],
        claim_date=date.fromisoformat(claim_tuple[2]),
        venue=claim_tuple[3],
        claim_type=ClaimType[claim_tuple[4]],
        amount=claim_tuple[5],
        note=claim_tuple[6],
        receipt_path=claim_tuple[7],
        approved_by_finance=bool(claim_tuple[8]),
        approved_by_ceo=bool(claim_tuple[9]),
    )


def claim_list_to_objects(claim_list) -> list[Claim]:
    """
    Convert a list of claim tuples from the database to a list of Claim objects.
    Args:
        claim_list (list): A list of tuples representing claims from the database.
    Returns:
        list: A list of Claim objects with the corresponding data.
    """
    return [claim_tuple_to_object(claim) for claim in claim_list]


def copy_image_to_directory(source_path: str) -> str:
    """
    Copy an image file to the designated images directory with a unique filename.
    Args:
        source_path (str): The path to the source image file.
    Returns:
        str: The path to the copied image file in the images directory.
    """
    # Ensure the images directory exists
    images_dir = Path(IMAGE_FILE_PATH)
    images_dir.mkdir(parents=True, exist_ok=True)

    # Generate a unique filename for the copied image
    unique_filename = f"{uuid.uuid4()}{Path(source_path).suffix}"
    destination_path = images_dir / unique_filename

    # Copy the image file to the destination path
    with open(source_path, 'rb') as src_file:
        with open(destination_path, 'wb') as dest_file:
            dest_file.write(src_file.read())

    return str(destination_path)


def clear_image_directory() -> None:
    """
    Clear all image files in the designated images directory.
    """
    images_dir = Path(IMAGE_FILE_PATH)
    if images_dir.exists() and images_dir.is_dir():
        for image_file in images_dir.iterdir():
            if image_file.is_file():
                image_file.unlink()
                

def remove_image_file(image_path: str) -> None:
    """
    Remove a specific image file from the designated images directory.
    Args:
        image_path (str): The path to the image file to be removed.
    """
    try:
        image_file = Path(image_path)
        if image_file.exists() and image_file.is_file():
            image_file.unlink()
    except Exception as e:
        return