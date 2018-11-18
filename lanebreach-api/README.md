## Deployment

The app lives on Heroku at https://lane-breach.herokuapp.com/ which you must be logged into to deploy. Make sure to add the heroku remote using ```heroku git:remote -a lane-breach```.

* You can push a new version of the app using ```git subtree push --prefix lanebreach-api heroku master```.
* You can run migrations using ```heroku run rake db:migrate```.

## Development

Run `yarn start` to run the Rails server locally. Be sure you have the Docker agent installed and running.

## API

### Mobile metadata

#### GET /api/mobile_metadata

**request:** 
```
curl -XGET https://lane-breach.herokuapp.com/api/mobile_metadata
```

**response:**
```
[{"id":1,"created_at":"2018-10-29T04:49:53.008Z","updated_at":"2018-10-29T04:49:53.008Z","environment":"a","category":"b","token":"c","request_id":"d"}]
```

#### POST /api/mobile_metadata

**request:** 
```
curl -XPOST https://lane-breach.herokuapp.com/api/mobile_metadata -H "Content-Type: application/json" -d '{"mobile_metadatum":{"environment":"a", "category":"b", "token":"c", "request_id":"d"}}'
```

**response:**
```
{"id":1,"created_at":"2018-10-29T04:49:53.008Z","updated_at":"2018-10-29T04:49:53.008Z","environment":"a","category":"b","token":"c","request_id":"d"}
```

### Bikeway Networks

#### GET /api/bikeway_networks

**request:** 
```
curl -XGET https://lane-breach.herokuapp.com/api/bikeway_networks?lat=37.74675537&long=-122.4587284
```

**response:**
```
{"gid":648,"install_yr":"2010.0","streetname":"LAGUNA HONDA BLVD","symbology":"BIKE LANE","dist":0.00506722}
```

**request:**
```
curl -XGET https://lane-breach.herokuapp.com/api/bikeway_networks?lat=-122.4587284&long=37.74675537
```

**response:**
```
null
```

## API

### SF 311 Cases

#### GET /api/sf311_cases

**request:**
```
curl -XGET https://lane-breach.herokuapp.com/api/sf311_case/bike_lane_blockages?start_time=2018-6-15&end_time=2018-6-17
```

**response:**
```
{
  "id": 1,
  "address": "2927 FOLSOM ST, SAN FRANCISCO, CA, 94110",
  "agency_responsible": "Parking Enforcement Review Queue",
  "closed_date": "2018-06-16T15:14:09.000",
  "lat": "37.75041",
  "long": "-122.4138",
  "neighborhoods_sffind_boundaries": "Mission",
  "point": {
  "type": "Point",
    "coordinates": [
      -122.41369887,
      37.75039981
    ]
  },
  "police_district": "MISSION",
  "requested_datetime": "2018-06-16T15:14:02.000",
  "service_details": "Parking Enforcement",
  "service_name": "Parking Enforcement",
  "service_request_id": "9145772",
  "service_subtype": "Blocking_Bicycle_Lane",
  "source": "Mobile/Open311",
  "status_description": "Closed",
  "status_notes": "The report has been logged and will help the City collect data on double parking and bike lane violations to determine target areas and future enforcement efforts. Thank you.",
  "supervisor_district": "9",
  "updated_datetime": "2018-06-16T15:14:09.000"
  "created_at": "2018-11-17T00:36:41+00:00"
  "updated_at": "2018-11-17T00:36:41+00:00"
},
...
```

#### POST /api/sf311_cases

**request:**
```
curl -XPOST https://lane-breach.herokuapp.com/api/sf311_case -H "Content-Type: application/json" -d
  '{
    "sf311_case": {
      "address": "326 14TH ST, SAN FRANCISCO, CA, 94103",
      "agency_responsible": "Parking Enforcement Review Queue",
      "lat": "37.76826",
      "long": "-122.4205",
      "neighborhoods_sffind_boundaries": "Mission",
      "police_district": "MISSION",
      "requested_datetime": "2018-07-11T16:41:59.000",
      "service_details": "Cream - Shitty new 2000s model vw bug - 6ncv876",
      "service_subtype": "Blocking_Bicycle_Lane",
      "source": "Mobile/Open311",
      }
    }'
```

**response:**
```
TBD
```
