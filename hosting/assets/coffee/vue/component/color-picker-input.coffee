Vue.component 'color-picker-input',
  template: """
    <div class="color-picker-input" v-click-outside="close_popup">
      <button type="button" class="button icon outlined" :style="{ backgroundColor: color, color: text_color }" v-on:click="toggle_popup">
        ${color}
      </button>
      <color-picker :class="['color-picker', float_right ? 'float-right' : 'float-left']" :value="color" @input="value => update(value)" v-if="show_popup"></color-picker>
    </div>
  """

  components:
    {
      'color-picker': VueColor.Swatches
    }

  data: ->
    {
      show_popup: false
      text_color: '#fff'
    }

  props:
    color: type: String, default: '#000'
    float_right: type: Boolean, default: false

  mounted: ->
    @text_color = get_text_color(@color)

  methods:
    toggle_popup: ->
      @show_popup = if @show_popup then false else true

    close_popup: ->
      @show_popup = false

    update: (value) ->
      @text_color = get_text_color(value.hex)
      @color = value.hex
      @$emit 'update', value.hex
