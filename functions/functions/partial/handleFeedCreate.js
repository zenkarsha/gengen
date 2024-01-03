exports.handleFeedCreate = functions.firestore.document('feed/{pid}').onCreate((snap, context) => {
  const __admin = admin;
  const pid = context.params.pid;
  const gid = snap.data().gid;

  function insert_feed_count(snap) {
    let data = {
      pid: pid,
      gid: gid,
      visit_count: 0,
      like_count: 0,
      report_count: 0,
      last_visit: Math.floor(Date.now() / 1000),
      public: snap.data().public,
      banned: false,
      flagged: false,
      deleted: false
    };

    return __admin.firestore().collection('feed_count').doc(pid).set(data).then(result => {
      console.log(pid + ': feed_count insert success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  return insert_feed_count(snap);
});
