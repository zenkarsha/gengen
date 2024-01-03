Vue.component 'generator-list-item',
  template: """
    <div :class="['item-wrapper']">
      <router-link :to="{ name: !official ? 'gen' : 'official', params: { gid: config.gid  }}">
        <div class="item-label" v-if="official == false">
          <span class="hot" v-if="config.hot" v-text="$t('text.hot')"></span>
          <span class="fun" v-if="config.fun" v-text="$t('text.fun')"></span>
          <span class="new" v-if="config.timestamp > timestamp() - 604800" v-text="$t('text.new')"></span>
        </div>
        <div class="item-cover-wrapper">
          <div class="item-cover" :style="{ backgroundImage: 'url(' + config.cover + ')' }" :data-link-text="$t('text.play')"></div>
        </div>
        <span class="item-avatar" :style="{ backgroundImage: 'url(' + config.cover + ')' }"></span>
        <div class="item-info">
          <h4 :class="['item-title', shave == true ? 'shave-me' : '']" v-text="config.multiple_langs && config.multiple_langs_select[$route.params.lang] ? config.multiple_title[$route.params.lang] : config.title" :title="config.title"></h4>
          <div class="item-description" v-if="enable_description" v-text="config.multiple_langs && config.multiple_langs_select[$route.params.lang] ? config.multiple_description[$route.params.lang] : config.description"></div>
          <span class="item-template" v-bind:class="config.template" v-text="$t('template.' + config.template)" v-if="official == false"></span>
          <span class="item-creator" v-text="creator" v-if="official == false"></span>
        </div>
      </router-link>
    </div>
  """

  mixins: [
    UseragentMixin
  ]

  props:
    config: Object
    creator: type: String
    official: type: Boolean, default: false
    shave: type: Boolean, default: true
    enable_description: type: Boolean, default: false

  mounted: ->
    if @shave is true then shave()
