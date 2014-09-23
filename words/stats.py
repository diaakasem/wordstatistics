# get some statistics of a story text
# count lines, sentences, words, frequent words ...
# tested with Python 2.5.4 and Python 3.1.1
from nltk.tokenize import word_tokenize
from nltk.probability import FreqDist
import re

#commasPattern = re.compile('\,{2,}')            #a comma repeated two or more times consecutively...
digi = re.compile('\d+')


def buildWordsStructure(wordsListText):
    ### build correct structure
    # structure = {
    #   words: {
    #      someword: {
    #          freq: 0,
    #          categories: [501, 502,.. ]
    #      }
    #   },
    #   categories: {
    #      '501': {
    #          'name' : 'blah',
    #          'freq' : 0
    #      }
    #   }
    #}
    ###
    structure = {
        'words': {},
        'categories': {}
    }
    inCategories = False
    for line in wordsListText.split('\n'):
        #line = re.sub(commasPattern, '', line)
        line = line.strip()                     #remove all tabs and extra whitespaces...
        if line == '%':
            inCategories = not inCategories
            continue

        #inCategories is True for categories only; the first few lines in the wordslist starting from % and ending with %...
        if inCategories:
            category, title = line.split('\t')
            structure['categories'][category] = {
                'name': title,
                'freq': 0
            }
        else:
            wordsAndCategories = line.split('\t')
            word = wordsAndCategories[0]
            categories = wordsAndCategories[1:]   
            
            structure['words'][word] = {
                'freq': 0,
                'categories': categories
            }

            # categoriesAndWords = line.split(',')
            # categories = []
            # for item in categoriesAndWords:
            #     m = digi.match(item)
            #     if m:
            #         categories.append(m.group())

            #         if len(item) > len(m.group()):
            #             structure['words'][item[3:]] = {
            #                 'freq': 0,
            #                 'categories': categories
            #             }
            #     # else:
                #     structure['words'][item] = {
                #         'freq': 0,
                #         'categories': categories
                #     }

    return structure


def statsText(text, words):

    fdist = FreqDist()
    # formatted prints will work with Python2 and Python3
    for word in word_tokenize(text):
        #fdist.inc(word.lower())
        fdist[word] += 1

    return [(k, fdist.freq(k)) for k in words]


def statsFile(text):
    # write the test file
    fname = "MyText1.txt"
    fout = open(fname, "w")
    fout.write(text)
    fout.close()

    # read the test file back in
    # or change the filename to a text you have
    textf = open(fname, "r")
    return statsText(textf)
