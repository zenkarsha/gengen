GeneratorList = (resolve, reject) ->
  Vue.http.get('/template/generator-list.html').then (template) ->
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
      ]

      data: ->
        {
          official: false
        }

      beforeCreate: ->
        @$parent.$parent.loading = true
        gogo.start()

      mounted: -> @load_list()

      updated: -> shave()

      methods:
        load_list: ->
          self = @
          @model.generators.read_list 'timestamp', 'desc', @per_page, (results) ->
            self.handle_list_result results, false
            self.$parent.$parent.loading = false
          , (error) -> self.handle_list_error error

        show_more: ->
          self = @
          gogo.start()
          @model.generators.read_list_paginate 'timestamp', 'desc', @last_doc, @per_page, (results) ->
            self.handle_list_result results, false
          , (error) -> self.handle_list_error error
