import requests
import json
import sys
import cv2

addr = 'http://localhost:5000'
api_route = addr + '/api/v1/img'

content_type = 'image/jpeg'
headers = {'content-type': content_type}

img = cv2.imread(sys.argv[1])

_, img_encoded = cv2.imencode('.jpg', img)
response = requests.post(api_route, data=img_encoded.tostring(), headers=headers)

print json.loads(response.text)