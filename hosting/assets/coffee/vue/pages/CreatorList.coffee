CreatorList = (resolve, reject) ->
  Vue.http.get('/template/creator-list.html').then (template) ->
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
          cid: ''
          creator:
            id: null
            name: 'Anonymous'
            avatar: null
          official: false
        }

      beforeCreate: ->
        @$parent.loading = true
        gogo.start()

      mounted: ->
        @cid = @$route.params.cid
        @load_creator @cid
        @load_creator_list @cid
        @$parent.loading = false

      updated: ->
        shave()
        @update_title()

      methods:
        load_creator: (cid) ->
          self = @
          @model.creators.read_item cid, (result) ->
            if !result.empty then self.creator = result.docs[0].data()
          , (error) -> xx error

        load_creator_list: (cid) ->
          self = @
          @model.generators.read_creator_list cid, 'timestamp', 'desc', @per_page, (results) ->
            self.handle_list_result results, false
          , (error) -> self.handle_list_error error

        show_more: ->
          self = @
          gogo.start()
          @model.generators.read_creator_list_paginate @cid, 'timestamp', 'desc', @last_doc, @per_page, (results) ->
            self.handle_list_result results, false
          , (error) -> self.handle_list_error error

        update_title: ->
          if @_i18n isnt null
            @page_title =  @create_page_title @creator.name + @$t('text.whos_generator')
