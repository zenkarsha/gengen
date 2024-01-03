Generator = (resolve, reject) ->
  Vue.http.get('/template/generator.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
        FeedListMixin
        CreatorNameMixin

        GeneratorsModel
        GeneratorsCountModel
        CreatorsModel
        FeedModel
        FeedCountModel
      ]

      data: ->
        {
          gid: ''
          config:
            template: 'loading'
            title: ''
          visit_count: 0
          use_count: 0
        }

      beforeCreate: ->
        @$parent.loading = true
        gogo.start()

      mounted: ->
        @gid = @$route.params.gid.split('-').slice(-1).pop()
        @load_generator()
        @load_generator_count()
        @load_feed_list()

      updated: ->
        @update_title()

      methods:
        load_generator: ->
          self = @
          @model.generators.read_item @gid, (result) ->
            if result.exists
              gogo.stop()
              self.config = result.data()
              self.config.gid = self.gid
              self.config.share_link = 'https://gengen.co/' + self.$route.params.lang + '/g/' + self.gid
              self.add_creator_name_item result.data().cid
            else
              self.handle_404_page()
          , (error) ->
            xx error
            self.handle_404_page()

        load_generator_count: ->
          self = @
          @model.generators_count.read_item @gid, (result) ->
            if result.exists
              self.visit_count = result.data().visit_count
              self.use_count = result.data().use_count
              self.update_visit_count result.id, self.visit_count
          , (error) -> xx error

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
            if @config.multiple_langs
              @page_title = if @config.multiple_title[@$route.params.lang] isnt '' then @create_page_title @config.multiple_title[@$route.params.lang] else @create_page_title @config.title
            else
              @page_title =  @create_page_title @config.title

        update_visit_count: (doc_id, visit_count) ->
          cookie_name = '_gg_visit_' + @gid
          visit_check = Cookies.get cookie_name
          if visit_check isnt 'true'
            expire_time = new Date((new Date).getTime() + 360 * 60 * 1000)
            Cookies.set cookie_name, 'true', expires: expire_time
            @visit_count = visit_count + 1
            @model.generators_count.increase_visit_count doc_id, @visit_count, (->), (->)

        handle_404_page: ->
          gogo.stop()
          @config.template = '404'
          @page_title =  @create_page_title '404 Page Not Found'
          @$parent.loading = false

      computed:
        load_template: -> 'Generator' + ucfirst @config.template
