# get some statistics of a story text
# count lines, sentences, words, frequent words ...
# tested with Python 2.5.4 and Python 3.1.1
from nltk.tokenize import word_tokenize
from nltk.probability import FreqDist
import re

#commasPattern = re.compile('\,{2,}')            #a comma repeated two or more times consecutively...
digi = re.compile('\d+')
matchEverything = re.compile('.*')

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
        line = line.strip()                     #remove all extra tabs and whitespaces...
        if line == '%':
            inCategories = not inCategories
            continue

        #inCategories is True for categories only; the first few lines in the wordslist starting from % and ending with %...
        if inCategories:
            category, title = line.split('\t')          #data is tab-delimited, e.g: "511    Achieve" ...
            structure['categories'][category] = {
                'name': title,
                'freq': 0
            }
        else:
            #each line is tab-delimited and has word and categories mixed; the first entry is the word and the
            #remainings are categories, e.g: "lying 500 501 502 "

            wordAndCategories = line.split('\t')       
            word = wordAndCategories[0]
            categories = wordAndCategories[1:]   
            
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
        fdist[word.lower()] += 1


    #loop over the words in fdist and see if you can find those words in the wordslist keys. Since some words in the  
    #wordslist also has wildcard * at the end to denote anything after the initial word, we use Regex to match those 
    #rather than matching on equity; e.g wrong* will match wrong, wrongful, wrongfully, wronged etc...

    frequencies = []

    for word in words:
        if '*' in word:         #if word has * we need to compare it with each item in fdist...
            wordRegEx = word.replace('*', '.*')         #make it suitable for Regular Expression...
            for k in fdist:
                m = re.match(wordRegEx, k)
                if m:
                    frequencies.append((word, fdist.freq(m.group())))

        else:
            frequencies.append((word, fdist.freq(word)))

    return frequencies

    # return [(k, fdist.freq(k)) for k in words]


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
