exports.updateFeedLikeCountOnCreate = functions.firestore.document('feed_like_log/{doc}').onCreate((snap, context) => {
  const __admin = admin;
  const pid = snap.data().pid;

  function update_feed_like_count (like_count) {
    __admin.firestore().collection('feed_count').doc(pid).update({ like_count: like_count }).then(result => {
      console.log(pid + ': like count update success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  return __admin.firestore().collection('feed_like_log').where('pid', '==', pid).get().then(results => {
    const like_count = results.docs.length;
    return update_feed_like_count(like_count);
  }).catch(error => {
    console.log(error);
  });
});

exports.updateFeedLikeCountOnDelete = functions.firestore.document('feed_like_log/{doc}').onDelete((snap, context) => {
  const __admin = admin
  const pid = snap.data().pid;

  function update_feed_like_count (like_count) {
    __admin.firestore().collection('feed_count').doc(pid).update({ like_count: like_count }).then(result => {
      console.log(pid + ': like count update success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  return __admin.firestore().collection('feed_like_log').where('pid', '==', pid).get().then(results => {
    const like_count = results.docs.length;
    return update_feed_like_count(like_count);
  }).catch(error => {
    console.log(error);
  });
});
