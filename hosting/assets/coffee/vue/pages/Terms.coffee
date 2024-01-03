Terms = (resolve, reject) ->
  Vue.http.get('/template/default.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
      ]

      data: ->
        {
          title: ''
          content: ''
        }

      updated: ->
        file = '/document/terms/' + @$route.params.lang + '.md'
        $.get file, ((data) ->
          @title = @$t('nav.terms')
          @content = data
          @$parent.loading = false
        ).bind @

      beforeRouteEnter: (to, from, next) ->
        next((vm) ->
          vm.$forceUpdate()
          scroll_top()
        )

      beforeRouteUpdate: (to, from, next) ->
        @.$forceUpdate()
        next()
