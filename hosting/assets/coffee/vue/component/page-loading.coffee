Vue.component 'page-loading',
  template: """
    <div class="page-loading" v-show="loading">
      <spinner></spinner>
    </div>
  """

  data: ->
    {
      loading: true
    }

  props: ['loading']
