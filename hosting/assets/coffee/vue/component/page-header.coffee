Vue.component 'page-header',
  template: """
    <header id="header" ref="header">
      <div class="container">
        <router-link :class="['logo', $route.params.lang]" :to="{name: 'home', params: {lang: $route.params.lang}}" :title="$t('nav.home')"></router-link>
        <div class="header-nav desktop-view">
          <header-search ref="header_search"></header-search>
          <router-link :to="{name: 'create', params: {lang: $route.params.lang}}">
            <span v-text="$t('nav.create')"></span>
          </router-link>
          <router-link :to="{name: 'feed_home', params: {lang: $route.params.lang}}">
            <span v-text="$t('nav.feed')"></span>
          </router-link>
          <router-link :to="{name: 'generator_list', params: {lang: $route.params.lang}}">
            <span v-text="$t('nav.generator_list')"></span>
          </router-link>
          <router-link :to="{name: 'official_list', params: {lang: $route.params.lang}}">
            <span v-text="$t('nav.official_list')"></span>
          </router-link>
          <router-link :to="{name: 'login', params: {lang: $route.params.lang}}" v-text="$t('nav.login')" class="button small" v-if="!user || (user && user.isAnonymous)"></router-link>
          <nav-user-dropdown :user_avatar="handle_user_avatar()" v-if="user && user.isAnonymous == false"></nav-user-dropdown>
        </div>
        <div class="header-nav mobile-view">
          <div class="mobile-nav-button mobileNavButton" v-on:click="toggle_mobile_nav">
            <span></span>
          </div>
          <transition name="fade">
            <div class="mobile-nav-overlay" v-if="mobile_nav_on == true" v-on:click="toggle_mobile_nav"></div>
          </transition>
          <transition name="fade">
            <div class="mobile-nav" v-if="mobile_nav_on == true">
              <div class="mobile-nav-items">
                <router-link :to="{name: 'create', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                  <i class="menuicon create"></i>
                  <span v-text="$t('nav.create')"></span>
                </router-link>
                <router-link :to="{name: 'feed_home', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                  <i class="menuicon post"></i>
                  <span v-text="$t('nav.feed')"></span>
                </router-link>
                <router-link :to="{name: 'generator_list', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                  <i class="menuicon list"></i>
                  <span v-text="$t('nav.generator_list')"></span>
                </router-link>
                <router-link :to="{name: 'official_list', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                  <i class="menuicon official"></i>
                  <span v-text="$t('nav.official_list')"></span>
                </router-link>
                <hr />
                <router-link :to="{name: 'login', params: {lang: $route.params.lang}}" v-text="$t('nav.login')" v-on:click.native="toggle_mobile_nav" v-if="!user || (user && user.isAnonymous)"></router-link>
                <span v-if="user && user.isAnonymous == false">
                  <router-link :to="{name: 'user_account', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                    <i class="menuicon member"></i>
                    <span v-text="$t('nav.user_account')"></span>
                  </router-link>
                  <router-link :to="{name: 'user_generators', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                    <i class="menuicon generator"></i>
                    <span v-text="$t('nav.user_generators')"></span>
                  </router-link>
                  <router-link :to="{name: 'user_posts', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                    <i class="menuicon post"></i>
                    <span v-text="$t('nav.user_posts')"></span>
                  </router-link>
                  <router-link :to="{name: 'user_photos', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                    <i class="menuicon image"></i>
                    <span v-text="$t('nav.user_photos')"></span>
                  </router-link>
                  <router-link :to="{name: 'user_links', params: {lang: $route.params.lang}}" v-on:click.native="toggle_mobile_nav">
                    <i class="menuicon link"></i>
                    <span v-text="$t('nav.user_links')"></span>
                  </router-link>
                  <router-link :to="{name: 'logout', params: {lang: $route.params.lang}}" v-text="$t('nav.logout')" v-on:click.native="toggle_mobile_nav"></router-link>
                </span>
              </div>
              <div class="mobile-nav-close-button">
                <button type="button" class="button icon" v-on:click="toggle_mobile_nav">
                  <span></span>
                </button>
              </div>
            </div>
          </transition>
        </div>
      </div>
    </header>
  """

  mixins: [
    UserMixin
  ]

  data: ->
    {
      mobile_nav_on: false
    }

  methods:
    toggle_mobile_nav: ->
      @mobile_nav_on = if @mobile_nav_on is false then true else false

  watch:
    $route: (to, from) ->
      @$refs.header_search.close()
