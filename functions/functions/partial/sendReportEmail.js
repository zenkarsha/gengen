exports.sendReportEmail = functions.firestore.document('report/{doc}').onCreate((snap, context) => {
  const report = snap.data();
  const mail_options = {
    from: '"系統通知" <gengen.works@gmail.com>',
    to: 'hi@gengen.co',
    subject: '檢舉通報',
    html: '<p><b>原因</b>：' + report.reason + '<br /><br /><b>訊息</b>：' + report.message + '<br /><br /><b>網址</b>：' + report.url + '</p><p>[' + report.model_name + '][' + report.doc_id + ']</p>'
  };

  try {
    mail_transport.sendMail(mail_options);
    console.log('Mail sent success');
  } catch (error) {
    console.error('There was an error while sending the email:', error);
  }

  return null;
});
