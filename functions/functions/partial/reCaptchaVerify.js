exports.reCaptchaVerify = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    if (request.body.token) {
      const __response = response;
      __response.send(JSON.stringify({'success': true}));

      const options = {
        body: {
          'secret': '',
          'response': request.body.token
        },
        url: ' https://www.google.com/recaptcha/api/siteverify',
        headers: {
          'content-type': 'application/x-www-form-urlencoded'
        },
        json: true
      }

      request.post(options, (error, response, body) => {
        if (error) {
          __response.send(JSON.stringify({'success': false}));
        }
        else {
          __response.send(JSON.stringify({'success': true}));
        }
      });
    }
    else {
      response.send('Okay.');
    }
  })
});
