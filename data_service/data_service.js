const _ = require('lodash');
const rp = require('request-promise');
const request = require('request');
const knox = require('knox');
const AWS = require('aws-sdk');
const http = require('http');
const config = require('../config.js');
const moment = require('moment')


// get a list of all bike reports
// for each report that contains a url
// upload the image to s3
// add the s3 url to the record
// send the record to image_parser service
// update record with image_parser results
// add record to list of updated records
// update internal DB with updated records list

// V21211 (38N) BICYCLE PATHS/LNS $132

// store your creds in ~/.aws/credentials or load them from your config.js
AWS.config.update({
    region: "us-west-2"
});

let docClient = new AWS.DynamoDB.DocumentClient();

// knox requires you explicitly pass creds
let client = knox.createClient({
    key: config.aws.key,
    secret: config.aws.secret,
    bucket: "lane-breach"
});


// data sourced from sf.openData
let url = "https://data.sfgov.org/resource/ktji-gk7t.json";
let total = 3000000; // total number of rows in the dataset
let date = moment().local();
date = date.subtract(2, 'days').format('YYYY-MM-DDTHH:mm:ss');



let options = {
    uri: url,
    method: "GET",
    headers: {
        'Content-Type': 'application/json',
        'X-App-Token': config.open_data.token
    },
    qs: {
        "$limit": total,
        "service_subtype": "Blocking_Bicycle_Lane",
        // "$select": "*",
        // "$where": `requested_datetime > '${date}'`
    }
};

let updatedRecords = [];

rp(options)
    .then((res) => {
        let reports = JSON.parse(res);
        console.log(reports.length);
        console.log("Total potential fines: $", reports.length*132);

        let district = _.countBy(reports,'supervisor_district')

        console.log(district)




        reports.forEach((report) => {


            if (report.media_url) {
                if (report.media_url.includes('.jpg')) {
                    console.log(report.media_url);

                    request
                        .get(report.media_url)
                        .on('response', function (res) {
                            let headers = {
                                'Content-Length': res.headers['content-length'],
                                'Content-Type': res.headers['content-type']
                            };

                            let req = client.putStream(res, `/311-sf/images/${report.service_request_id}.png`, headers, function (err, res) {
                                if (err) {
                                    console.log(err)
                                }
                            });

                            req.on('response', (res) => {
                                if (200 === res.statusCode) {
                                    console.log('saved to %s', req.url);
                                    report.s3_media_url = `https://s3-us-west-1.amazonaws.com/lane-breach/311-sf/images/${report.service_request_id}.png`;
                                    report.image_parsed = false;

                                    let dbopts = {
                                        Item: report,
                                        TableName: "BikeLaneReports"
                                    };

                                    // updatedRecords.push(docClient.put(dbopts));

                                    // updatedRecords.push(docClient.put(dbopts, function (err, data) {
                                    //     console.log('this is firing')
                                    //     if (err) console.log(err, err.stack);
                                    //     else console.log("uploaded", report.s3_media_url);
                                    // }).promise());

                                    console.log(updatedRecords.length)

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
                            })

                        })
                        // .on('complete', ()=>{
                        //     console.log("done")
                        //     // console.log(updatedRecords)
                        //     // Promise.all(updatedRecords)
                        //     //     .then(()=>{
                        //     //         console.log('promise all fired')
                        //     //     })
                        // })
                }
            }
        })
    });
