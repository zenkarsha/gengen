UserMixin =
  data: ->
    {
      user: null
      user_loaded: false
    }

  created: ->
    @auth_user()

  methods:
    auth_user: ->
      self = @
      firebase.auth().onAuthStateChanged (user) ->
        if user then self.user = user

    login: (provider) ->
      self = @
      if (@is_mobile and @is_safari) or is_webview()
        firebase.auth().signInWithRedirect(AUTH[provider]).then((result) ->
          self.user = result.user
        ).catch (error) ->
          xx error
          noty self.$t('alert.login_failed'), 'error'
      else
        firebase.auth().signInWithPopup(AUTH[provider]).then((result) ->
          self.user = result.user
        ).catch (error) ->
          xx error
          self.$parent.loading = false
          noty self.$t('alert.login_failed'), 'error'

    logout: ->
      self = @
      firebase.auth().signOut().then ( ->
        self.user = null
      ), (error) ->
        xx error
        noty self.$t('alert.logout_failed'), 'error'

    anonymous_login: ->
      firebase.auth().signInAnonymously().catch (error) -> redirect '/'

    handle_user_avatar: ->
      if @user and @user.isAnonymous is false
        if @user.providerData[0].providerId is 'facebook.com'
          return @user.photoURL + '?type=large'
        else if @user.providerData[0].providerId is 'twitter.com'
          return @user.photoURL.replace '_normal', ''
        else
          return @user.photoURL
      else
        return '/images/avatar-placeholder.jpg'
