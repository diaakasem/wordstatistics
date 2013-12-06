from flask import Flask
from views.upload import UploadAPI
from flask import request
from flask import render_template
from flask import jsonify
from words import stats
from words import texts
import json
import os

p = os.path
statics = p.join(p.dirname(p.abspath(__file__)), 'static/app/')
print statics

app = Flask(__name__,
            static_folder=statics,
            static_url_path='',
            template_folder=statics)

app.add_url_rule('/upload/', view_func=UploadAPI.as_view('uploadapi'))


@app.route('/analyze', methods=['POST'])
def analyze():
    data = json.loads(request.data)
    text = data['text']
    words = data['words']
    res = stats.statsText(text, words)
    name = texts.save(text)
    return jsonify({'name': name, 'result': res})


@app.route('/')
def main():
    return render_template('/index.html')

app.secret_key = 'C8Zr98j/3yX R~XZH!jmN]LWX/,?RY'

if __name__ == '__main__':
    app.debug = True
    app.run()
