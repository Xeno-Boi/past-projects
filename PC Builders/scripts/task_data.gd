class_name TaskData
extends Resource

@export var name: String = "Task Name"
@export var description: String = "Task Description"
@export var req_text: String = "Task Requirement Text"
@export var reward: int = 0

@export var requirements: Dictionary = {
#	basic requirement
	"mb_count": 1,
	"cpu_count": 1,
	"gpu_count": 1,
	"total_ram": 1,
	"total_hdd": null,
	"psu_power": 1,
#	advance requirement
	"cpu_clockrate": null,
	"ram_clockrate": null,
	"hdd_speed": null,
	"mb_rating": null,
	"cpu_rating": null,
	"gpu_rating": null,
	"ram_rating": null,
	"total_rating": null,
	"raytracing": false
}
