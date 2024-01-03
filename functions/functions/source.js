'use strict';

const VERSION = '1.72.99';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const algoliasearch = require('algoliasearch');
const cloudinary = require('cloudinary');
const cors = require('cors')({origin: true});

const ALGOLIA_ID = '';
const ALGOLIA_ADMIN_KEY = '';
const ALGOLIA_SEARCH_KEY = '';
const ALGOLIA_INDEX_NAME = 'generators';
const algolia_client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);

admin.initializeApp();
admin.firestore().settings({timestampsInSnapshots: true});

const gmail_email = '';
const gmail_password = '';
const mail_transport = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: gmail_email,
    pass: gmail_password
  }
});

//=require partial/handleGeneratorsCreate.js
//=require partial/handleGeneratorsUpdate.js
//=require partial/handleTagsCreate.js
//=require partial/handleTagsDelete.js
//=require partial/handleFeedCreate.js
//=require partial/updateFeedLikeCount.js
//=require partial/updateReportCount.js

//=require partial/captchaVerify.js
//=require partial/reCaptchaVerify.js
//=require partial/sendReportEmail.js

//=require partial/createSitemap.js
//=require partial/loadGeneratorSource.js
//=require partial/loadOfficialGeneratorSource.js
//=require partial/loadFeedPostSource.js
//=require partial/exportAlgolia.js

//=require partial/poemGenerator.js
