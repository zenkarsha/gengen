Vue.component 'sticker-position-popup',
  template: """
    <div class="sticker-position-popup-container">
      <div class="popup-container mobile-fullscreen">
        <div class="popup-wrapper">
          <div class="popup-header">
            <h2 v-text="$t('label.set_sticker_position')"></h2>
          </div>
          <div class="popup-content">
            <div class="sticker-position-container">
              <div class="draggable-wrapper">
                <div class="draggable-container" :style="{ width: px(preview_w) , height: px(preview_h) }">
                  <draggable-element class="draggable-wrapper resizable" :w="sticker_w" :h="sticker_h" :x="sticker_x" :y="sticker_y" :containment="'.draggable-zone'" @dragged="handle_dragged" :style="{ width: px(sticker_w) , height: px(sticker_h), top: px(sticker_y), left: px(sticker_x) }">
                    <img id="sticker_image" :src="config.sticker_images[0]" />
                    <div class="ui-resizable-handle ui-resizable-nw"></div>
                    <div class="ui-resizable-handle ui-resizable-sw"></div>
                    <div class="ui-resizable-handle ui-resizable-se"></div>
                  </draggable-element>
                </div>
                <div id="basemap_container" ref="basemap_container">
                  <draggable-zone class="draggable-zone" :container_w="preview_w" :container_h="preview_h" :object_w="sticker_w" :object_h="sticker_h" :type="'sticker'"></draggable-zone>
                  <img id="example_image" ref="example_image" :src="config.example_image" />
                </div>
              </div>
            </div>
          </div>
          <div class="popup-footer gray">
            <button type="button" class="button gray" v-on:click="close_popup()" v-text="$t('button.cancel')"></button>
            <button type="button" class="button" v-on:click="handle_output()">
              ${$t('button.done')}
              <i class="flaticon-tick padding-left"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  """

  data: ->
    {
      popup_on: false

      canvas_w: 0
      canvas_h: 0
      scale: 1

      sticker_x: 0
      sticker_y: 0
      sticker_w: 0
      sticker_h: 0
      sticker_rotate: 0

      preview_w: 0
      preview_h: 0
    }

  props:
    config: type: Array, default: []

  mounted: ->
    @show_popup()

  methods:
    init: ->
      $('.resizable').resizable
        minWidth: 20
        minHeight: 20
        handles:
          'nw': '.ui-resizable-nw'
          'sw': '.ui-resizable-sw'
          'se': '.ui-resizable-se'
        stop: ((event, ui) ->
          @sticker_w = $('.resizable').width()
          @sticker_h = $('.resizable').height()
          @sticker_x = ui.position.left
          @sticker_y = ui.position.top
        ).bind @

      if @config.default_sticker_rotate then @sticker_rotate = @config.default_sticker_rotate
      $('.resizable').rotatable
        angle: @sticker_rotate
        wheelRotate: false
        stop: ((event, ui) ->
          @sticker_rotate = ui.angle.current
        ).bind @

      $('.resizable').addClass 'on'
      $('.draggable-container').on 'click', ->
        if $('.resizable').hasClass 'on'
          $('.resizable').removeClass 'on'
        else
          $('.resizable').addClass 'on'

      if @is_desktop
        $('.preview-area').mouseenter(->
          $('.resizable').addClass 'on'
        ).mouseleave ( ->
          if @mouse_down is 0 then $('.resizable').removeClass 'on'
        ).bind @

      image = new Image
      image.onload = ( ->
        @canvas_w = image.width
        @canvas_h = image.height
        @preview_w = @$refs.basemap_container.offsetWidth
        @preview_h = @$refs.basemap_container.offsetHeight
        @scale = @canvas_w / @preview_w
        @reload_sticker()

        gogo.stop()
      ).bind @
      image.src = @config.example_image

    reload_sticker: ->
      image = new Image
      image.onload = ( ->
        if @config.gid
          @sticker_h = @config.default_sticker_h / @scale
          @sticker_w = @config.default_sticker_w / @scale
          @sticker_x = @config.default_sticker_x / @scale
          @sticker_y = @config.default_sticker_y / @scale
        else
          @init_sticker image.width, image.height
      ).bind @
      image.src = @config.sticker_images[0]

    init_sticker: (width, height)->
      @sticker_w = width
      @sticker_h = height

      if width > height and @sticker_w > @preview_w * .8
        ratio = @preview_w * .8 / @sticker_w
        @sticker_w = @preview_w * .8
        @sticker_h = @sticker_h * ratio
      else if @sticker_h > @preview_h * .8
        ratio = @preview_h * .8 / @sticker_h
        @sticker_h = @preview_h * .8
        @sticker_w = @sticker_w * ratio

      @sticker_x = (@preview_w - @sticker_w) * .5
      @sticker_y = (@preview_h - @sticker_h) * .5

    show_popup: ->
      @init()
      @popup_on = true
      lock_html()

    close_popup: ->
      if @popup_on is true
        @popup_on = false
        @$emit 'cancel'
        unlock_html()

    handle_dragged: (config) ->
      @sticker_w = config.w
      @sticker_h = config.h
      @sticker_x = config.x
      @sticker_y = config.y

    handle_output: ->
      data =
        sticker_x: @sticker_x * @scale
        sticker_y: @sticker_y * @scale
        sticker_w: @sticker_w * @scale
        sticker_h: @sticker_h * @scale
        sticker_rotate: @sticker_rotate

      @$emit 'update', data
      @close_popup()
