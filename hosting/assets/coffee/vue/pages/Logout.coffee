Logout =
  mixins: [
    UserMixin
    UseragentMixin
    RouteMixin
  ]

  beforeCreate: ->
    @$parent.loading = true
    self = @
    firebase.auth().onAuthStateChanged (user) ->
      if user and user.isAnonymous is false
        self.logout()
      else
        route_back()

  beforeRouteEnter: (to, from, next) ->
    save_current_route()
    next()

  watch:
    user: (value) ->
      if !@user then route_back()
