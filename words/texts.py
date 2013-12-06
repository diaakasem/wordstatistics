import time


def save(text):
    name = time.time()
    text = ''
    with open('./files/%s.txt' % name, 'w+') as f:
        f.write(text)
    return name


def load(name):
    text = ''
    with open('./files/%s.txt' % name, 'r') as f:
        text = f.readlines()
    return text
