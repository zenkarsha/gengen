Login = (resolve, reject) ->
  Vue.http.get('/template/login.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
      ]

      beforeCreate: ->
        @$parent.loading = true
        self = @
        firebase.auth().onAuthStateChanged (user) ->
          if !user
            self.$parent.loading = false

      beforeRouteEnter: (to, from, next) ->
        save_current_route()
        next()

      methods:
        handle_login: (provider) ->
          @$parent.loading = true
          switch provider
            when 'github' then @login 'github'
            when 'google' then @login 'google'
            when 'twitter' then @login 'twitter'
            when 'facebook' then @login 'facebook'

      watch:
        user: (value) ->
          if @user and @user.isAnonymous is false then route_back()
