extends Control

const defs = preload("res://scripts/defs.gd")

@onready var give_up_button = $CurrentTask/Box/GiveUpButton
@onready var task_list = $TaskBoard/VBoxContainer/Background/TaskScroller/TaskList
@onready var task_info = $CurrentTask/Box/TaskInfo/InfoText
@onready var task_name = $CurrentTask/Box/TaskInfo/NameText
@onready var task_rewards = $CurrentTask/Box/TaskInfo/Rewards/Value
@onready var task_description = $CurrentTask/Box/Description/DescriptionContent
@onready var task_board = $TaskBoard
@onready var message_box  = $MessageBox
@onready var message_box_content = $MessageBox/MessageContent

# signal
signal taskCompleteResult(result: bool)

func _ready():
	load_tasks()
	give_up_button.pressed.connect(_on_give_up_task_pressed)
	
func _process(_delta: float) -> void:
	if inventory.current_task == null:
		give_up_button.hide()
	else:
		give_up_button.show()

func create_task():
	var task0 = TaskData.new()
	task0.name = "Welcome to PC building!"
	task0.description = "\n= Tutorial Task = 
		<Please don't reject this one, you can reject other tasks as you wish later!>
		Before your machine can come to life, it needs the right components to function properly.
		Hover your mouse over each component name in Work Shop to see detail information about its function.
		Here’s what you need to get started:
		– ⚡ Power Supply (PSU) –
		– 🛠️ Motherboard –
		– 🧠 CPU (Processor) –
		– 🎨 GPU (Graphics Card) –
		– 💾 RAM (Memory) –
		– 📦 Storage (HDD) –
		With these parts in place, your PC will be ready to boot up and start working!
		Budget: $2000
		Requirements: Build a functional computer"
	task0.reward = 2000
	task0.req_text = "Any Motherboard x1
Any CPU x1
Any GPU x1
Any PSU x1
Any RAM xn
Any Harddisk"
	task0.requirements = {
		"mb_count": 1,
		"cpu_count": 1,
		"gpu_count": 1,
		"total_ram": 1,
		"total_hdd": 1,
		"psu_power": 1
	}
	inventory.add_task(task0)
	
	var task1 = TaskData.new()
	task1.name = "Sarah - University Freshman"
	task1.description = "\nI decided to get a new computer for my freshman year at Carleton University!
		I need a computer so I can watch my favourite cooking shows on Youtube and watch stuff on Netflix.
		So nothing fancy, anything goes.
		Willing to pay/Budget: $600
		Requirements: No requirements, just a functional computer"
	task1.reward = 600
	task1.req_text = "Any Motherboard x1
Any CPU x1
Any GPU x1
Any PSU x1
Any RAM xn
Any Harddisk xn"
	task1.requirements = {
		"mb_count": 1,
		"cpu_count": 1,
		"gpu_count": 1,
		"total_ram": 1,
		"total_hdd": 1,
		"psu_power": 1
	}
	inventory.add_task(task1)
	
	var task2 = TaskData.new()
	task2.name = "Timmy - High Schooler"
	task2.description = "\nI am jealous of all my classmates that are playing Fortnite without me!
		Fortunately, I was able to convince my parents that I can finally get my own gaming pc, but I have a small budget.
		I don’t need a crazy gaming rig, just something that can run Fortnite smoothly so I can play with my friends.
		Willing to pay/Budget: $900
		Requirements:
		A GPU that suits this situation
		>200GB Storage
		>8GB Ram"
	task2.reward = 900
	task2.req_text = "Any Motherboard x1
Any CPU x1
Low/Medium rating GPU x1
Any PSU x1
8gb RAM
200gb Harddisk"
	task2.requirements = {
		"mb_count": 1,
		"cpu_count": 1,
		"gpu_count": 1,
		"total_ram": 8,
		"total_hdd": 1,
		"psu_power": 1,
		"gpu_rating": 3
	}
	inventory.add_task(task2)
	
	var task3 = TaskData.new()
	task3.name = "Oliver - Indie Game Developer"
	task3.description = "\nI’ve been working on my dream game for years,
		but my 10-year old laptop keeps freezing everytime I try to compile my code.
		I need a powerful CPU and lots of RAM so I can run Unity, Blender and multiple Chrome tabs
		without everything slowing to a crawl.
		Oh, and my renders take forever! I hope you can help me out.
		Willing to pay/Budget: $2200
		Requirements:
		A CPU that suits this situation
		>32GB Ram"
	task3.reward = 2200
	task3.req_text = "Any Motherboard x1
