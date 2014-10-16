import json
import copy


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
		visualize_data = {}
		categories = structure['words'][word]['categories']
		top_level_cat = categories[0]

		add_keys(visualize_data, categories[1:], word)
		data.append(visualize_data)

	#find level2 categories...
	level2 = [item.keys()[0] for item in data]
	level2 = set(level2)

	#append level2 to main category...
	# d = {}
	# d[top_level_cat] = []
	# for item in level2:
	# 	d[top_level_cat].append(item)

	d = {}
	# d['name'] = top_level_cat
	# d['children'] = []
	# for item in level2:
	# 	d['children'].append({
	# 			'name': item
	# 		})

	d = []
	d.append({
		'name': convert_category_number_to_name(structure, top_level_cat),
		'children': [{"name": convert_category_number_to_name(structure, item)} for item in level2]
		})

	return d






