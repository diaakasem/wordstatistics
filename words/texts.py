import time
import codecs
import os


def save(text):
    name = "%s.txt" % time.time()
    with codecs.open('./files/%s' % name, 'w+', 'utf-8-sig') as f:
        f.write(text)
    return name


def load(name):
    text = ''
    with codecs.open('./files/%s' % name, 'r', 'utf-8-sig') as f:
        text = f.read()
    return text


def remove(name):
    os.remove('./files/%s' % name)
    return {'result': True}
