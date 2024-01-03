exports.poemGenerator = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    if(request.body.input_str) {
      const input_str = request.body.input_str;
      const length = request.body.length;
      const position = request.body.position;
      const __response = response;

      console.log(input_str);

      //=require ../poem_gen/dict.js
      //=require ../poem_gen/gram1.js
      //=require ../poem_gen/gram2.js
      //=require ../poem_gen/AcrosticPoem.js

      const poem_gen = new PoemGen();
      poem_gen.setting({
        input_str: input_str,
        position: position,
        length: length
      });

      poem_gen.run(function(result) {
        if (result.length > 0) {
          let poem = result.join("\r\n");
          return __response.send(JSON.stringify({'poem': poem}));
        }

        return __response.send(JSON.stringify({'poem': null}));
      });
    }

    return response.send(JSON.stringify({'poem': null}));
  })
});
