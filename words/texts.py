import time
import codecs
import os


def save(text, path="./files"):
    name = "%s.txt" % time.time()
    with codecs.open('%s/%s' % (path, name), 'w+', 'utf-8-sig') as f:
        f.write(text)
    return name


def load(name, path="./files"):
    text = ''
    with codecs.open('%s/%s' % (path, name), 'r', 'utf-8-sig') as f:
        text = f.read()
    return text


def remove(name, path="./files"):
    print "Removing %s" % name
    os.remove('%s/%s' % (path, name))
    return {'result': True}
