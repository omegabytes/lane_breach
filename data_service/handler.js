const _       = require('lodash');
const rp      = require('request-promise');
const fs      = require('fs');
const knox    = require('knox');
const request = require('request');
const AWS     = require('aws-sdk');
const es      = require('event-stream');
const http    = require('http');

// get a list of all bike reports
// for each report that contains a url
// upload the image to s3
// add the s3 url to the record
// send the record to image_parser service
// update record with image_parser results
// add record to list of updated records
// update internal DB with updated records list

// todo: implement IAM
AWS.config.update({
  accessKeyId    : "AKIAINJ4OND4747W2BFA",
  secretAccessKey: "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",
  region: "us-west-2"
});

let docClient = new AWS.DynamoDB.DocumentClient();
let client   = knox.createClient({
  key   : "AKIAINJ4OND4747W2BFA",
  secret: "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",
  bucket: "lane-breach"
});



// data sourced from sf.openData
let url   = "https://data.sfgov.org/resource/ktji-gk7t.json";
let token = 'erzdPUb9V8btdxnZd3KV7JeYK'; // token for 311, works on all datasets

let total  = 3000000; // total number of rows in the dataset
let offset = 0; // variable to handle SOAP pagination

// todo: add logic for daily date range
let options = {
  uri    : url,
  method : "GET",
  headers: {
    'Content-Type': 'application/json',
    'X-App-Token' : `${token}`
  },
  qs     : {
    "$limit"         : total,
    //    "$offset": offset,
    "service_subtype": "Blocking_Bicycle_Lane"
  }
};

let updatedRecords = [];

rp(options)
  .then((res) => {
    let reports = JSON.parse(res);
    console.log(reports.length);
    
    // todo: sanitize urls
    reports.forEach((report) => {
      if(report.media_url) {
        if(report.media_url.includes('.jpg')) {
          console.log(report.media_url)
          http.get(report.media_url, function(res) {
            let headers = {
              'Content-Length': res.headers['content-length'],
              'Content-Type'  : res.headers['content-type']
            };
            let req = client.putStream(res, `/311-sf/images/${report.service_request_id}.png`, headers, function(err, res) {
              if(err) {
                console.log(err)
              }
            });
            
            req.on('response', (res) => {
              if(200 === res.statusCode) {
                console.log('saved to %s', req.url);
                report.s3_media_url = `https://s3-us-west-1.amazonaws.com/lane-breach/311-sf/images/${report.service_request_id}.png`;
                report.image_parsed = false;
                
                
                
                let dbopts = {
                  Item: report,
                  TableName: "BikeLaneReports"
                };
  
                docClient.put(dbopts, function(err, data) {
                  if(err) console.log(err, err.stack); // an error occurred
                  else console.log("uploaded", report.s3_media_url);           // successful response
                  /*
                  data = {
                   ConsumedCapacity: {
                    CapacityUnits: 1,
                    TableName: "Music"
                   }
                  }
                  */
                });
                
                // send the record to image analyzer service
//                let imgPayload = {
//                  uri    : "kadyn's func",
//                  method : "POST",
//                  headers: {
//                    'Content-Type': 'application/json'
//                  },
//                  body   : report
//                };
//
//                rp(imgPayload)
//                  .then((res) => {
//                    // post the record to dynamo
//
//                  })
              }
            });
          });
        }
      }
    })
    
    
  });
