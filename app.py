from eve import Eve
from flask.views import MethodView
from flask import request, url_for, jsonify


app = Eve()


class CalcAPI(MethodView):

    def get(self):
        return 'hi'

    def post(self):
        return 'hi'


@app.route('/+upload', methods=['GET', 'POST'])
def upload():
    if request.method == 'GET':
        # we are expected to return a list of dicts with infos about the 
        # already available files:
        file_infos = []
        for file_name in list_files():
            file_url = url_for('download', file_name=file_name)
            file_size = get_file_size(file_name)
            file_infos.append(dict(name=file_name,
                                   size=file_size,
                                   url=file_url))
        return jsonify(files=file_infos)

    if request.method == 'POST':
        # we are expected to save the uploaded file and return some infos about it:
        #                              vvvvvvvvv   this is the name for input type=file
        data_file = request.files.get('data_file')
        file_name = data_file.filename
        save_file(data_file, file_name)
        file_size = get_file_size(file_name)
        file_url = '/download/%s'% file_name
        # providing the thumbnail url is optional
        thumbnail_url = url_for('thumbnail', file_name=file_name)
        return jsonify(name=file_name,
                       size=file_size,
                       url=file_url,
                       thumbnail=thumbnail_url)

app.add_url_rule('/calc/', view_func=CalcAPI.as_view('calc'))

if __name__ == '__main__':
    app.run()
