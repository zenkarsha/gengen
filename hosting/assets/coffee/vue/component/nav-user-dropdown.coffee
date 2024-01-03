Vue.component 'nav-user-dropdown',
  template: """
    <div class="user-nav">
      <div class="user-avatar __user_dropdown_toggle" :style="{ backgroundImage: 'url(' + user_avatar + ')'}" v-on:click="toggle_dropdown()"></div>
      <div :class="['user-nav-dropdown', show_dropdown ? 'on' : '']" v-click-outside:__user_dropdown_toggle="close_dropdown">
        <router-link :to="{name: 'user_account', params: {lang: $route.params.lang}}" v-on:click.native="close_dropdown">
          <i class="menuicon member"></i>
          <span v-text="$t('nav.user_account')"></span>
        </router-link>
        <router-link :to="{name: 'user_generators', params: {lang: $route.params.lang}}" v-on:click.native="close_dropdown">
          <i class="menuicon generator"></i>
          <span v-text="$t('nav.user_generators')"></span>
        </router-link>
        <router-link :to="{name: 'user_posts', params: {lang: $route.params.lang}}" v-on:click.native="close_dropdown">
          <i class="menuicon post"></i>
          <span v-text="$t('nav.user_posts')"></span>
        </router-link>
        <router-link :to="{name: 'user_photos', params: {lang: $route.params.lang}}" v-on:click.native="close_dropdown">
          <i class="menuicon image"></i>
          <span v-text="$t('nav.user_photos')"></span>
        </router-link>
        <router-link :to="{name: 'user_links', params: {lang: $route.params.lang}}" v-on:click.native="close_dropdown">
          <i class="menuicon link"></i>
          <span v-text="$t('nav.user_links')"></span>
        </router-link>
        <hr />
        <router-link :to="{name: 'logout', params: {lang: $route.params.lang}}" v-text="$t('nav.logout')" v-on:click="close_dropdown"></router-link>
      </div>
    </div>
  """

  props: ['user_avatar']

  data: ->
    {
      show_dropdown: false
    }

  methods:
    toggle_dropdown: ->
      @show_dropdown = if @show_dropdown then false else true

    close_dropdown: ->
      @show_dropdown = false
