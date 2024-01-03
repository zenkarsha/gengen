UserPhotos = (resolve, reject) ->
  Vue.http.get('/template/user-photos.html').then (template) ->
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
          json = localStorage.getItem 'user_images'
          if json isnt null
            @list = JSON.parse json
            @list = sort_object @list, 'timestamp'

        load_image: (filename) ->
          return localStorage.getItem filename

        delete_image: (item) ->
          index = @list.indexOf item
          @list.splice(index, 1)
          localStorage.setItem 'user_images', JSON.stringify(@list)
          localStorage.removeItem item.image
