# define file

# scene paths
const MOTHERBOARD_PATH = "res://scenes/components/motherboard.tscn"
const CPU_PATH = "res://scenes/components/cpu.tscn"
const GPU_PATH = "res://scenes/components/gpu.tscn"
const RAM_PATH = "res://scenes/components/ram.tscn"
const PSU_PATH = "res://scenes/components/psu.tscn"
const HARDDISK_PATH = "res://scenes/components/harddisk.tscn"

# preload scenes
static var PRELOAD_SCENE = {
	TYPE.MOTHERBOARD: preload(MOTHERBOARD_PATH),
	TYPE.CPU: preload(CPU_PATH),
	TYPE.GPU: preload(GPU_PATH),
	TYPE.RAM: preload(RAM_PATH),
	TYPE.PSU: preload(PSU_PATH),
	TYPE.HARDDISK: preload(HARDDISK_PATH)
}

# scenes
enum SCENE {
	MARKET,
	TASK,
	WORKBENCH,
	MYPC
}

# component types
enum TYPE {
	DEFAULT,
	COMPUTER,
	CASE,
	MOTHERBOARD,
	CPU,
	GPU,
	RAM,
	PSU,
	HARDDISK
}

# computer structure	
static var COMPUTER_STRUCT = {
	TYPE.MOTHERBOARD: null,
	TYPE.CPU: null,
	TYPE.GPU: [],
	TYPE.RAM: [],
	TYPE.PSU: null,
	TYPE.HARDDISK: []
}


# helpers

# takes a computer struct and checks if the build is valid
static func isValidComputer(computer: Dictionary) -> bool:
	# motherboard
	if not computer[TYPE.MOTHERBOARD]:
		return false
	# cpu
	if not computer[TYPE.CPU]:
		return false
	# ram
	var ram = null
	for installed_ram in computer[TYPE.RAM]:
		if installed_ram:	# slot is not null
			ram = installed_ram
	if not ram:	# no ram installed
		return false
	# psu
	if not computer[TYPE.PSU]:
		return false
	# harddisk
	var harddisk = null
	for installed_harddisk in computer[TYPE.HARDDISK]:
		if installed_harddisk:	# slot is not null
			harddisk = installed_harddisk
	if not harddisk:	# no harddisk installed
		return false
		
	return hasEnoughPower(computer)


# checks if a computer has enough power
static func hasEnoughPower(computer: Dictionary) -> bool:
	var power_provided = 0
	
	if computer[TYPE.PSU]:
		power_provided = computer[TYPE.PSU].power
	
	return getPowerNeeded(computer) <= power_provided


# gets total power needed for build
static func getPowerNeeded(computer: Dictionary) -> int:
	var power_needed = 0
	# motherboard
	if computer[TYPE.MOTHERBOARD]:
		power_needed = power_needed + computer[TYPE.MOTHERBOARD].power_consumption
	# cpu
	if computer[TYPE.CPU]:
		power_needed = power_needed + computer[TYPE.CPU].power_consumption
	# gpu
	for gpu in computer[TYPE.GPU]:
		if gpu:
			power_needed = power_needed + gpu.power_consumption
	# ram
	for ram in computer[TYPE.RAM]:
		if ram:
			power_needed = power_needed + ram.power_consumption
	# harddisk
	for harddisk in computer[TYPE.HARDDISK]:
		if harddisk:
			power_needed = power_needed + harddisk.power_consumption
	
	return power_needed


# gets total cost of build
static func getCost(computer: Dictionary) -> int:
	var cost = 0
	# motherboard
	if computer[TYPE.MOTHERBOARD]:
		cost = cost + computer[TYPE.MOTHERBOARD].price
	# cpu
	if computer[TYPE.CPU]:
		cost = cost + computer[TYPE.CPU].price
	# gpu
	for gpu in computer[TYPE.GPU]:
		if gpu:
			cost = cost + gpu.price
	# ram
	for ram in computer[TYPE.RAM]:
		if ram:
			cost = cost + ram.price
	# psu
	if computer[TYPE.PSU]:
		cost = cost + computer[TYPE.PSU].price
	# harddisk
	for harddisk in computer[TYPE.HARDDISK]:
		if harddisk:
			cost = cost + harddisk.price
	
	return cost


# component models

class MotherboardModel:
	class Motherboard:
		static var type = TYPE.MOTHERBOARD
		var name: String
		var price: int
		var rating: int	# out of 10
		var power_consumption: int	# Watts
		
		var display_texture
		var install_texture
		
		func _init(_name: String, _price: int, _rating: int, _power_consumption: int, display_texture_path: String, install_texture_path: String):
			name = _name
			price = _price
			rating = _rating
			power_consumption = _power_consumption
			
			display_texture = load(display_texture_path)
			install_texture = load(install_texture_path)
		
		func printSpecs():
			print("Motherboard | name: ", name, " price: ", price, " rating: ", rating, "/10 power consumption: ", power_consumption)
	
	# properties
	static var description = "– 🛠️ Motherboard –
	Think of this as the foundation of your PC. 
	It’s where all your components connect and 
	communicate with each other.
	"
	
	# define items
	static var low = Motherboard.new("low", 100, 2, 65, "res://assets/newSprites/motherboard.png", "res://assets/newSprites/motherboard.png")
	static var mid = Motherboard.new("mid", 170, 5, 125, "res://assets/newSprites/motherboard.png", "res://assets/newSprites/motherboard.png")
	static var high = Motherboard.new("high", 350, 10, 150, "res://assets/newSprites/motherboard.png", "res://assets/newSprites/motherboard.png")
		
	static var models = [low, mid, high]


