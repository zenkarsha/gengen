UserAccount = (resolve, reject) ->
  Vue.http.get('/template/user-account.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin

        CreatorsModel
        GeneratorsModel
      ]

      data: ->
        {
          is_creator: false
          creator: null
          creator_doc_id: null
          creator_name: null
          language: ''
          form_changed: false
        }

      beforeCreate: ->
        @$parent.$parent.loading = true
        firebase.auth().onAuthStateChanged (user) ->
          if !user then redirect_home()

      mounted: ->
        @language = @$route.params.lang
        @$parent.$parent.loading = false

      methods:
        save_change: ->
          self = @
          data =
            name: @creator_name
          gogo.start()
          @model.creators.update_item @creator_doc_id, data, (results) ->
            noty self.$t('alert.setting_updated'), 'success'
            scroll_top()
            gogo.stop()
          , (error) ->
            gogo.stop()
            noty self.$t('alert.something_went_wrong'), 'error'

      watch:
        user: (value) ->
          self = @
          @model.creators.read_item value.uid, (result) ->
            if !result.empty
              self.is_creator = true
              self.creator = result.docs[0].data()
              self.creator_doc_id = result.docs[0].id
              self.creator_name = self.creator.name
              self.form_changed = false
          , (error) -> xx error

        creator_name: (new_value, old_value) ->
          if old_value isnt null
            @form_changed = true

        language: (value) ->
          route_redirect @$route.name, { lang: value }

        $route: (to, from) ->
          @language = to.params.lang
