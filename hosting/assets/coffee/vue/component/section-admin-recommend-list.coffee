Vue.component 'section-admin-recommend-list',
  template: """
    <div class="section generator-list highlight">
      <span class="force-update">${force_update}</span>
      <div class="container no-padding">
        <h2 class="headline center" v-text="$t('title.admin_recommend')"></h2>
        <div v-if="!list_empty">
          <ul class="list" v-show="list.length > 0">
            <li class="list-item" v-for="item in list" :key="item.gid">
              <generator-list-item :config="item" :creator="creator_name_list[item.cid]" :shave="'false'" :enable_description="true"></generator-list-item>
            </li>
          </ul>
          <ul class="list placeholder" v-if="list.length == 0">
            <li class="list-item" v-for="i in per_page">
              <generator-list-placeholder></generator-list-placeholder>
            </li>
          </ul>
        </div>
        <div v-if="list_empty">
          <h4 v-text="$t('text.empty_list')"></h4>
        </div>
      </div>
    </div>
  """

  mixins: [
    GeneratorListMixin
    CreatorNameMixin

    AdminRecommendModel
    GeneratorsModel
    CreatorsModel
  ]

  data: ->
    {
      list: []
      list_empty: false
      per_page: 2
    }

  mounted: ->
    @init()

  methods:
    init: ->
      self = @
      @model.admin_recommend.read_list 'created_at', 'desc', @per_page, (results) ->
        if results.empty
          self.list_empty = true
        else
          results.forEach (doc) ->
            self.model.generators.read_item doc.data().gid, (result) ->
              if result.exists
                data = result.data()
                data.gid = doc.data().gid
                self.list.push data
                self.add_creator_name_item result.data().cid
            , (error) -> self.handle_list_error error
      , (error) -> self.handle_list_error error
