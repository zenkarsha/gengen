Vue.component 'section-newest-list',
  template: """
    <div class="section generator-list home-list">
      <span class="force-update">${force_update}</span>
      <div class="container no-padding">
        <h2>
          <i class="flaticon-lightning-electric-energy padding-right"></i>
          <router-link :to="{name: 'generator_list', params: {lang: $route.params.lang}}" v-text="$t('nav.newest_list')"></router-link>
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
          <div class="show-more-button">
            <router-link :to="{name: 'generator_list', params: {lang: $route.params.lang}}" class="button rounded">
              ${$t('button.view_list')}
              <i class="flaticon-right-arrow padding-left"></i>
            </router-link>
          </div>
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
    CreatorsModel
  ]

  data: ->
    {
      list: []
      list_empty: false
      per_page: 6
    }

  mounted: ->
    @init()

  methods:
    init: ->
      self = @
      @model.generators.read_list 'timestamp', 'desc', @per_page, (results) ->
        gogo.stop()
        if results.empty
          self.list_empty = true
        else
          results.forEach (doc) ->
            config = doc.data()
            config.gid = doc.id
            self.list.push config
            self.add_creator_name_item config.cid
      , (error) -> self.handle_list_error error
