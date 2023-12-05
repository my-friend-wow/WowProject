from api.common import app


@app.route('/', methods=['GET'])
def test():
    return {"message": "Hello World"}
