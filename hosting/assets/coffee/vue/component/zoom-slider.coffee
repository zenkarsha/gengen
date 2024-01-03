Vue.component 'zoom-slider',
  template: """
    <div class="zoom-slider-wrapper">
      <div class="zoom-slider" ref="zoom_slider"></div>
      <span class="zoom-out" v-on:click="zoom_out">−</span>
      <span class="zoom-in" v-on:click="zoom_in">＋</span>
    </div>
  """
  data: ->
    {
      element: undefined
      value: 0
    }

  props:
    min:
      type: Number
      default: 0
    max:
      type: Number
      default: 10
    step:
      type: Number
      default: 1
    default:
      type: Number
      default: 0
    live_change:
      type: Boolean
      default: false
    enable_scroll:
      type: Boolean
      default: false
    scroll_area:
      type: String
      default: null

  created: ->
    @value = @default

  mounted: ->
    self = @
    @init()
    if @scroll_area isnt null and @enable_scroll
      $(@$parent.$refs[@scroll_area]).on 'mousewheel', (event) ->
        self.handle_mousewheel_event event

      $(@$parent.$refs[@scroll_area]).hammer(recognizers: [
        [ Hammer.Pinch, { enable: true } ]
      ]).on 'pinchin pinchout', (event) ->
        if event.gesture.additionalEvent is 'pinchin'
          @zoom_out()
        else if event.gesture.additionalEvent is 'pinchout'
          @zoom_in()

  methods:
    init: ->
      self = @
      @element = $(@$el.querySelector('.zoom-slider'))
      @element.slider
        min: @min
        max: @max
        value: @value
        slide: (event, ui) -> if self.live_change then self.handle_zoom ui.value
        change: (event, ui) -> self.handle_zoom ui.value
      if @enable_scroll
        @element.on 'mousewheel', (event) -> self.handle_mousewheel_event event

    handle_mousewheel_event: (event) ->
      event.preventDefault()
      if event.originalEvent.deltaY < 0
        @zoom_in()
      else if event.originalEvent.deltaY > 0
        @zoom_out()

    handle_zoom: (value) ->
      @value = value
      @$emit 'changed', @value

    zoom_in: ->
      @value += @step
      @value > @max && @value = @max
      @set_value()

    zoom_out: ->
      @value -= @step
      @value < @min && @value = @min
      @set_value()

    update_value: (value) ->
      @value = value
      @element.slider 'value', @value

    set_value: ->
      @element.slider 'value', @value
      @$emit 'changed', @value

    reset_value: ->
      @element.slider 'value', @default
      @$emit 'changed', @value
