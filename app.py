from flask import Flask
from flask import request
from flask import render_template
from flask import jsonify
from werkzeug import secure_filename
from words import stats
from words import texts
from uuid import uuid4
import json
import os

p = os.path
statics = p.join(p.dirname(p.abspath(__file__)), 'static/app/')
UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = set(['txt'])

app = Flask(__name__,
            static_folder=statics,
            static_url_path='',
            template_folder=statics)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 160 * 1024 * 1024


@app.route('/removeupload', methods=['POST'])
def removeupload():
    data = json.loads(request.data)
    filename = data['filename']
    return jsonify(texts.remove(filename, './uploads'))


@app.route('/remove', methods=['POST'])
def remove():
    data = json.loads(request.data)
    filename = data['filename']
    return jsonify(texts.remove(filename))


@app.route('/load', methods=['POST'])
def load():
    data = json.loads(request.data)
    filename = data['filename']
    return texts.load(filename)


def getFilePath(filename):
    return os.path.join(app.config['UPLOAD_FOLDER'], filename)


@app.route('/analyzefiles', methods=['POST'])
def analyzefiles():
    data = json.loads(request.data)
    document = data['document']
    words = data['words']
    with open(getFilePath(document), 'r+') as documentFile:
        documentText = documentFile.read()
    with open(getFilePath(words), 'r+') as wordsFile:
        wordsText = wordsFile.read()
        structure = stats.buildWordsStructure(wordsText)
    res = stats.statsText(documentText, structure['words'].keys())
    for comp in res:
        word = comp[0]
        freq = comp[1]
        categories = structure['words'][word]['categories']
        for category in categories:
            catfreq = structure['categories'][category]['freq']
            catfreq += freq
            structure['categories'][category]['freq'] = catfreq

    return jsonify({'result': structure})


@app.route('/analyze', methods=['POST'])
def analyze():
    data = json.loads(request.data)
    text = data['text']
    words = data['words']
    res = stats.statsText(text, words)
    filename = texts.save(text)
    return jsonify({'filename': filename, 'result': res})


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


@app.route('/upload', methods=['POST'])
def upload_file():
    file = request.files['file']
    # Initial values
    res = "Files must be .txt files."
    code = 200
    # If file is allowed
    if file and allowed_file(file.filename):
        filename = "%s_%s" % (uuid4(), secure_filename(file.filename))
        filepath = getFilePath(filename)
        print 'Saving %s ' % filepath
        file.save(filepath)
        res = filename
        code = 200
    else:
        print 'File not allowed '
        print file
    # Return result and success/error code
    return jsonify({"result": res}), code


@app.route('/', methods=['GET'])
def main():
    return render_template('/index.html')

app.secret_key = 'C8Zr98j/3yX R~XZH!jmN]LWX/,?RY'

if __name__ == '__main__':
    app.debug = True
    app.run()
