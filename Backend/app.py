import io
import base64
from PIL import Image
import flask
import imgToAscii as img
from key import keys

app = flask.Flask(__name__)

@app.route('/')
def home():
    return flask.render_template('index.html')

@app.route("/test")
def test():
    return flask.jsonify({
        "test": True,
        "output": "Hello World"
    })

@app.route('/img-to-ascii', methods=['POST'])
def img_to_ascii():
    try:
        # Get the image data and key from the request arguments
        img_data = flask.request.files['image'].read()
        apiKey = flask.request.form['apiKey']

        if not apiKey in keys:
            response = {
                "Error": "Invalid key"
            }
            return flask.jsonify(response)

        # Decode the image from base64 and open it with PIL
        img_binary = io.BytesIO(img_data)
        ascii_art = img.image_to_ascii(img_binary=img_binary)

        # Create the response dictionary
        response = {
            "state": "success",
            "ascii_art": ascii_art
        }

        return flask.jsonify(response)

    except Exception as e:
        print(e)
        return flask.jsonify({"error": str(e)})