High rating CPU x1
High rating GPU with raytracing x1
Suitable PSU x1
32gb RAM
Suitable Harddisk"
	task3.requirements = {
		"mb_count": 1,
		"cpu_count": 1,
		"gpu_count": 1,
		"raytracing": true,
		"total_ram": 32,
		"total_hdd": 2,
		"psu_power": 1200,
		"cpu_rating": 8,
		"gpu_rating": 7
	}
	inventory.add_task(task3)
	
	var task4 = TaskData.new()
	task4.name = "Jake - Social Media Influencer"
	task4.description = "\nHey! I need a high-end gaming and streaming PC
		so my followers can see me play Monster Hunter Wilds in ultra settings and 60 FPS. 
		Also, I want super fast rendering for my 4K video edits. 
		Oh, and RGB lighting is a must! 
		But... I can only spend $500. 
		Please make it happen!
		Willing to pay/Budget: $500
		Requirements:
		Top-tier PC in every direction"
	task4.reward = 5000 # bonus for completing a task that suppose to be rejected (streamer challenge)
	task4.req_text = "High-End Motherboard
Top-Tier CPU
Top-Tier GPU with raytracing
64GB RAM or more
At least 4TB Storage
1200W PSU"
	task4.requirements = {
		"mb_count": 1,
		"cpu_count": 1,
		"gpu_count": 1,
		"raytracing": true,
		"total_ram": 64,
		"total_hdd": 8,
		"total_power": 1200,
		"cpu_rating": 10,
		"gpu_rating": 10
		#"total_rating": 1300
	}
	inventory.add_task(task4)
	
	var task5 = TaskData.new()
	task5.name = "Ethan - Crypto Miner"
	task5.description = "\nHey, I need the absolute best GPUs you can find. 
		I'm setting up a crypto mining farm, and I need at least 2 high-performance GPUs to maximize my profits. 
		Power efficiency is also important, but performance is my top priority.
		Oh, and for the other parts, I don't care much.
		Willing to pay/Budget: $3500
		Requirements:
		High-End GPUs
		PSU with enough power"
	task5.reward = 3500
	task5.req_text = "Any Motherboard
Any CPU
High rating GPU x2
Suitable PSU
Any RAM
Any Harddisk"
	task5.requirements = {
		"mb_count": 1,
		"cpu_count": 1,
		"gpu_count": 2,
		"total_ram": 8,
		"total_hdd": 1,
		"psu_power": 1200,
		"gpu_rating": 10
	}
	inventory.add_task(task5)
	
	var task6 = TaskData.new()
	task6.name = "Liam - Professional Video Editor & Graphic Designer"
	task6.description = "\nHey there! I work with Photoshop, Premiere Pro, and After Effects daily,
		and my current PC is struggling with 4K video editing and large PSD files. 
		I need a super smooth editing experience, fast preview rendering, and zero lag when working on complex video timelines. 
		Also, storage is a big deal—I need tons of fast storage for all my raw footage and projects.
		Willing to pay/Budget: $4000
		Requirements:
		A PC suits this person's need"
	task6.reward = 4000
	task6.req_text = "High-End Motherboard
High-Speed Multi-Core CPU
High rating GPU x2
High-Efficiency PSU
64GB RAM
Large storage Harddisk"
	task6.requirements = {
		"mb_count": 1,
		"cpu_count": 1,
		"gpu_count": 2,
		"total_ram": 64,
		"total_hdd": 4, #should be ssd
		"hdd_speed": 150,
		"cpu_clockrate": 5.4,
		"ram_clockrate": 3600,
		"gpu_rating": 8,
		"cpu_rating": 10,
		"psu_power": 1200
	}
	inventory.add_task(task6)

func load_tasks():
	create_task()
	update_ui()

func update_ui():
	for task in inventory.active_tasks:
		var task_button = create_task_button(task)
		task_list.add_child(task_button)

