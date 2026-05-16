extends Resource
class_name  npc_scripts

## scripts npcs will speak when player is near [br]
## key is the anxiety threshold of the scripts [br]
## @example if key is 10, scripts are for anxiety levels under 10
var scripts : Dictionary = {
	200 : [
		"Nice day, isn’t it?",
		"I like your shirt!",
		"I wonder where the milk section is…",
		"Did I forget my wallet?",
		"Lettuce check, Tomatoes check, Pickles … still need to get some pickles",
		"*talks on the phone*",
		"Let me know if you need help!",
		"I can never decide between these two brands",
		"Theres a sale going on?",
		"These are way too expensive",
		"They really need more baskets up front",
		"Excuse me—sorry! Didn’t mean to bump you",
		"These prices keep going up, huh…",
		"Ooh, they’ve got samples today!"
	],
	
	400 : [
		"That shirt... hmm. Well, everyone has their style.",
		"You sure you’re in the right section?",
		"Looks like someone’s had a rough morning",
		"You’ve been standing there a while…",
		"You kind of stand out",
		"You’ve been standing there a while…",
		"Seriously? Who shops like that?",
		"Watch where you’re going",
		"That’s not how lines work, buddy",
		"Don't just stand in the middle",
		"Excuse me? Can you move?",
		"Why are they buying those?",
		
	],
	
	700 : [
		"What a weirdo",
		"Why is that person even here?",
		"Ugh, they’re still here?",
		"They’re totally judging you",
		"Everyone’s watching you, you know",
		"Trying so hard to be normal, huh?",
		"Hope they don’t talk to me",
		"Stop staring, freak",
		"They're so awkward, it's painful",
		"Act normal, for god’s sake",
		"I feel gross just standing near them",
		"Do they not know how anything works?",
		"Get out of my way",
		"They are probably stealing stuff",
		"Someone should keep an eye on them",
		"I guess they let anyone in here now"
	],
	
	1000 : [
		"You’re disgusting",
		"Just leave already, freak",
		"Nobody wants you here",
		"Pathetic. Absolutely pathetic",
		"Why don’t you just disappear?",
		"You ruin the whole place just by being in it",
		"You make everyone uncomfortable",
		"Don’t you get it? You're not welcome",
		"They should kick you out for being like this",
		"What a pathetic loser",
		"They’re a total freak. Look at them",
		"Makes me sick just seeing them pretend to shop",
		"Someone call security already",
		"Let’s just move away from that thing",
		"Seriously, take a shower",
		"Waste of oxygen"
	]
}


# helpers
## get a random script line based on given anxiety level
func getScript(anxiety : int) -> String:
	var output : String = ""
	
	for anxiety_threshold in scripts.keys():
		if anxiety <= anxiety_threshold:
			var anxiety_scripts = scripts[anxiety_threshold]
			output = anxiety_scripts[randi() % anxiety_scripts.size()]
			break
	
	return output


## get a weight from 0 to 1 based on the anxiety level, related to script levels
func getWeight(anxiety : int) -> float:
	for anxiety_threshold in scripts.keys():
		if anxiety <= anxiety_threshold:
			return anxiety_threshold / 1000.0
	return 1.0
