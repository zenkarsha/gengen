MostUsedList = (resolve, reject) ->
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
        GeneratorsCountModel
        CreatorsModel
      ]

      data: ->
        {
          official: false
        }

      beforeCreate: ->
        @$parent.$parent.loading = true
        gogo.start()

      mounted: -> @init()
      updated: -> shave()

      methods:
        init: ->
          self = @
          @$parent.$parent.loading = false
          @model.generators_count.read_list 'use_count', 'desc', 'last_use', 'desc', @per_page, (results) ->
            self.handle_list_result results, true
          , (error) -> self.handle_list_error error

        show_more: ->
          self = @
          gogo.start()
          @model.generators_count.read_list_paginate 'use_count', 'desc', 'last_use', 'desc', @last_doc, @per_page, (results) ->
            self.handle_list_result results, true
          , (error) -> self.handle_list_error error
