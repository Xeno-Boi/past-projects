class_name AnxietyCounter

'''
keeps track of anxiety related data
access AnxietyCounter like a class (AnxietyCounter.class_function())
'''

static var current_anxiety : int = 0	## current anxiety level
static var passive_anxiety_increase : int = 0	## current amount for passive anxiety to increase 
static var smooth_anxiety : int = 0		## smoothly increases anxiety
