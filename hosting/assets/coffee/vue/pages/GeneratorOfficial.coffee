GeneratorOfficial = (resolve, reject) ->
  Vue.http.get('/template/generator-official.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
        FeedListMixin

        GeneratorsOfficialModel
        FeedModel
        FeedCountModel
      ]

      data: ->
        {
          gid: ''
          config: title: ''
        }

      beforeCreate: ->
        @$parent.loading = true
        gogo.start()

      mounted: ->
        @gid = @$route.params.gid.split('-').slice(-1).pop()
        @load_generator()
        @load_feed_list()

      updated: ->
        @update_title()

      methods:
        load_generator: ->
          self = @
          @model.generators_official.read_item @gid, (result) ->
            if result.exists
              gogo.stop()
              self.config = result.data()
              self.config.gid = self.gid
              self.config.share_link = 'https://gengen.co/' + self.$route.params.lang + '/official/' + self.gid
            else
              self.handle_404_page()
          , (error) ->
            xx error
            self.handle_404_page()

        load_feed_list: ->
          self = @
          # @model.feed_count.read_generator_list @gid, 'visit_count', 'desc', 'last_visit', 'desc', 6, (results) ->
          #   self.handle_list_result results, true
          # , (error) -> self.handle_list_error error
          @model.feed.read_generator_list @gid, 'created_at', 'desc', 12, (results) ->
            self.handle_list_result results, false
            self.$parent.$parent.loading = false
          , (error) -> self.handle_list_error error

        update_title: ->
          if @_i18n isnt null and @config.title isnt ''
            @page_title =  @create_page_title @config.title

        handle_404_page: ->
          gogo.stop()
          @config.template = '404'
          @page_title =  @create_page_title '404 Page Not Found'
          @$parent.loading = false

      computed:
        load_template: -> @config.template
