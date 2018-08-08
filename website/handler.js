'use strict';

module.exports.landingPage = (event, context, callback) => {
  let dynamicHtml = `<p>Here's how you can help</p>`;
  // check for GET params and use if available
  if (event.queryStringParameters && event.queryStringParameters.name) {
    dynamicHtml = `<p>Hey ${event.queryStringParameters.name}!</p>`;
  }

  const html = `
  <html>
  <head>
  <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
    body, html {
        height: 100%;
        margin: 0;
    }
    
    .bg {
        background-image: url("https://s3-us-west-1.amazonaws.com/lane-breach/images/lane_breach_bg.jpg");
        
        height: 100%;
        
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
    }
      h1 { color: #73757d; }
    </style>
    </head>
    <body>
      <h1>Let's get cars out of bike lanes</h1>
      ${dynamicHtml}
      <div class="bg"></div>
    </body>
  </html>`;

  const response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html',
    },
    body: html,
  };

  // callback is sending HTML back
  callback(null, response);
};
