FeedPost = (resolve, reject) ->
  Vue.http.get('/template/feed-post.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
        CreatorNameMixin

        GeneratorsModel
        GeneratorsOfficialModel
        CreatorsModel
        FeedModel
        FeedCountModel
      ]

      data: ->
        {
          pid: ''
          post: image: ''
          generator: title: ''
          doc_id: ''
          visit_count: 0
          liked: false
          loading_failed: false
        }

      beforeCreate: ->
        @$parent.loading = true
        gogo.start()

      mounted: ->
        @pid = @$route.params.pid
        @load_post()
        @load_post_count()

      methods:
        load_post: ->
          self = @
          @model.feed.read_item @pid, (result) ->
            gogo.stop()
            if result.exists
              self.doc_id = result.id
              self.post = result.data()
              self.add_creator_name_item result.data().uid
              self.load_generator result.data()
              Sharer.init()
            else
              self.loading_failed = true
              self.$parent.loading = false
              noty self.$t('alert.something_went_wrong'), 'error'
          , (error) ->
            xx error
            gogo.stop()
            self.loading_failed = true
            self.$parent.loading = false

        load_post_count: ->
          self = @
          @model.feed_count.read_item @pid, (result) ->
            if result.exists
              self.visit_count = result.data().visit_count
              self.update_visit_count result.id, self.visit_count
          , (error) -> xx error

        load_generator: (post) ->
          self = @
          if typeof post.official isnt 'undefined'
            @model.generators_official.read_item post.gid, (result) ->
              if result.exists
                self.generator = result.data()
            , (error) -> xx error
          else
            @model.generators.read_item post.gid, (result) ->
              if result.exists
                self.generator = result.data()
            , (error) -> xx error

        update_visit_count: (doc_id, visit_count) ->
          cookie_name = '_gg_i_visit_' + @pid
          visit_check = Cookies.get cookie_name
          if visit_check isnt 'true'
            self = @
            visit_count += 1
            expire_time = new Date((new Date).getTime() + 360 * 60 * 1000)
            Cookies.set cookie_name, 'true', expires: expire_time
            @model.feed_count.increase_visit_count doc_id, visit_count, (result) ->
              @visit_count = visit_count
            , (->)

        delete_post_confirm: ->
          self = @
          #=require ../swal/feed-post-delete_confirm_popup.coffee

        delete_post: ->
          gogo.start()
          self = @
          @model.feed.delete_item @doc_id, (result) ->
            self.model.feed_count.delete_item self.doc_id, (result) ->
              xx 'delete feed_count success'
            , (error) -> xx error
            #=require ../swal/feed-post-delete_success_popup.coffee
          , (error) ->
            xx error
            gogo.stop()
            noty self.$t('alert.something_went_wrong'), 'error'

      watch:
        'generator.title': (value) ->
          title = value + @$t('title.generator_feed')
          @page_title = @create_page_title title
          @$parent.loading = false