func create_task_button(task: TaskData) -> MenuButton:
	var menu_button = MenuButton.new()
	menu_button.flat = false
	menu_button.text = task.name + task.description

	var popup = menu_button.get_popup()
	popup.clear()
	popup.add_item("Accept", 0)
	popup.add_item("Reject", 1)
	
	popup.id_pressed.connect(func(id): on_task_action(id, task))
	inventory.task_buttons[task] = menu_button
	return menu_button

func on_task_action(id: int, task: TaskData):
	if id == 0:
		if inventory.current_task == null:
			inventory.accept_task(task)
			task_name.text = task.name
			task_rewards.text = "$ " + str(task.reward)
			task_info.text = task.req_text
			task_description.text = task.description
			
		else:
			updateMessageBox("You have an incomplete task!")
			flashMessageBox()
	elif id == 1:
		inventory.reject_task(task)
		updateMessageBox("Task Rejected:\n" + task.name)
	task_board.turnOff()
		
func _on_turn_in_PC(computer: Dictionary):
	var task_completed = is_task_completed(computer)
	if task_completed:
		give_reward(defs.getCost(computer))
	emit_signal("taskCompleteResult", task_completed)

func _on_give_up_task_pressed():
	if inventory.current_task != null:
		updateMessageBox("Task Abandoned:\n" + inventory.current_task.name)
		inventory.current_task = null
		resetTaskPanel()

func resetTaskPanel():
	task_name.text = "No active task."
	task_rewards.text = "$ 0"
	task_info.text = "No active task."
	task_description.text = "Click on task in Task Board to accept a new task!"

func updateMessageBox(text: String):
	message_box_content.text = text
	await get_tree().create_timer(0.3).timeout
	message_box.get_theme_stylebox("panel").bg_color = Color("caab7a", 1.0)
	await get_tree().create_timer(0.5).timeout
	message_box.get_theme_stylebox("panel").bg_color = Color("ab8d5c", 1.0)

func flashMessageBox():
	var timeout_time = 0.3
	#var flash_times = 4
	for i in range(4):
		message_box.get_theme_stylebox("panel").bg_color = Color("caab7a", 1.0)
		await get_tree().create_timer(timeout_time).timeout
		message_box.get_theme_stylebox("panel").bg_color = Color("ab8d5c", 1.0)
		await get_tree().create_timer(timeout_time).timeout

func give_reward(cost: int):
	if not inventory.current_task:
		return
		
	var task = inventory.current_task
	var payout = task.reward - cost
	inventory.current_money += payout
	updateMessageBox("Task Completed:\n" + inventory.current_task.name +
					"\nPayout: Budget $ " + str(task.reward) + " - Cost $ " + str(cost) + "\n = $ " + str(payout))
	inventory.current_task = null
	resetTaskPanel()
	
