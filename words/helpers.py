import json
import copy
import stats

#--------------------------------------
def add_keys(d, l, c=None):
	"""
		forms a nested structure of keys 'l' and put 'c' at the end; d is an empty dict that will be populated...
		returns something like: {'500': {'501': {'502': 'lying'}}} if called as add_keys({}, [500,501,502], 'lying')
	"""

	if len(l) > 1:
	    d[l[0]] = _d = {}
	    d[l[0]] = d.get(l[0], {})
	    add_keys(d[l[0]], l[1:], c)
	else:
	    d[l[0]] = c

#--------------------------------------
def convert_category_number_to_name(structure, cat_number):
	return structure['categories'][cat_number]['name']

#--------------------------------------
def process_visualization(structure):
	
	"""
		this function will take the structure (formed earlier from the wordslist) and return data something like this:

		{
			name: "Honor",
			children: [
				{
				name: "genhon",
				children: [
					{
						name: "honour*"
					},
					{
						name: "honor*"
					},
					...
				],
				...
			]
		}

	"""
	
	data = []
	top_level_cat = None 		#this is top level cat, such as 500 (Honor)...

	#find the top-level (level_0) and level_1 categories, that come after the top-level category, e.g: 
	#in "lying	500	501	502	", 500 is the top-level cat(level_0) and 501 is the first level...
	
	for word in structure['words']:
		d = {}
		categories = structure['words'][word]['categories']
		top_level_cat = [categories[0]]

		add_keys(d, categories[1:], word)
		data.append(d)				#data is simply a list of all wordslists' words alongwith their categories nested...

	level_1 = [item.keys()[0] for item in data]
	level_1 = set(level_1)			#level_1 something like: ['518', '540', '522', '506', '513', '504', '501']
	
	result = []
	level_indicator = 1
	result.append({
		'name': convert_category_number_to_name(structure, top_level_cat[0]),
		'children': recurse_categories(data, level_1, level_indicator, top_level_cat, structure)
	})

	return result 

#--------------------------------------
def recurse_categories(data, level_n, level_indicator, parent, structure):

	"""
	args*
	data: a list of line-by-line data from the wordslist. e.g data[0] = {500: {501: {502: 'lying'}}}		
	level_indicator: current level number, e.g: honor (500) is considered level '0'.
	level_n: unique list of categories in the current level. e.g, level_1 = [518 540 522 506 513 504 501]
	parent: a list of parent categories for the current level, e.g: [500, 540] is parent for 507
	structure: is the structure created in words.stats.buildWordsStructure()  function
	"""

	result = []				#This is the main result object that the current function will return to its parent...
	
	#loop through each category in the current level and structure the categories appropriately...
	for item in level_n:
		level_n_plus_1 = []
		level_n_plus_1_words = []
		children = []
		result_child = {}		#This is the result object each function will receive from its child...

		#foreach category in level_n, find the categories that appear after it (i.e, level_n + 1 categories)...
		for word in structure['words']:

			categories = structure['words'][word]['categories']
			
			#find if this is the word that matches the parent and current item...
			if skip(categories, parent, str(item)):
				continue

			#check if we have further categories beyond this level for this word;
			#if yes, save the categories, else record the word itself...
			if len(categories) > level_indicator + 1:
				level_n_plus_1.append(categories[level_indicator + 1])		
			else:
				level_n_plus_1_words.append(word)
		
		#find unique level_n + 1 elements...
		level_n_plus_1 = set(level_n_plus_1)

		#We need to recurse again using level_n_plus_1 categories(if they are present)...
		children = []
		if len(level_n_plus_1) > 0:				
			next_parent = copy.deepcopy(parent)		#create a copy of parent, as this will be different for each resursive function...
			next_parent.append(item)				#for the next level, the current item will also be in the parent's list...
			result_child = recurse_categories(data, level_n_plus_1, level_indicator + 1, next_parent, structure)
	

		#add words that appear in current level to 'children'...
		children = [{'name': level_n_plus_1_word} for level_n_plus_1_word in level_n_plus_1_words]
		
		#add categories/words, that appear in all the nested levels of this level...
		if result_child != {}: 						#if this is {}, this means recursive function was not called for this level...
			if type(result_child) == dict:
				children.append(result_child)
			if type(result_child) == list:
				children.extend(result_child)

		result.append({
			'name': convert_category_number_to_name(structure, item),
			'children': children
		})

	#if result is a single-item list, just return the first element (not as a list)...
	return (result[0] if len(result) == 1 else result)

#--------------------------------------
def skip(categories, parent, item):

	"""
	For skip to return False (i.e do not skip), the following must be true:
	1. length of categories > length of parent + 1
	2. categories[i] = parent[i] for i in range(0, len(parent))
	3. categories[len(parent)] = item 

	In short, categories should have items from parent, and then the 'item' in it.
	"""

	if len(categories) < len(parent) + 1:
		return True

	for i in range(0, len(parent)):
		if categories[i] != parent[i]:
			return True

	if categories[len(parent)] != item:
		return True

	return False

#--------------------------------------
if __name__ == "__main__":
	
	#testing the script...
	f = open('../uploads/95523d21-1526-4487-b49a-ab7b1a4704f8_Honor_English__v2013Bayan_fixed999.txt')
	wordsText = f.read()
	f.close()

	structure = stats.buildWordsStructure(wordsText)  
	print process_visualization(structure)
