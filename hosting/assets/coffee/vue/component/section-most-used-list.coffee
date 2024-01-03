Vue.component 'section-most-used-list',
  template: """
    <div class="section generator-list home-list">
      <span class="force-update">${force_update}</span>
      <div class="container no-padding">
        <h2>
          <i class="flaticon-hand padding-right"></i>
          <router-link :to="{name: 'most_used_list', params: {lang: $route.params.lang}}" v-text="$t('nav.most_used_list')"></router-link>
        </h2>
        <div v-if="!list_empty">
          <ul class="list" v-show="list.length > 0">
            <li class="list-item" v-for="item in list" :key="item.gid">
              <generator-list-item :config="item" :creator="creator_name_list[item.cid]"></generator-list-item>
            </li>
            <li class="list-end-spacer"></li>
          </ul>
          <ul class="list placeholder" v-if="list.length == 0">
            <li class="list-item" v-for="i in per_page">
              <generator-list-placeholder></generator-list-placeholder>
            </li>
            <li class="list-end-spacer"></li>
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

    GeneratorsModel
    GeneratorsCountModel
    CreatorsModel
  ]

  data: ->
    {
      list: []
      list_empty: false
      per_page: 3
    }

  mounted: ->
    @init()

  methods:
    init: ->
      self = @
      @model.generators_count.read_list 'use_count', 'desc', 'last_use', 'desc', @per_page, (results) ->
        if results.empty
          self.list_empty = true
        else
          results.forEach (doc) ->
            self.model.generators.read_item doc.data().gid, (result) ->
              if result.exists
                data = result.data()
                data.gid = doc.data().gid
                data.use_count = doc.data().use_count
                data.fun = true
                self.list.push data
                self.add_creator_name_item result.data().cid
                if self.list.length > 1 then sort_object self.list, 'use_count'
            , (error) -> self.handle_list_error error
      , (error) -> self.handle_list_error error
