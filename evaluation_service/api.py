from flask import Flask, jsonify, request, Response
import jsonpickle
import numpy as np
import cv2

app = Flask(__name__)

@app.route('/api/v1/img', methods=['POST'])
def process_image():
    image_data = np.fromstring(request.data, np.uint8)
    img = cv2.imdecode(image_data, cv2.IMREAD_COLOR)

    # image in memory and ready for processing.

    # respond
    response = {
        "message": "image recieved. size=%fx%f" % (img.shape[1], img.shape[0])
    }
    response_pickled = jsonpickle.encode(response)
    return Response(response=response_pickled, status=200, mimetype="application/json")

def main():
    app.run(debug=True)

if __name__ == '__main__':
    main()