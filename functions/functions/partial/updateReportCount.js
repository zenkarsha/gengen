exports.updateReportCount = functions.firestore.document('report/{doc}').onCreate((snap, context) => {
  const __admin = admin;
  const model_name = snap.data().model_name;
  const doc_id = snap.data().doc_id;
  const report_limit = 1;

  function update_report_count(doc_id, report_count) {
    __admin.firestore().collection(model_name + '_count').doc(doc_id).update({ report_count: report_count }).then(result => {
      console.log('success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  function flag_document(model_name, doc_id) {
    __admin.firestore().collection(model_name).doc(doc_id).update({ flagged: true }).then(result => {
      console.log('success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  function flag_count_document(model_name, doc_id) {
    __admin.firestore().collection(model_name + '_count').doc(doc_id).update({ flagged: true }).then(result => {
      console.log('success');
      return null;
    }).catch(error => {
      console.log(error);
    });
  }

  return __admin.firestore().collection('report').where('doc_id', '==', doc_id).get().then(results => {
    let report_count = results.docs.length;
    if (report_count >= report_limit) {
      flag_document(model_name, doc_id);
      flag_count_document(model_name, doc_id);
    }
    return update_report_count(doc_id, report_count);
  }).catch(error => {
    console.log(error);
  });
});
