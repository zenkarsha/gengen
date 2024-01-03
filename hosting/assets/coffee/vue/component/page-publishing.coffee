Vue.component 'page-publishing',
  template: """
    <div class="page-publishing" v-show="publishing"></div>
  """

  data: ->
    {
      publishing: true
    }

  props: ['publishing']
