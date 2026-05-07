extends BuildingExtension
class_name PyreBuilding

"""
Framework for pyre building
"""


# signals game to update surrounding buildings active status
func handleDeath()->void:
	super.handleDeath()
