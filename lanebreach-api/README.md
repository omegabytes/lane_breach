## API

### Mobile metadata

#### GET /api/mobile_metadata

**request:** 
```
curl -XGET http://localhost:3000/api/mobile_metadata
```

**response:**
```
[{"id":1,"created_at":"2018-10-29T04:49:53.008Z","updated_at":"2018-10-29T04:49:53.008Z","environment":"a","category":"b","token":"c","request_id":"d"}]
```

#### POST /api/mobile_metadata

**request:** 
```
curl -XPOST http://localhost:3000/api/mobile_metadata -H "Content-Type: application/json" -d '{"mobile_metadatum":{"environment":"a", "category":"b", "token":"c", "request_id":"d"}}'
```

**response:**
```
{"id":1,"created_at":"2018-10-29T04:49:53.008Z","updated_at":"2018-10-29T04:49:53.008Z","environment":"a","category":"b","token":"c","request_id":"d"}
```

### Bikeway Networks

#### GET /api/bikeway_networks

**request:** 
```
curl -XGET http://localhost:3000/api/bikeway_networks?lat=37.74675537&long=-122.4587284
```

**response:**
```
{"gid":648,"install_yr":"2010.0","streetname":"LAGUNA HONDA BLVD","symbology":"BIKE LANE","dist":0.00506722}
```

**request:** 
```
curl -XGET http://localhost:3000/api/bikeway_networks?lat=-122.4587284&long=37.74675537
```

**response:**
```
null
```
