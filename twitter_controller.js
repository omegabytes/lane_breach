'use strict';

const Twitter = require('twitter');

module.exports.main = function main (event, context, callback) {
    // let client = new Twitter(config.twitter);
    let client = new Twitter({
        consumer_key: process.env["consumer_key"],
        consumer_secret: process.env["consumer_secret"],
        access_token_key: process.env["access_token_key"],
        access_token_secret: process.env["access_token_secret"]
    });

    console.log(event.body);


    let tweetContent = JSON.parse(event.body).tweet;

    client.post('statuses/update', {status: tweetContent},  function(error, tweet, response) {
        if(error) {
            callback(null, {statusCode: 400, body: error})
        }
        console.log(tweet);  // Tweet body.
        console.log(response);  // Raw response object.
        callback(null, {statusCode: 200, body: "success"})
    });

};
