extends Node2D

# property
@export var minigame : int = defs.MINIGAME.SELF_CHECKOUT_GAME

@onready var itemTexture = $"MarginContainer/HBoxContainer/ui-item/TextureRect"
var obj0Textures = [load("res://assets/items/item1_side1.png"),load("res://assets/items/item1_side2.png")]
var obj1Textures = [load("res://assets/items/item2_side1.png"),load("res://assets/items/item2_side2.png"),load("res://assets/items/item2_side3.png"),load("res://assets/items/item2_side4.png"),load("res://assets/items/item2_side5.png"),load("res://assets/items/item2_side6.png")]
var obj2Textures = [load("res://assets/items/item3_side1.png"),load("res://assets/items/item3_side2.png"),load("res://assets/items/item3_side3.png"),load("res://assets/items/item3_side4.png"),load("res://assets/items/item3_side5.png"),load("res://assets/items/item3_side6.png")]
var obj3Textures = [load("res://assets/items/item4_side1.png"),load("res://assets/items/item4_side2.png")]
var obj4Textures = [load("res://assets/items/item5_side1.png"),load("res://assets/items/item5_side2.png"),load("res://assets/items/item5_side3.png"),load("res://assets/items/item5_side4.png"),load("res://assets/items/item5_side5.png"),load("res://assets/items/item5_side6.png")]
signal endOfGame(minigame : int)
signal sendAnxietyChange(anxiety: int)
# child
var anxiety
var goalNumber = 5
var curObj = 0
var objList = []
class item:
	var sides
	var correctSide
	var currentSide
	var sideMap
	var textures = []

class sideMaps:
	# position 0 for each obj = up, 1 = down, 2 = left, 3 = right
	static var twoSide= [[2,2,2,2],[1,1,1,1]]
	static var sixSide = [[3,4,5,2],[3,4,1,6],[5,2,1,6],[2,5,1,6],[4,3,6,1],[4,3,2,5]]
	
	static func getSideMaps(sides):
		if sides == 2:
			return twoSide
		if sides == 6:
			return sixSide
			
func _ready() -> void:
	print("setup")
	var firstItem = item.new()
	firstItem.sides = 2
	firstItem.correctSide = 2
	firstItem.currentSide = 1
	firstItem.sideMap = sideMaps.getSideMaps(firstItem.sides)
	firstItem.textures = obj0Textures
	objList.append(firstItem)
	var secondItem = item.new()
	secondItem.sides = 6
	secondItem.correctSide = 1
	secondItem.currentSide = 1
	secondItem.sideMap = sideMaps.getSideMaps(secondItem.sides)
	secondItem.textures = obj1Textures
	objList.append(secondItem)
	var thirdItem = item.new()
	thirdItem.sides = 6
	thirdItem.correctSide = 6
	thirdItem.currentSide = 1
	thirdItem.sideMap = sideMaps.getSideMaps(thirdItem.sides)
	thirdItem.textures = obj2Textures
	objList.append(thirdItem)
	var fourthItem = item.new()
	fourthItem.sides = 2
	fourthItem.correctSide = 2
	fourthItem.currentSide = 1
	fourthItem.sideMap = sideMaps.getSideMaps(fourthItem.sides)
	fourthItem.textures = obj3Textures
	objList.append(fourthItem)
	var fifthItem =item.new()
	fifthItem.sides = 6
	fifthItem.correctSide = 4
	fifthItem.currentSide = 1
	fifthItem.sideMap = sideMaps.getSideMaps(fifthItem.sides)
	fifthItem.textures = obj4Textures
	objList.append(fifthItem)
	var sixthItem = item.new()
	sixthItem.sides = 6
	sixthItem.correctSide = 6
	sixthItem.currentSide = 1
	sixthItem.sideMap = sideMaps.getSideMaps(sixthItem.sides)
	sixthItem.textures = obj2Textures
	objList.append(sixthItem)

func _on_rotate_up_pressed() -> void:
	emit_signal("sendAnxietyChange",5)
	#main.updateAnxiety(5)
	objList[curObj].currentSide = objList[curObj].sideMap[objList[curObj].currentSide -1][0]
	print (objList[curObj].currentSide)
	itemTexture.texture = 	objList[curObj].textures[objList[curObj].currentSide-1]
func _on_rotate_down_pressed() -> void:
	emit_signal("sendAnxietyChange",5)
	#main.updateAnxiety(5)
	objList[curObj].currentSide = objList[curObj].sideMap[objList[curObj].currentSide -1][1]
	print (objList[curObj].currentSide)
	itemTexture.texture = 	objList[curObj].textures[objList[curObj].currentSide-1]

func _on_rotate_left_pressed() -> void:
	emit_signal("sendAnxietyChange",5)
	#main.updateAnxiety(5)
	objList[curObj].currentSide = objList[curObj].sideMap[objList[curObj].currentSide -1][2]
	print (objList[curObj].currentSide)
	itemTexture.texture = 	objList[curObj].textures[objList[curObj].currentSide-1]

func _on_rotate_right_pressed() -> void:
	emit_signal("sendAnxietyChange",5)
	#main.updateAnxiety(5)
	objList[curObj].currentSide = objList[curObj].sideMap[objList[curObj].currentSide -1][3]
	print (objList[curObj].currentSide)
	itemTexture.texture = 	objList[curObj].textures[objList[curObj].currentSide-1]


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("check_out_up"):
		_on_rotate_up_pressed()
	if Input.is_action_just_pressed("check_out_down"):
		_on_rotate_down_pressed()
	if Input.is_action_just_pressed("check_out_left"):
		_on_rotate_right_pressed()
	if Input.is_action_just_pressed("check_out_right"):
		_on_rotate_left_pressed()
	if Input.is_action_just_pressed("check_out_scan"):
		_on_button_pressed()

func _on_button_pressed() -> void:
	if (objList[curObj].currentSide == objList[curObj].correctSide):
		print("correct")
		if (curObj <len(objList)-1):
			curObj = curObj +1
			itemTexture.texture = objList[curObj].textures[0]
		else:
			print("end of minigame")
			emit_signal("endOfGame", defs.MINIGAME.SELF_CHECKOUT_GAME)
	else:
		emit_signal("sendAnxietyChange",10)
		#main.updateAnxiety(10)
