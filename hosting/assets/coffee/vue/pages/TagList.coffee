TagList = (resolve, reject) ->
  Vue.http.get('/template/tag-list.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
        GeneratorListMixin
        CreatorNameMixin

        GeneratorsModel
        CreatorsModel
        TagsModel
      ]

      data: ->
        {
          tag: ''
          official: false
        }

      beforeCreate: ->
        @$parent.loading = true
        gogo.start()

      mounted: ->
        @tag = this.$route.params.tag
        @init()

      updated: -> shave()

      methods:
        init: ->
          @list = []
          @last_doc = null
          @no_more_data = false
          @empty_list = false

          self = @
          @$parent.loading = false
          @tag = this.$route.params.tag
          @model.tags.read_list @tag, 'timestamp', 'desc', @per_page, (results) ->
            self.handle_list_result results, true
          , (error) -> self.handle_list_error error

        show_more: ->
          self = @
          gogo.start()
          @model.tags.read_list_paginate @tag, 'timestamp', 'desc', @last_doc, @per_page, (results) ->
            self.handle_list_result results, true
          , (error) -> self.handle_list_error error

      watch:
        tag: (value) ->
          title = '#' + value
          @page_title = @create_page_title title

        '$route.params.tag': (value) ->
          @init()
