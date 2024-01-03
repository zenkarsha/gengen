Feed = (resolve, reject) ->
  Vue.http.get('/template/feed.html').then (template) ->
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
          gid: ''
          generator:
            title: ''
          loading_failed: false
        }

      beforeCreate: ->
        @$parent.$parent.loading = true
        gogo.start()

      mounted: ->
        @gid = @$route.params.gid
        @init()

      methods:
        init: ->
          self = @
          @model.generators.read_item @gid, (result) ->
            if result.exists
              self.generator = result.data()
              self.load_list()
          , (error) ->
            self.model.generators_official.read_item self.gid, (result) ->
              if result.exists
                self.generator = result.data()
                self.load_list()
            , (error) ->
              self.handle_list_error error
              self.loading_failed = true
              self.$parent.$parent.loading = false

        load_list: ->
          self = @
          @model.feed.read_generator_list @gid, 'created_at', 'desc', @per_page, (results) ->
            self.handle_list_result results, false
            self.$parent.$parent.loading = false
          , (error) ->
            self.handle_list_error error
            self.$parent.$parent.loading = false

        show_more: ->
          self = @
          gogo.start()
          @model.feed.read_generator_list_paginate @gid, 'created_at', 'desc', @last_doc, @per_page, (results) ->
            self.handle_list_result results, false
          , (error) -> self.handle_list_error error

      watch:
        'generator.title': (value) ->
          title = value + @$t('title.generator_feed')
          @page_title = @create_page_title title
