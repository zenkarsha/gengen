Vue.component 'user-side-nav',
  template: """
    <div class="side-nav">
      <router-link :to="{name: 'user_account', params: {lang: $route.params.lang}}">
        <i class="menuicon member"></i>
        <span v-text="$t('nav.user_account')"></span>
      </router-link>
      <router-link :to="{name: 'user_generators', params: {lang: $route.params.lang}}">
        <i class="menuicon generator"></i>
        <span v-text="$t('nav.user_generators')"></span>
      </router-link>
      <router-link :to="{name: 'user_posts', params: {lang: $route.params.lang}}">
        <i class="menuicon post"></i>
        <span v-text="$t('nav.user_posts')"></span>
      </router-link>
      <router-link :to="{name: 'user_photos', params: {lang: $route.params.lang}}">
        <i class="menuicon image"></i>
        <span v-text="$t('nav.user_photos')"></span>
      </router-link>
      <router-link :to="{name: 'user_links', params: {lang: $route.params.lang}}">
        <i class="menuicon link"></i>
        <span v-text="$t('nav.user_links')"></span>
      </router-link>
    </div>
  """
