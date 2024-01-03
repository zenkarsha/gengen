exports.createSitemap = functions.https.onRequest((request, response) => {
  const __response = response

  return admin.firestore().collection('generators').where('public', '==', true).where('deleted', '==', false).where('banned', '==', false).get().then(result => {
    if (!result.empty) {
      let sitemap_content = `https://gengen.co/
https://gengen.co/zh_hant/
https://gengen.co/zh_hant/official
https://gengen.co/zh_hant/official/kangxi_amnesty
https://gengen.co/zh_hant/official/kangxi_banner
https://gengen.co/zh_hant/official/kangxi_avatar
https://gengen.co/zh_hant/official/kangxi_inscribed_board
https://gengen.co/zh_hant/official/windows_xp_alert
https://gengen.co/zh_hant/official/betman_slap
https://gengen.co/zh_hant/official/kangxi_poem
https://gengen.co/zh_hant/official/kangxi_generator
https://gengen.co/zh_hant/list/
https://gengen.co/zh_hant/list/popular
https://gengen.co/zh_hant/list/most-used
https://gengen.co/zh_hant/privacy
https://gengen.co/zh_hant/terms
https://gengen.co/zh_hant/create
https://gengen.co/zh_hans/
https://gengen.co/zh_hans/official
https://gengen.co/zh_hans/official/kangxi_amnesty
https://gengen.co/zh_hans/official/kangxi_banner
https://gengen.co/zh_hans/official/kangxi_avatar
https://gengen.co/zh_hans/official/kangxi_inscribed_board
https://gengen.co/zh_hans/official/windows_xp_alert
https://gengen.co/zh_hans/official/betman_slap
https://gengen.co/zh_hans/official/kangxi_poem
https://gengen.co/zh_hans/official/kangxi_generator
https://gengen.co/zh_hans/list/
https://gengen.co/zh_hans/list/popular
https://gengen.co/zh_hans/list/most-used
https://gengen.co/zh_hans/privacy
https://gengen.co/zh_hans/terms
https://gengen.co/zh_hans/create
https://gengen.co/ja/
https://gengen.co/ja/official
https://gengen.co/ja/official/kangxi_amnesty
https://gengen.co/ja/official/kangxi_banner
https://gengen.co/ja/official/kangxi_avatar
https://gengen.co/ja/official/kangxi_inscribed_board
https://gengen.co/ja/official/windows_xp_alert
https://gengen.co/ja/official/betman_slap
https://gengen.co/ja/official/kangxi_poem
https://gengen.co/ja/official/kangxi_generator
https://gengen.co/ja/list/
https://gengen.co/ja/list/popular
https://gengen.co/ja/list/most-used
https://gengen.co/ja/privacy
https://gengen.co/ja/terms
https://gengen.co/ja/create
https://gengen.co/en/
https://gengen.co/en/official
https://gengen.co/en/official/kangxi_amnesty
https://gengen.co/en/official/kangxi_banner
https://gengen.co/en/official/kangxi_avatar
https://gengen.co/en/official/kangxi_inscribed_board
https://gengen.co/en/official/windows_xp_alert
https://gengen.co/en/official/betman_slap
https://gengen.co/en/official/kangxi_poem
https://gengen.co/en/official/kangxi_generator
https://gengen.co/en/list/
https://gengen.co/en/list/popular
https://gengen.co/en/list/most-used
https://gengen.co/en/privacy
https://gengen.co/en/terms
https://gengen.co/en/create`;

      for(let i = 0; i < result.docs.length; i++) {
        sitemap_content += "https://gengen.co/zh_hant/g/" + result.docs[i].id + "\n";
        sitemap_content += "https://gengen.co/zh_hans/g/" + result.docs[i].id + "\n";
        sitemap_content += "https://gengen.co/en/g/" + result.docs[i].id + "\n";
        sitemap_content += "https://gengen.co/ja/g/" + result.docs[i].id + "\n";
      }

      return __response.status(200).send(sitemap_content);
    }
    else {
      return __response.status(200).send(`Ok.`);
    }
  }).catch(error => {
    return __response.status(200).send(`Error.`);
  });
});