class CpuModel:
	class Cpu:
		static var type = TYPE.CPU
		var name: String
		var price: int
		var rating: int	# out of 10
		var total_cores: int #
		var clockrate: float	# Ghz
		var power_consumption: int	# Watts
		var power_consumption_turbo: int	# Watts
		
		var display_texture
		var install_texture
		
		func _init(_name: String, _price: int, _rating: int,_total_cores: int, _clockrate: float, _power_consumption: int,_power_consumption_turbo: int, display_texture_path: String, install_texture_path: String):
			name = _name
			price = _price
			rating = _rating
			total_cores = _total_cores
			clockrate = _clockrate
			power_consumption = _power_consumption
			power_consumption_turbo = _power_consumption_turbo
			
			display_texture = load(display_texture_path)
			install_texture = load(install_texture_path)
		
		func printSpecs():
			print("Cpu | name: ", name, " price: ", price, " clockrate: ", clockrate, "Ghz rating: ", rating, "/10 power consumption: ", power_consumption)
	
	# properties
	static var description = "– 🧠 CPU (Processor) –
	This is the brain of your computer, 
	responsible for executing 
	instructions and making 
	calculations. The faster 
	and more powerful your CPU, 
	the better your computer 
	can think.
	"
	
	# define items
	static var i3 = Cpu.new("Intel Core i3-13100", 110, 3, 4, 4.5, 60, 110, "res://assets/newSprites/i3.png", "res://assets/newSprites/i3.png")
	static var i5 = Cpu.new("Intel Core i5-13600K", 280, 6, 14, 5.1, 125, 181, "res://assets/newSprites/i5.png", "res://assets/newSprites/i5.png")
	static var i7 = Cpu.new("Intel Core i7-13700K", 400, 8, 16, 5.4, 125, 253, "res://assets/newSprites/i7.png", "res://assets/newSprites/i7.png")
	static var i9 = Cpu.new("Intel Core i9-13900K", 600, 10, 24, 5.8, 125, 253, "res://assets/newSprites/i9.png", "res://assets/newSprites/i9.png")
		
	static var models = [i3, i5, i7, i9]


class GpuModel:
	class Gpu:
		static var type = TYPE.GPU
		var name: String
		var price: int
		var raytracing: bool
		var vram: int #in GB
		var memory_type: String
		var rating: int	# out of 10
		var power_consumption: int	# Watts
		
		var display_texture
		var install_texture
		
		func _init(_name: String, _price: int, _raytracing: bool, _vram: int,_memory_type: String, _rating: int, _power_consumption: int, display_texture_path: String, install_texture_path: String):
			name = _name
			price = _price
			raytracing = _raytracing
			vram = _vram
			memory_type = _memory_type
			rating = _rating
			power_consumption = _power_consumption
			
			display_texture = load(display_texture_path)
			install_texture = load(install_texture_path)
		
		func printSpecs():
			print("Gpu | name: ", name, " price: ", price, " raytracing: ", raytracing, " rating: ", rating, "/10 power consumption: ", power_consumption)
	
	# properties
	static var description = "– 🎨 GPU (Graphics Card) –
	The CPU does the thinking, but the GPU takes
	that information and turns it into visuals on your screen.
	If you want smooth graphics and high performance,
	a strong GPU is a must.
	"
	
	# define items
	
	static var gtx1060 = Gpu.new("GTX 1060", 70, false, 6, 'GDDR5', 2, 120, "res://assets/newSprites/GPU_RTX1060.png", "res://assets/newSprites/GPU_RTX1060_top.png")
	static var rtx2070 = Gpu.new("RTX 2070", 190, true, 8, 'GDDR6', 3, 175, "res://assets/newSprites/GPU_RTX2070.png", "res://assets/newSprites/GPU_RTX2070_top.png")
	static var rtx3070ti = Gpu.new("RTX 3070 Ti", 400, true, 8, 'GDDR6X', 7, 290, "res://assets/newSprites/GPU_RTX3070ti.png", "res://assets/newSprites/GPU_RTX3070ti_top.png")
	static var rtx4090 = Gpu.new("RTX 4090", 1650, true, 24, 'GDDR6X', 10, 450, "res://assets/newSprites/GPU_RTX4090.png", "res://assets/newSprites/GPU_RTX4090_top.png")
		
	static var models = [gtx1060, rtx2070, rtx3070ti, rtx4090]


