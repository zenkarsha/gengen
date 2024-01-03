Vue.component 'draggable-zone',
  template: """
    <div :style="{ width: w, height: h, left: x, top: y }"></div>
  """
  data: ->
    {
      w: '100%'
      h: '100%'
      x: 0
      y: 0
    }
  props: ['container_w', 'container_h', 'object_w', 'object_h', 'type']

  methods:
    init: ->
      if @type is 'avatar' or @type is 'cover'
        @w = px(@container_w + (@object_w - @container_w) * 2)
        @h = px(@container_h + (@object_h - @container_h) * 2)
        @x = px(@container_w - @object_w)
        @y = px(@container_h - @object_h)
      else if @type is 'sticker'
        @w = px(@container_w + @object_w)
        @h = px(@container_h + @object_h)
        @x = px(@object_w * -.5)
        @y = px(@object_h * -.5)

  watch:
    container_w: (value) -> @init()
    container_h: (value) -> @init()
    object_w: (value) -> @init()
    object_h: (value) -> @init()
