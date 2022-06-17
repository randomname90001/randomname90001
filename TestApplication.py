import random

elnoob = '''I'm going to be honest here,
"this python stuff is a bit weird"'''

#print(elnoob)

coolstuff = "you can do wack stuff such as %s and %s because why not"

#print(coolstuff % ("this", "that"))

target_weight = 0

current_weight = 1

conditional = False

conditionals = ['On hit: ', 'On kill: ']

conditionals_weights = [1.35, 1.75]

conditional_stat_list = ['Inflict {} ', 'Gain {} Health ']

conditional_stat_weights = [2, 2]

positive_stat_list = ['+{}% damage bonus ', '+{}% faster firing speed ', '+{} max health']

positive_stat_weights = [1, 0.8, 8]

positive_stat_multipliers = [5, 5, 5]

positive_stat_max = [20, 20, 5]

negative_stat_list = ['-{}% damage penalty ', '-{}% slower firing speed ', '-{} max health']

negative_stat_weights = [1, 0.8, 8]

negative_stat_multipliers = [5, 5, 5]

negative_stat_max = [20, 20, 5]

status_effects = ['Slow', 'Bleed', 'Afterburn', 'Jarate']

status_effects_weights = [2.5, 1, 1, 4]

def generateValues():
	global standard_random_number
	global effect_random_number
	global positive_stat_index
	
	positive_stat_index = random.randint(0, (len(positive_stat_list)) - 1)

	standard_random_number = random.randint(2, round(positive_stat_max[positive_stat_index]))

	effect_random_number = random.randint(3, 8)

def genPositive():
	generateValues()
	global current_weight
	global positive_stat_index
	if conditional == False:
		print(str(positive_stat_list[positive_stat_index].format(standard_random_number * positive_stat_multipliers[positive_stat_index])))
		current_weight += round(((positive_stat_weights[positive_stat_index] * standard_random_number) * effect_random_number))
		#print(current_weight)
		#print(standard_random_number)
		#print(effect_random_number)
	else:
		positive_stat_list.extend(conditional_stat_list)
		positive_stat_weights.extend(conditional_stat_weights)
		positive_stat_index = random.randint(0, (len(positive_stat_list)) - 1)
		conditional_index = random.randint(0, (len(conditionals)) - 1)
		print(str(conditionals[conditional_index]) + str(positive_stat_list[positive_stat_index].format(standard_random_number * positive_stat_multipliers[positive_stat_index])) + "for {} seconds".format(effect_random_number))
		current_weight += round(((positive_stat_weights[positive_stat_index] * standard_random_number) * effect_random_number) / conditionals_weights[conditional_index])
		#print(current_weight)
		#print(standard_random_number)
		#print(effect_random_number)

def genNegative():
	generateValues()
	global current_weight
	global positive_stat_index
	if conditional == False:
		print(str(negative_stat_list[positive_stat_index].format(standard_random_number * negative_stat_multipliers[positive_stat_index])))
		current_weight += round(((negative_stat_weights[positive_stat_index] * standard_random_number) * effect_random_number)) * -1
		#print(current_weight)

genPositive()



while abs(current_weight) >= 2:
	if current_weight < -2:
		genPositive()
	elif current_weight > 2:
		genNegative()