class RamModel:
	class Ram:
		static var type = TYPE.RAM
		var name: String
		var price: int
		var size: int	# GB
		var clockrate: int	# Mhz
		var rating: int	# out of 10
		var power_consumption: int	# Watts
		
		var display_texture
		var install_texture
		
		func _init(_name: String, _price: int, _size: int, _clockrate, _rating: int, _power_consumption: int, display_texture_path: String, install_texture_path: String):
			name = _name
			price = _price
			size = _size
			clockrate = _clockrate
			rating = _rating
			power_consumption = _power_consumption
			
			display_texture = load(display_texture_path)
			install_texture = load(install_texture_path)
		
		func printSpecs():
			print("Ram | name: ", name, " price: ", price, " size: ", size, " clockrate: ", clockrate, "MHz", " rating: ", rating, "/10 power consumption: ", power_consumption)
	
	# properties
	static var description = "– 💾 RAM (Memory) –
	This is your computer’s workspace,
	where it temporarily stores 
	and processes information. 
	More RAM means your PC can
	handle more tasks at once.
	"
	
	# define items
	
	static var r8 = Ram.new("8GB 3200MHz", 20, 8, 3200, 1, 4, "res://assets/newSprites/RAM8GB.png", "res://assets/newSprites/RAM8GB_top.png")
	static var r16 = Ram.new("16GB 3600MHz", 60, 16, 3600, 6, 5, "res://assets/newSprites/RAM16GB.png", "res://assets/newSprites/RAM16GB_top.png")
	static var r32 = Ram.new("32GB 3600MHz", 120, 32, 3600, 10, 6, "res://assets/newSprites/RAM32GB.png", "res://assets/newSprites/RAM32GB_top.png")
		
	static var models = [r8, r16, r32]


class PsuModel:
	class Psu:
		static var type = TYPE.PSU
		var name: String
		var price: int
		var power: int
		
		var display_texture
		var install_texture
		
		func _init(_name: String, _price: int, _power: int, display_texture_path: String, install_texture_path: String):
			name = _name
			price = _price
			power = _power
			
			display_texture = load(display_texture_path)
			install_texture = load(install_texture_path)
		
		func printSpecs():
			print("Psu | name: ", name, " price: ", price, "power: ", power, "W")
	
	# properties
	static var description = "– ⚡ Power Supply (PSU) –
	Every component in your PC needs electricity to run. 
	A powerful enough PSU ensures everything stays 
	powered without issues.
	"
	
	# define items
	
	static var B550 = Psu.new("500W Bronze", 80, 500, "res://assets/newSprites/powerSupply500W.png", "res://assets/newSprites/powerSupply500W.png")
	static var G750 = Psu.new("750W Gold", 110, 750, "res://assets/newSprites/powerSupply800W.png", "res://assets/newSprites/powerSupply800W.png")
	static var P1200 = Psu.new("1200W Platinum", 250, 1200, "res://assets/newSprites/powerSupply1200W.png", "res://assets/newSprites/powerSupply1200W.png")
		
	static var models = [B550, G750, P1200]


class HarddiskModel:
	class Harddisk:
		static var type = TYPE.HARDDISK
		var name: String
		var price: int
		var size: float	# in tb
		var speed: int	# mb/sec
		var power_consumption: int	# Watts
		
		var display_texture
		var install_texture
		
		func _init(_name: String, _price: int, _size: float, _speed: int, _power_consumption: int, display_texture_path: String, install_texture_path: String):
			name = _name
			price = _price
			size = _size
			speed = _speed
			power_consumption = _power_consumption
			
			display_texture = load(display_texture_path)
			install_texture = load(install_texture_path)
			
		func printSpecs():
			print("Harddisk | name: ", name, " price: ", price, " size: ", size, "TB speed: ", speed, "MB/s power consumption: ", power_consumption)
	
	# properties
	static var description = "– 📦 Storage (HDD/SSD) –
	Your files, applications, and 
	operating system all need a home.
	A larger and faster storage drive 
	ensures you have enough space 
	and quick access to your data.
	"
	
	# define items
	
	static var H1TB = Harddisk.new("1TB HDD", 60, 1.0, 210, 5, "res://assets/newSprites/HDD1TB.png", "res://assets/newSprites/HDD1TB.png")
	static var H2TB = Harddisk.new("2TB HDD", 90, 2.0, 210, 5, "res://assets/newSprites/HDD2TB.png", "res://assets/newSprites/HDD2TB.png")
	static var H4TB = Harddisk.new("4TB HDD", 120, 4.0, 210, 5, "res://assets/newSprites/HDD4TB.png", "res://assets/newSprites/HDD4TB.png")
	static var S1TB = Harddisk.new("1TB SSD", 150, 1.0, 560, 4, "res://assets/newSprites/SSD4TB1.png", "res://assets/newSprites/SSD4TB1.png")
		
	static var models = [H1TB, H2TB, H4TB,S1TB]
