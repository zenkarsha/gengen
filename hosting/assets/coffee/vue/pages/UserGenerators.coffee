UserGenerators = (resolve, reject) ->
  Vue.http.get('/template/user-generators.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
        EditGeneratorMixin
        FileuploadPreviewMixin
        GeneratorListMixin
        FileuploadMixin
        CreateFormCheckMixin
        CreatorNameMixin
        TagMixin

        GeneratorsModel
        CreatorsModel
        TagsModel
        TagsCountModel
      ]

      beforeCreate: ->
        @$parent.$parent.loading = true
        firebase.auth().onAuthStateChanged (user) ->
          if !user then redirect_home()

      updated: -> shave()

      methods:
        load_list: ->
          self = @
          @model.generators.read_user_list @user.uid ,'timestamp', 'desc', @per_page, (results) ->
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

        load_item: ->
          self = @
          @model.generators.read_item @$route.params._gid, (result) ->
            if result.exists and result.data().cid is self.user.uid
              self.edit_mode = true
              self.form_config = result.data()
              self.form_config.gid = result.id
              self.$parent.$parent.loading = false
              gogo.stop()
            else
              route_redirect 'user_generators', { lang: i18n.locale }
          , (error) ->
            xx error
            route_redirect 'user_generators', { lang: i18n.locale }

        show_more: ->
          self = @
          gogo.start()
          @model.generators.read_user_list_paginate @user.uid, 'timestamp', 'desc', @last_doc, @per_page, (results) ->
            self.handle_list_result results, false
          , (error) -> self.handle_list_error error

        edit_generator: (item) ->
          @edit_mode = true
          @form_config = item
          @original_config = JSON.parse JSON.stringify item
          zenscroll.to @$refs.main_content, 100
          route_redirect 'edit_generator', { _gid: item.gid }
          @$forceUpdate()

      watch:
        user: (value) ->
          gogo.start()
          if @$route.params._gid isnt undefined
            @load_item()
          else
            @load_list()

        $route: (to, from) ->
          if to.params._gid is undefined and @edit_mode is true
            @edit_mode = false
            if @list.length is 0
              @load_list()
