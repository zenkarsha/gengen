routes = [
  {
    path: '/'
    component:
      template: '<router-view></router-view>'
    children: [
      {
        path: ''
        component:
          beforeCreate: ->
            lang_initial()
            redirect_home()
      }
      {
        path: 'login'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'login', { lang: i18n.locale }
      }
      {
        path: 'logout'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'logout', { lang: i18n.locale }
      }
      {
        path: 'create'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'create', { lang: i18n.locale }
      }
      {
        path: 'privacy'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'privacy', { lang: i18n.locale }
      }
      {
        path: 'terms'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'terms', { lang: i18n.locale }
      }
      {
        path: 'faq'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'faq', { lang: i18n.locale }
      }
      {
        path: 'g/:gid'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'gen', { lang: i18n.locale, gid: @$route.params.gid }
      }
      {
        path: 'official/:gid'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'official', { lang: i18n.locale, gid: @$route.params.gid }
      }
      {
        path: 'post/:pid'
        component:
          beforeCreate: ->
            lang_initial()
            route_redirect 'feed_post', { lang: i18n.locale, pid: @$route.params.pid }
      }
    ]
  }
  {
    path: '/:lang'
    component:
      template: """
        <div>
          <page-loading :loading="loading"></page-loading>
          <page-processing :processing="processing"></page-processing>
          <page-publishing :publishing="publishing"></page-publishing>
          <page-header></page-header>
          <div id="main">
            <router-view></router-view>
          </div>
          <page-footer></page-footer>
        </div>
      """
      data: -> {
        loading: true
        processing: false
        publishing: false
      }
      beforeCreate: ->
        if @$route.params.lang isnt i18n.locale
          if langs.hasOwnProperty @$route.params.lang
            i18n.locale = @$route.params.lang
          else
            lang_initial()
            route_redirect 'home', { lang: i18n.locale }
      watch:
        $route: (to, from) ->
          i18n.locale = to.params.lang
          Cookies.set '_gg_lang', to.params.lang, expires: 42689
          go = from.path.replace(from.params.lang, to.params.lang)
          if from.path isnt go then router.push({ path: go })
        loading: (value) -> if value is true then lock_html() else unlock_html()

    children: [
      { path: '', name: 'home', component: Home }
      { path: 'login', name: 'login', component: Login }
      { path: 'logout', name: 'logout', component: Logout }
      { path: 'create', name: 'create', component: Create }
      { path: 'g/:gid', name: 'gen', component: Generator }
      { path: 'official', name: 'official_list', component: GeneratorOfficialList }
      { path: 'official/:gid', name: 'official', component: GeneratorOfficial }
      { path: 'feed-home', name: 'feed_home', component: FeedHome }
      {
        path: 'feed/:gid'
        component: template: '<router-view></router-view>'
        children: [
          { path: '', name: 'feed', component: Feed }
        ]
      }
      { path: 'post/:pid', name: 'feed_post', component: FeedPost }
      { path: 'tag/:tag', name: 'tag', component: TagList }
      { path: 'creator/:cid', name: 'creator', component: CreatorList }
      { path: 'privacy', name: 'privacy', component: Privacy }
      { path: 'terms', name: 'terms', component: Terms }
      { path: 'faq', name: 'faq', component: FAQ }
      {
        path: 'user'
        component:
          template: '<router-view></router-view>'
          created: -> if @$route.name is undefined then route_redirect 'user_account', {}
        children: [
          { path: 'account', name: 'user_account', component: UserAccount }
          {
            path: 'generators'
            name: 'user_generators'
            component: UserGenerators
            children: [
              { path: 'edit/:_gid', name: 'edit_generator', component: UserGenerators }
            ]
          }
          { path: 'posts', name: 'user_posts', component: UserPosts }
          { path: 'photos', name: 'user_photos', component: UserPhotos }
          { path: 'links', name: 'user_links', component: UserLinks }
        ]
      }
      {
        path: 'list'
        component: template: '<router-view></router-view>'
        children: [
          { path: '', name: 'generator_list', component: GeneratorList }
          { path: 'popular', name: 'popular_list', component: PopularList }
          { path: 'most-used', name: 'most_used_list', component: MostUsedList }
        ]
      }
      { path: '__gg__', component: GG }
      {
        path: '*'
        component:
          template: '<component v-bind:is="page_template"></component>'
          data: ->
            {
              page_template: 'page-not-found'
            }
          mounted: -> @$parent.loading = false
      }
    ]
  }
]

router = new VueRouter(
  routes: routes
  mode: 'history'
)

router.beforeEach (to, from, next) ->
  setTimeout( ->
    $('#page_loading').show()
    scroll_top()
    window.onbeforeunload = ->
      $('body').hide()
      scroll_top()
  , 100)
  next()

router.afterEach (to, from) ->
  setTimeout( ->
    $('#page_loading').hide()
  , 100)
