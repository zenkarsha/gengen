UserPosts = (resolve, reject) ->
  Vue.http.get('/template/user-posts.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
        FeedListMixin

        FeedModel
        FeedCountModel
      ]

      data: ->
        {
          list: []
        }

      beforeCreate: ->
        @$parent.$parent.loading = true
        firebase.auth().onAuthStateChanged (user) ->
          if !user then redirect_home()

      methods:
        load_list: ->
          self = @
          @model.feed.read_user_list @user.uid ,'created_at', 'desc', @per_page, (results) ->
            self.$parent.$parent.loading = false
            self.handle_list_result results, false
          , (error) ->
            self.$parent.$parent.loading = false
            self.handle_list_error error

        reload_list: ->
          setTimeout( ->
            scroll_top()
          , 500)
          @list = []
          @last_doc = null
          @no_more_data = false
          @empty_list = false
          @load_list()

        show_more: ->
          self = @
          gogo.start()
          @model.feed.read_user_list_paginate @user.uid, 'created_at', 'desc', @last_doc, @per_page, (results) ->
            self.handle_list_result results, false
          , (error) -> self.handle_list_error error

        delete_post: (item) ->
          gogo.start()
          self = @
          @model.feed.delete_item item.pid, (result) ->
            self.model.feed_count.delete_item item.pid, (result) ->
              self.reload_list()
            , (error) -> xx error
          , (error) ->
            xx error
            gogo.stop()
            noty self.$t('alert.something_went_wrong'), 'error'

      watch:
        user: (value) ->
          gogo.start()
          @load_list()
