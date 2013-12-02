# get some statistics of a story text
# count lines, sentences, words, frequent words ...
# tested with Python 2.5.4 and Python 3.1.1
from nltk.tokenize import word_tokenize
from nltk.probability import FreqDist


def statsText(text, words):

    fdist = FreqDist()
    # formatted prints will work with Python2 and Python3
    for word in word_tokenize(text):
        fdist.inc(word.lower())

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
