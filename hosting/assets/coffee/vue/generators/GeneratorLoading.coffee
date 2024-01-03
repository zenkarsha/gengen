Vue.component 'GeneratorLoading',(resolve, reject) ->
  Vue.http.get('/template/generators/loading.html').then (template) ->
    resolve
      template: template.body
