exports.handleGeneratorsCreate = functions.firestore.document('generators/{gid}').onCreate((snap, context) => {
  const __admin = admin;
  const gid = context.params.gid;
  const cid = snap.data().cid;
  const tags = snap.data().tags.split(',');

  function insert_generator_count(snap) {
    let data = {
      gid: gid,
      visit_count: 0,
      use_count: 0,
      like_count: 0,
      report_count: 0,
      last_visit: Math.floor(Date.now() / 1000),
      last_use: Math.floor(Date.now() / 1000),
      public: snap.data().public,
      banned: false,
      flagged: false,
      deleted: false
    };

    __admin.firestore().collection('generators_count').doc(gid).set(data).then(result => {
      console.log(gid + ': generators_count insert success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  function handle_insert_tags(snap) {
    if (tags.length > 0 && tags[0] !== '') {
      for (let i = 0; i < tags.length; i++) {
        insert_tag(tags[i]);
      }
    }
  }

  function insert_tag(tag) {
    let data = {
      tag: tag,
      gid: gid,
      cid: cid,
      timestamp: Math.floor(Date.now() / 1000)
    };
    __admin.firestore().collection('tags').add(data).then(result => {
      console.log(gid + ': ' + tag + ': insert success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  insert_generator_count(snap);
  handle_insert_tags(snap);

  if (snap.data().public === true) {
    const algolia_data = {
      'objectID': context.params.gid,
      'template': snap.data().template,
      'cover': snap.data().cover,
      'title': snap.data().title,
      'description': snap.data().description,
      'event_information': snap.data().event_information,
      'tags': snap.data().tags,
      'cid': snap.data().cid,
      'multiple_title': snap.data().multiple_title,
      'multiple_description': snap.data().multiple_description,
      'multiple_event_information': snap.data().multiple_event_information,
      'multiple_tags': snap.data().multiple_tags
    }

    const algolia_index = algolia_client.initIndex(ALGOLIA_INDEX_NAME);
    return algolia_index.saveObject(algolia_data);
  }
  else {
    return null;
  }
});
