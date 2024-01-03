RouteMixin =
  data: ->
    {
      page_title: ''
    }

  mounted: ->
    switch @$route.name
      when 'home' then @page_title = @$t('site.title')
      when 'gen', 'feed', 'feed_post', 'tag' then @page_title = 'Loading...'
      else
        @page_title = @create_page_title @$t('nav.' + @$route.name)

  methods:
    create_page_title: (title) -> title + ' - ' + @$t('site.title')

    update_page_title: (title) -> document.title = title

  watch:
    $route:
      deep: true
      handler: (to, from) ->
        i18n.locale = to.params.lang
        @page_title = @$t('site.title')
        @update_page_title @page_title

    page_title: (value) ->
      @update_page_title value
