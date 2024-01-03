exports.handleTagsCreate = functions.firestore.document('tags/{doc}').onCreate((snap, context) => {
  const __admin = admin;
  const tag = snap.data().tag;

  function create_tags_count(data) {
    __admin.firestore().collection('tags_count').add(data).then(result => {
      console.log(tag + ': tags_count insert success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  function get_tags_count(doc_id) {
    __admin.firestore().collection('tags').where('tag', '==', tag).get().then(results => {
      const count = results.docs.length;
      return update_tags_count(doc_id, count);
    }).catch(error => {
      console.log(error);
    });
  }

  function update_tags_count(doc_id, count) {
    __admin.firestore().collection('tags_count').doc(doc_id).update({ count: count, updated_at: Math.floor(Date.now() / 1000) }).then(result => {
      console.log(tag + ': tags_count update success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  return __admin.firestore().collection('tags_count').where('tag', '==', tag).get().then(results => {
    if (results.empty === true) {
      let data = {
        tag: tag,
        count: 1,
        created_at: Math.floor(Date.now() / 1000),
        updated_at: Math.floor(Date.now() / 1000)
      }
      return create_tags_count(data);
    }
    else {
      const doc_id = results.docs[0].id;
      return get_tags_count(doc_id);
    }
  }).catch(error => {
    console.log(error);
  });
});
