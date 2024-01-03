Vue.component 'more-action-dropdwon',
  template: """
    <span :class="['more-action-dropdwon', show_dropdown ? 'on' : '']" v-click-outside="close_dropdown">
      <i class="flaticon-more-button-of-three-dots" v-on:click="toggle_dropdown"></i>
      <div class="dropdown" v-if="show_dropdown">
        <slot></slot>
      </div>
    </span>
  """

  data: ->
    {
      show_dropdown: false
    }

  methods:
    toggle_dropdown: ->
      @show_dropdown = if @show_dropdown then false else true

    close_dropdown: ->
      @show_dropdown = false
