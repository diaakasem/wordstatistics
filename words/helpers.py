import json
import copy

import stats

def get_value(d, l):
	if len(l) > 1:
	    return get_value(d[l[0]], l[1:])
	return d[l[0]]

def add_keys(d, l, c=None):
	if len(l) > 1:
	    d[l[0]] = _d = {}
	    d[l[0]] = d.get(l[0], {})
	    add_keys(d[l[0]], l[1:], c)
	else:
	    d[l[0]] = c

def convert_category_number_to_name(structure, cat_number):
	return structure['categories'][cat_number]['name']

def process_visualization(structure):

	data = []
	top_level_cat = None

	for word in structure['words']:
		d = {}
		categories = structure['words'][word]['categories']
		top_level_cat = categories[0]

		add_keys(d, categories[1:], word)
		data.append(d)

	#find unique level2 categories ...
	level2 = [item.keys()[0] for item in data]
	level2 = set(level2)			#level2 something like: set([501, 502, 504])

	#append level2 to main category...
	# d = {}
	# d[top_level_cat] = []
	# for item in level2:
	# 	d[top_level_cat].append(item)

	
	# d['name'] = top_level_cat
	# d['children'] = []
	# for item in level2:
	# 	d['children'].append({
	# 			'name': item
	# 		})
	
	
	#loop through level2 categories...
	obj = []
	for item in level2:
	
		level3 = []
		level3_words = []

		#foreach category in level2, find the categories that appear after it (i.e, third level categories)...
		for word in structure['words']:

			d = {}
			categories = structure['words'][word]['categories']
			second_level_cat = categories[1]
			
			if second_level_cat != str(item):	#if its not the category we're looking for, skip...
				continue
			
			#check if we have further categories beyond the second for this word;
			#if yes, save the category, else record the word itself...
			if len(categories) > 2:
				level3.append(categories[2])		#categories[2] is a third-level category...
			else:
				level3_words.append(word)
		

		#find unique third level elements...
		level3 = set(level3)
		
		#add all children of second-level categories, note that some children are categories themselves while
		#some are words; hence the if condition...

		children = []
		if len(level3) > 0:					#level3 is a category in itself...
			children.extend([{'name': convert_category_number_to_name(structure, item_level3)} for item_level3 in level3])

		if len(level3_words) > 0:			#level3 is just a word...
			children.extend([{'name': level3_word} for level3_word in level3_words])

		#create the obj for this second-level category, something like:
		# {'name': 'HonGain', 'children': [{'name': 'Achieve'}, {'name': 'Status'}]

		obj.append({
				'name': convert_category_number_to_name(structure, item),
				'children': children
			})


	result = []
	result.append({
		'name': convert_category_number_to_name(structure, top_level_cat),
		'children': obj
	})
	
	return result

if __name__ == "__main__":
	
	f = open('../uploads/95523d21-1526-4487-b49a-ab7b1a4704f8_Honor_English__v2013Bayan_fixed999.txt')
	wordsText = f.read()
	f.close()

	structure = stats.buildWordsStructure(wordsText)  
	process_visualization(structure)
