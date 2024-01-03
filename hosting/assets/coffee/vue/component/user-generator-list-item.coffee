Vue.component 'user-generator-list-item',
  template: """
    <div class="item-wrapper">
      <div class="item-cover-wrapper">
        <div class="item-cover" :style="{ backgroundImage: 'url(' + config.cover + ')' }" :data-link-text="$t('button.edit_generator')" v-on:click="edit_generator"></div>
      </div>
      <div class="item-info">
        <router-link :to="{ name: 'gen', params: { gid: config.gid  }}">
          <h4 class="item-title shave-me" v-text="config.title" :title="config.title"></h4>
        </router-link>
        <span class="item-template" v-bind:class="config.template" v-text="$t('template.' + config.template)"></span>
      </div>
    </div>
  """

  props: ['config']

  updated: -> shave()

  methods:
    edit_generator: ->
      @$emit 'edit', @config
