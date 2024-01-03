exports.exportAlgolia = functions.https.onRequest((request, response) => {
  const __response = response;
  const algolia_index = algolia_client.initIndex(ALGOLIA_INDEX_NAME);
  const algolia_browser = algolia_index.browseAll();
  let hits = [];

  algolia_browser.on('result', function onResult(content) {
    hits = hits.concat(content.hits);
  });

  algolia_browser.on('end', function onEnd() {
    console.log('We got %d hits', hits.length);
    return __response.status(200).send(JSON.stringify(hits, null, 2));
  });

  algolia_browser.on('error', function onError(err) {
    throw err;
  });
});
