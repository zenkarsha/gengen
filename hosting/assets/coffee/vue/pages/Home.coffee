Home = (resolve, reject) ->
  Vue.http.get('/template/home.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
      ]

      beforeCreate: ->
        @$parent.loading = true
        gogo.start()

      mounted: ->
        @$parent.loading = false
