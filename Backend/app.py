import io
import os
import flask
import imgToAscii as img

app = flask.Flask(__name__)

@app.route('/')
def home():
    return flask.render_template('index.html')

@app.route('/api/img-to-ascii', methods=['POST'])
def img_to_ascii():
    try:
        # Get the image data and key from the request arguments
        img_data = flask.request.files['image'].read()
        apiKey = flask.request.form['apiKey']

        correctApiKey = os.getenv("apiKey")

        if  apiKey != correctApiKey:
            response = {
                "Error": "Invalid key",
                "Provided Key": apiKey
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