Vue.component 'page-footer',
  template: """
    <footer id="footer">
      <div class="container">
        <div class="footer-wrapper">
          <div class="footer-logo-container">
            <div class="logo"></div>
            <div class="site-introduce">
              <h3 v-text="$t('title.sponsor_us')">贊助我們</h3>
              <p>
                ${$t('message.sponsor_message')}<br />
                ${$t('text.btc_donate')}: <span class="clipboard-button" v-tooltip="$t('button.click_copy')" data-clipboard-text="18ZzWowwJqidVjbRucQjStdsnTk7nD1r8A">18ZzWowwJqidVjbRucQjStdsnTk7nD1r8A</span><br />
                ${$t('text.eth_donate')}: <span class="clipboard-button" v-tooltip="$t('button.click_copy')" data-clipboard-text="0xe9d13be6b5df35993e747c92ccd694b98c337bde">0xe9d13be6b5df35993e747c92ccd694b98c337bde</span>
              <p>
              <h3 v-if="$route.params.lang == 'zh_hant'">工商服務</h3>
              <p v-if="$route.params.lang == 'zh_hant'">
                本站完成於提供高程式碼轉換率咖啡與寧靜工作環境的<br />
                <a href="https://www.facebook.com/coffeeandwork/" target="_blank" onClick="ga('send', 'event', 'Coffee & Work Link Click', 'Click', 'Coffee & Work');"><u>Coffee & Work</u></a> 咖啡店
              <p>
            </div>
          </div>
          <div class="footer-nav">
            <div class="footer-list">
              <h4 v-text="$t('title.generators')"></h4>
              <div class="footer-nav" v-on:click="scroll_top">
                <router-link :to="{name: 'generator_list', params: {lang: $route.params.lang}}" v-text="$t('nav.newest_list')"></router-link>
                <router-link :to="{name: 'popular_list', params: {lang: $route.params.lang}}" v-text="$t('nav.popular_list')"></router-link>
                <router-link :to="{name: 'most_used_list', params: {lang: $route.params.lang}}" v-text="$t('nav.most_used_list')"></router-link>
                <router-link :to="{name: 'official_list', params: {lang: $route.params.lang}}" v-text="$t('nav.official_list')"></router-link>
              </div>
            </div>
            <div class="footer-list">
              <h4 v-text="$t('title.about')"></h4>
              <div class="footer-nav" v-on:click="scroll_top">
                <router-link :to="{name: 'privacy', params: {lang: $route.params.lang}}" v-text="$t('nav.privacy')"></router-link>
                <router-link :to="{name: 'terms', params: {lang: $route.params.lang}}" v-text="$t('nav.terms')"></router-link>
                <router-link :to="{name: 'faq', params: {lang: $route.params.lang}}" v-text="$t('nav.faq')"></router-link>
              </div>
            </div>
            <div class="footer-list">
              <h4 v-text="$t('title.follow_us')"></h4>
              <div class="footer-nav" v-on:click="scroll_top">
                <a href="https://fb.com/kxgio">Facebook</a>
                <a href="https://twitter.com/gengen_co">Twitter</a>
              </div>
            </div>
            <div class="footer-list">
              <h4 v-text="$t('title.language')"></h4>
              <div class="footer-nav" v-on:click="scroll_top">
                <router-link v-for="(value, key, index) in langs"　:to="{name: $route.name, params: {lang: key}}" v-text="value"></router-link>
              </div>
            </div>
          </div>
        </div>
        <div class="copyright">
          Copyright © ${$t('site.title')} All Rights Reserved.
        </div>
      </div>
    </footer>
  """
