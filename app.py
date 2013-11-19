from flask import Flask
from views.upload import UploadAPI

app = Flask(__name__, static_folder='static/app', static_url_path='')
app.add_url_rule('/upload/', view_func=UploadAPI.as_view('uploadapi'))


if __name__ == '__main__':
    app.run()