func is_task_completed(computer_struct: Dictionary) -> bool:
	if not inventory.current_task:
		return false

	var task = inventory.current_task
	var requirements = task.requirements
	var meets_criteria = true
	var missing_requirements = []

	var mb_count = 0
	var cpu_count = 0
	var gpu_count = 0
	var total_ram = 0
	var total_hdd = 0
	var psu_power = 0

	var cpu_clockrate = 0
	var ram_clockrate = 0
	var hdd_speed = 0
	var mb_rating = 0
	var cpu_rating = 0
	var gpu_rating = 0
	var ram_rating = 0
	#var total_rating = 0
	var raytracing = false

	for part_type in computer_struct.keys():
		var part_data = computer_struct[part_type]

		if part_data == null:
			continue

		match part_type:
			defs.TYPE.MOTHERBOARD:
				mb_count += 1
				mb_rating = max(mb_rating, part_data.rating)
			defs.TYPE.CPU:
				cpu_count += 1
				cpu_rating = max(cpu_rating, part_data.rating)
				cpu_clockrate = max(cpu_clockrate, part_data.clockrate)
			defs.TYPE.GPU:
				if part_data != []:
					for gpu in part_data:
						if gpu:
							gpu_count += 1
							gpu_rating = max(gpu_rating, gpu.rating)
							if gpu.raytracing:
								raytracing = true
			defs.TYPE.RAM:
				if part_data != []:
					for ram in part_data:
						if ram:
							total_ram += ram.size
							ram_clockrate = max(ram_clockrate, ram.clockrate)
							ram_rating = max(ram_rating, ram.rating)
			defs.TYPE.PSU:
				psu_power += part_data.power
			defs.TYPE.HARDDISK:
				if part_data != []:
					for hdd in part_data:
						if hdd:
							total_hdd += hdd.size
							hdd_speed = max(hdd_speed, hdd.speed)

	var cost = defs.getCost(computer_struct) - inventory.current_task.reward
	if cost > inventory.current_money:
		meets_criteria = false
		missing_requirements.append("Not enough money")
	
	if "mb_count" in requirements and mb_count < requirements["mb_count"]:
		meets_criteria = false
		missing_requirements.append("At least %d motherboard(s) needed, but has %d" % [requirements["mb_count"], mb_count])

	if "cpu_count" in requirements and cpu_count < requirements["cpu_count"]:
		meets_criteria = false
		missing_requirements.append("At least %d CPU(s) needed, but has %d" % [requirements["cpu_count"], cpu_count])

	if "gpu_count" in requirements and gpu_count < requirements["gpu_count"]:
		meets_criteria = false
		missing_requirements.append("At least %d GPU(s) needed, but has %d" % [requirements["gpu_count"], gpu_count])

	if "total_ram" in requirements and total_ram < requirements["total_ram"]:
		meets_criteria = false
		missing_requirements.append("At least %dGB RAM needed, but has %dGB" % [requirements["total_ram"], total_ram])

	if "total_hdd" in requirements and total_hdd < requirements["total_hdd"]:
		meets_criteria = false
		missing_requirements.append("At least %dTB storage needed, but has %dTB" % [requirements["total_hdd"], total_hdd])

	if "psu_power" in requirements and psu_power < requirements["psu_power"]:
		meets_criteria = false
		missing_requirements.append("PSU power must be at least %dW, but is %dW" % [requirements["psu_power"], psu_power])

	if "cpu_clockrate" in requirements and cpu_clockrate < requirements["cpu_clockrate"]:
		meets_criteria = false
		missing_requirements.append("CPU clockrate must be at least %.1f GHz, but best installed is %.1f GHz" % [requirements["cpu_clockrate"], cpu_clockrate])

	if "ram_clockrate" in requirements and ram_clockrate < requirements["ram_clockrate"]:
		meets_criteria = false
		missing_requirements.append("RAM clockrate must be at least %d MHz, but best installed is %d MHz" % [requirements["ram_clockrate"], ram_clockrate])

	if "hdd_speed" in requirements and hdd_speed < requirements["hdd_speed"]:
		meets_criteria = false
		missing_requirements.append("Storage speed must be at least %dMB/s, but best installed is %dMB/s" % [requirements["hdd_speed"], hdd_speed])

	if "mb_rating" in requirements and mb_rating < requirements["mb_rating"]:
		meets_criteria = false
		missing_requirements.append("Motherboard rating must be at least %d, but best installed is %d" % [requirements["mb_rating"], mb_rating])

	if "cpu_rating" in requirements and cpu_rating < requirements["cpu_rating"]:
		meets_criteria = false
		missing_requirements.append("CPU rating must be at least %d, but best installed is %d" % [requirements["cpu_rating"], cpu_rating])

	if "gpu_rating" in requirements and gpu_rating < requirements["gpu_rating"]:
		meets_criteria = false
		missing_requirements.append("GPU rating must be at least %d, but best installed is %d" % [requirements["gpu_rating"], gpu_rating])

	if "ram_rating" in requirements and ram_rating < requirements["ram_rating"]:
		meets_criteria = false
		missing_requirements.append("RAM rating must be at least %d, but best installed is %d" % [requirements["ram_rating"], ram_rating])

	if "raytracing" in requirements and raytracing != requirements["raytracing"]:
		meets_criteria = false
		missing_requirements.append("Raytracing must be %s, but best installed is %s" % [requirements["raytracing"], raytracing])
	
	if meets_criteria && defs.isValidComputer(computer_struct):
		return true
	else:
		var issue_text = "Task not completed. Issues:"
		for issue in missing_requirements:
			issue_text = issue_text + "\n" + issue
		updateMessageBox(issue_text)
		flashMessageBox()
		return false
