Vue.component 'Generator404', (resolve, reject) ->
  Vue.http.get('/template/generators/404.html').then (template) ->
    resolve
      template: template.body
      props: ['props']
      data: ->
        {
          config: @props
        }
