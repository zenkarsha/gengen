FeedHome = (resolve, reject) ->
  Vue.http.get('/template/feed-home.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
        FeedListMixin
        CreatorNameMixin

        GeneratorsModel
        GeneratorsOfficialModel
        CreatorsModel
        FeedModel
        FeedCountModel
      ]
      data: ->
        {
          loading_failed: false
        }

      beforeCreate: ->
        @$parent.loading = true
        gogo.start()

      mounted: ->
        @init()

      methods:
        init: ->
          self = @
          @model.feed.read_list 'created_at', 'desc', @per_page, (results) ->
            self.handle_list_result results, false
            self.$parent.loading = false
          , (error) ->
            self.handle_list_error error
            self.$parent.loading = false

        show_more: ->
          self = @
          gogo.start()
          @model.feed.read_list_paginate 'created_at', 'desc', @last_doc, @per_page, (results) ->
            self.handle_list_result results, false
          , (error) -> self.handle_list_error error
