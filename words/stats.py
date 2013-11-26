# get some statistics of a story text
# count lines, sentences, words, frequent words ...
# tested with Python 2.5.4 and Python 3.1.1

def statsText(text):

    # set all the counters to zero
    lines = 0
    blanklines = 0
    # start with empty word list and character frequency dictionary
    word_list = []
    cf_dict = {}
    # reads one line at a time
    for line in text.split('\n'):
        # count lines and blanklines
        lines += 1
        if line.startswith('\n'):
            blanklines += 1
        # create a list of words
        # split at any whitespace regardless of length
        word_list.extend(line.split())
        # create a character:frequency dictionary
        # all letters adjusted to lower case
        for char in line.lower():
            cf_dict[char] = cf_dict.get(char, 0) + 1

    # create a word frequency dictionary
    # all words in lower case
    word_dict = {}
    # a list of punctuation marks (could use string.punctuation)
    punctuations = [",", ".", "!", "?", ";", ":"]
    for word in word_list:
        # get last character of each word
        lastchar = word[-1]
        # remove any trailing punctuation marks from the word
        if lastchar in punctuations:
            word = word.rstrip(lastchar)
        # convert to all lower case letters
        word = word.lower()
        word_dict[word] = word_dict.get(word, 0) + 1

    # assume that each sentence ends with '.' or '!' or '?'
    sentences = 0
    for key in cf_dict.keys():
        if key in '.!?':
            sentences += cf_dict[key]

    number_words = len(word_list)
    num = float(number_words)
    avg_wordsize = len(''.join([k*v for k, v in word_dict.items()]))/num

    # most common words
    mcw = sorted([(v, k) for k, v in word_dict.items()], reverse=True)

    # most common characters
    mcc = sorted([(v, k) for k, v in cf_dict.items()], reverse=True)

    # formatted prints will work with Python2 and Python3
    statistics = {
        "lines": lines,
        "blank_lines": blanklines,
        "sentenses": sentences,
        "words": number_words,
        "avg_word_length": avg_wordsize,
        "most_common_words": mcw[:3],
        "most_common_chars": mcc[:3]
    }
    return statistics


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
