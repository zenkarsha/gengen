Vue.component 'page-not-found',
  template: """
    <div class="error-container">
      <img src="/images/404.png" />
      <div class="error-content">
        <h1>Page Not Found</h1>
        <p>
          This is awkward. Its possible the internet is broken, or the world is ending. Either way, why don't you head on back to the home page.
        </p>
        <router-link :to="{name: 'home', params: {lang: $route.params.lang}}" class="button" v-text="'GET ME OUT OF HERE'"></router-link>
      </div>
    </div>
  """

  mounted: -> document.title = '404'
