## Deployment

The app lives on Heroku at https://lane-breach.herokuapp.com/ which you must be logged into to deploy. Make sure to add the heroku remote using ```heroku git:remote -a lane-breach```.

* You can push a new version of the app using ```git subtree push --prefix lanebreach-api heroku master```.
* You can run migrations using ```heroku run rake db:migrate```.

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
