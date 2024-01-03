UserLinks = (resolve, reject) ->
  Vue.http.get('/template/user-links.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
      ]
      data: ->
        {
          list: []
        }

      beforeCreate: ->
        @$parent.$parent.loading = true
        firebase.auth().onAuthStateChanged (user) ->
          if !user then redirect_home()

      mounted: ->
        @load_list()
        @$parent.$parent.loading = false

      methods:
        load_list: ->
          json = localStorage.getItem 'user_links'
          if json isnt null
            @list = JSON.parse json
            @list = sort_object @list, 'timestamp'

        share_link: (item) ->
          #=require ../swal/user-links-share_link_popup.coffee

        delete_link: (item) ->
          self = @
          gogo.start()
          $.ajax
            url: 'https://api.imgur.com/3/image/' + item.deletehash
            type: 'delete'
            headers: Authorization: 'Client-ID 36f2c6c4618678a'
            dataType: 'json'
            success: (result) ->
              index = self.list.indexOf item
              self.list.splice(index, 1)
              localStorage.setItem 'user_links', JSON.stringify(self.list)
              noty self.$t('alert.delete_success'), 'success'
              gogo.stop()
            error: (error) ->
              noty self.$t('alert.delete_failed'), 'error'
