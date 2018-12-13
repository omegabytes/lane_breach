# Bikeway Network DB

[Bikeway Network data](https://data.sfgov.org/Transportation/Bikeway-Network/4jy4-tbju) provides information on sf bike paths.

## Local DB

### Setup

In the base project directory, the following commands can be run to get the bike data loaded:
```
yarn build:db
yarn db:run
```

### Usage

You can connect to the db using `yarn db` where the relation `bikeway_network` contains all of the data. A sample query to find the best bikepath within 3 meters of a point:
```
SELECT gid, install_yr, symbology, streetname, st_DistanceSphere(geom, ST_MakePoint(-122.4587284, 37.74675537)) as dist 
FROM bikeway_network 
WHERE st_DistanceSphere(geom, ST_MakePoint(-122.4587284, 37.74675537)) <= 3
ORDER BY dist LIMIT 1;
```

## Remote DB

Use the following to connect to our db:
```
PGPASSWORD=<<PASSWORD>> psql bikelane bikelanes --host bikelanes.cl6adk7d8ywn.us-east-1.rds.amazonaws.com
```
