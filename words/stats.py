import nltk
from nltk import FreqDist
from nltk.tokenize import word_tokenize
import hashlib


#TODO: make use of memcache before using this class
class Stats(object):

    def __init__(self, text):
        self.fdist = FreqDist(word.lower() for word in word_tokenize(text))
        self.digest = hashlib.md5(text).hexdigest()
        self.freqList = []

    #TODO: Make use of memcache
    #TODO: Update this method if text updates
    def list(self):
        """
        @return list    List of the words found in the text
        """
        if not self.freqList:
            self.freqList = self.fdist.items()
            self.freqList.sort(lambda x, y: cmp(x[1], y[1]), reverse=True)

        return self.freqList

    def frequency(self, word):
        """
        @param  text    The text to calculate frequency for the passed word in
        @param  word    The word to search for in the text
        @return float   representing the frequency of occurences of
                        the word in text
        """
        return self.fdist.freq(word)

    def process(self, text):
        pass
