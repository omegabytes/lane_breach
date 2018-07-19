#!/usr/bin/env python
###############################################################################
# Title: api.py
# author: Kadyn Martinez
###############################################################################
# Service entry point for evaluating and processing images for lane breach.
# Requires model ckpt for car detection and Yad2k present. 
###############################################################################


from flask import Flask, jsonify, request, Response
import jsonpickle
import numpy as np
import cv2

app = Flask(__name__)

@app.route('/api/v1/img', methods=['POST'])
def process_image_provided():
    image_data = np.fromstring(request.data, np.uint8)
    img = cv2.imdecode(image_data, cv2.IMREAD_COLOR)

    # image in memory and ready for processing.

    # respond
    response = {
        "message": "image recieved. size=%fx%f" % (img.shape[1], img.shape[0])
    }
    response_pickled = jsonpickle.encode(response)
    return Response(response=response_pickled, status=200, mimetype="application/json")

@app.route('/api/v1/fetch', methods=['POST'])
def process_image_fetch():
    payload = request.get_json()
    img_s3 = payload["s3_image_url"]
    # NEED TO USE BOTO, MUST WRAP

def main():
    app.run(debug=True)

if __name__ == '__main__':
    main()