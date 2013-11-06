from flask import Flask
from flask.views import MethodView
from flask import request, jsonify

app = Flask(__name__)

def get_file_size(filename):
    #TODO: fix this 
    return 0

def save_file(filename):
    #TODO: fix this 
    pass

def url_for(filename):
    return '/download/%s' % filename

def list_files():
    #TODO: fix this 
    return []

class UploadAPI(MethodView):

    def get(self):
        # we are expected to return a list of dicts with infos about the 
        # already available files:
        file_infos = []
        for filename in list_files():
            file_url = url_for(filename)
            print file_url
            file_size = get_file_size(filename)
            file_infos.append(dict(name=filename,
                                   size=file_size,
                                   url=file_url))
        return jsonify(files=file_infos)

    def post(self):
        # we are expected to save the uploaded file and return some infos about it:
        #                              vvvvvvvvv   this is the name for input type=file
        data_file = request.files.get('data_file')
        filename = data_file.filename
        save_file(data_file, filename)
        file_size = get_file_size(filename)
        file_url = url_for(filename)
        return jsonify(name=filename, size=file_size, url=file_url)

app.add_url_rule('/upload/', view_func=UploadAPI.as_view('calc'))

if __name__ == '__main__':
    app.run()

