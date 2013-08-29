from eve import Eve
from flask.views import MethodView

app = Eve()


class CalcAPI(MethodView):

    def get(self):
        return 'hi'

    def post(self):
        return 'hi'

app.add_url_rule('/calc/', view_func=CalcAPI.as_view('calc'))

if __name__ == '__main__':
    app.run()
