Vue.component 'draggable-element',
  template: '<div><slot></slot></div>'
  data: ->
    {
      w: 0
      h: 0
      x: 0
      y: 0
      containment: ''
      scroll_position: 0
    }
  props: ['w', 'h', 'x', 'y', 'containment']

  mounted: ->
    @init()

  methods:
    init: ->
      $(@$el).draggable
        containment: $(@containment)
        drag: ((event, ui) ->
          @w = $(@$el).width()
          @h = $(@$el).height()
          @x = px2float $(@$el).css('left')
          @y = px2float $(@$el).css('top')
          @handle_dragged()
        ).bind @

    handle_dragged: ->
      config =
        w: @w
        h: @h
        x: @x
        y: @y
      @$emit 'dragged', config
