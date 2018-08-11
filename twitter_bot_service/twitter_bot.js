'use strict';

module.exports.favourite = (event, context, callback) => {
    const ctrl = new twitCtrl();
    const requestBody = JSON.parse(event.body);
    const tag = requestBody.hashtag;
    const count = requestBody.count;

    var params = {
        tag:tag,
        count: count
    };

    const response = {
        statusCode: 200,
        body: JSON.stringify({
            message: ctrl.favourite(params, callback)

        }),
    };
    callback(null, response);
};