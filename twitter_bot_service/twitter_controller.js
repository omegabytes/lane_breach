'use strict';

var Twitter = require('twitter');
var config = require('./config');

var T = new Twitter(config);

module.exports = class TwitterController {
    constructor() { }

    favourite(params, callback) {

        // Initiate search using passed paramaters
        T.get('search/tweets', params, function (err, data, response) {
            // If there is no error, proceed
            if (!err) {

                // Loop through the returned tweets
                for (let i = 0; i < data.statuses.length; i++) {
                    // Get the tweet Id from the returned data
                    let id = { id: data.statuses[i].id_str }
                    // Try to Favorite the selected Tweet
                    T.post('favorites/create', id, function (err, response) {
                        // If the favorite fails, log the error message
                        if (err) {
                            callback(err[0].message);
                        }

                    });
                }
            } else {
                callback(err);
            }
        })

        const response = {
            statusCode: 200,
            body: JSON.stringify({
                message: 'Tweets Favourited',
                data: params // eslint-disable-line
            })
        };
        callback(null, response);
    }

}