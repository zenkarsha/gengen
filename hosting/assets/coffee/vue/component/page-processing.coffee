Vue.component 'page-processing',
  template: """
    <div class="page-processing" v-show="processing"></div>
  """

  data: ->
    {
      processing: true
    }

  props: ['processing']
