Vue.component 'section-tag',
  template: """
    <div class="section gray center">
      <div class="container small">
        <h2 v-if="list.length > 0">TAG</h2>
        <div class="tags large" v-if="list.length > 0">
          <router-link v-for="item in list" :to="{name: 'tag', params: { lang: $route.params.lang, tag: url_escape(item.tag) } }" v-text="url_escape(item.tag)"></router-link>
        </div>
      </div>
    </div>
  """

  mixins: [
    TagsCountModel
  ]

  data: ->
    {
      list: []
    }

  mounted: ->
    @init()

  methods:
    init: ->
      self = @
      @model.tags_count.read_list 'count', 'desc', 20, (results) ->
        if !results.empty
          results.forEach (doc) -> self.list.push doc.data()
      , (error) -> xx error
