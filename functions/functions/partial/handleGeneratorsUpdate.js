exports.handleGeneratorsUpdate = functions.firestore.document('generators/{gid}').onUpdate((change, context) => {
  const __admin = admin;
  const gid = context.params.gid;
  const cid = change.before.data().cid;
  const before_tags = change.before.data().tags.split(',');
  const after_tags = change.after.data().tags.split(',');
  const algolia_index = algolia_client.initIndex(ALGOLIA_INDEX_NAME);

  function in_array(needle, haystack) {
    let length = haystack.length;
    let i = 0;
    while (i < length) {
      if (haystack[i] === needle) {
        return true;
      }
      i++;
    }
    return false;
  }

  function handle_insert_tag(tag) {
    let data = {
      tag: tag,
      gid: gid,
      cid: cid,
      timestamp: Math.floor(Date.now() / 1000)
    };

    return __admin.firestore().collection('tags').add(data).then(result => {
      console.log(tag + ': tags_count insert success');
      return null;
    }).catch(error => {
      console.log(error);
      return null;
    });
  }

  function handle_delete_tag(tag) {
    return __admin.firestore().collection('tags').where('tag', '==', tag).where('gid', '==', gid).get().then(results => {
      console.log('checking tag exsit or not...')
      console.log('exsit state: ' + results.empty)
      if (!results.empty) {
        return execute_delete_tag(results.docs[0].id);
      }
      return null;
    }).catch(error => {
      console.log(error);
      return null;
    });
  }

  function execute_delete_tag(doc_id) {
    return __admin.firestore().collection('tags').doc(doc_id).delete().then(results => {
      console.log(doc_id + ': tag delete success');
      return null;
    }).catch(error => {
      console.log(error);
      return null;
    });
  }

  console.log('starting generator update...');

  if (after_tags.length > 0 && after_tags[0] !== '') {
    for (let i = 0; i < after_tags.length; i++) {
      let tag = after_tags[i];
      if (in_array(tag, before_tags) === false) {
        console.log(tag + ' does not exist in new tag array');
        handle_insert_tag(tag);
      }
    }
  }
  if (before_tags.length > 0 && before_tags[0] !== '') {
    for (let i = 0; i < before_tags.length; i++) {
      let tag = before_tags[i];
      if (in_array(tag, after_tags) === false) {
        console.log(tag + ' does not exist in old tag array');
        handle_delete_tag(tag);
      }
    }
  }

  let algolia_data = {
    'objectID': gid,
    'template': change.after.data().template,
    'cover': change.after.data().cover,
    'title': change.after.data().title,
    'description': change.after.data().description,
    'event_information': change.after.data().event_information,
    'tags': change.after.data().tags,
    'cid': cid,
    'multiple_title': change.after.data().multiple_title,
    'multiple_description': change.after.data().multiple_description,
    'multiple_event_information': change.after.data().multiple_event_information,
    'multiple_tags': change.after.data().multiple_tags
  }

  if (change.after.data().deleted === true) {
    console.log(gid + ': starting delete generator...');

    __admin.firestore().collection('generators_count').doc(gid).update({ deleted: change.after.data().deleted }).then(result => {
      console.log(gid + ': generators_count set to deleted success');
      return null;
    }).catch(error => {
      console.log(error);
      return null;
    });

    for (let i = 0; i < before_tags.length; i++) {
      let tag = before_tags[i];
      handle_delete_tag(tag);
    }

    return algolia_index.deleteObject(gid, function(error, content) {
      if (error) throw error;
      console.log(content);
      return null;
    });
  }
  else if (change.before.data().public !== change.after.data().public) {
    console.log('update generator public state change...');

    __admin.firestore().collection('generators_count').doc(gid).update({ public: change.after.data().public }).then(result => {
      console.log(gid + ': generators_count public state update success');
      return null;
    }).catch(error => {
      console.log(error);
      return null;
    });

    if (change.after.data().public === false) {
      console.log('starting delete algolia object');
      return algolia_index.deleteObject(gid, function(error, content) {
        if (error) throw error;
        console.log(content);
        return null;
      });
    }
  }
  else {
    console.log('generator public state: ' + change.after.data().public);
    if (change.after.data().public === true) {
      console.log('starting update generator algolia object...');
      return algolia_index.saveObject(algolia_data);
    }
    else {
      console.log('generator update success');
      return null;
    }
  }
});
