Vue.component 'cropper',
  template: """
    <div class="cropper-container">
      <button type="button" :class="class_name" v-on:click="show_popup" v-if="disable_button == false"><i class="flaticon-crop"></i>${button_text}</button>
      <div class="popup-container mobile-fullscreen" v-show="popup_on">
        <div class="popup-wrapper">
          <div class="popup-content">
            <div class="cropper" ref="cropper_ref"></div>
            <div class="cropper-tools">
              <div class="cropper-ratio" v-if="ratio_changer">
                <select class="ratio-changer" v-model="default_ratio">
                  <option>1 : 1</option>
                  <option>4 : 3</option>
                  <option>3 : 4</option>
                  <option>5 : 4</option>
                  <option>4 : 5</option>
                  <option>2 : 3</option>
                  <option>3 : 2</option>
                  <option>16 : 9</option>
                  <option>16 : 10</option>
                </select>
              </div>
              <div class="cropper-rotate" v-if="enable_rotate">
                <button type="button" class="button icon white rounded" v-on:click="rotate('90')">
                  <i class="flaticon-rotate-1"></i>
                </button>
                <button type="button" class="button icon white rounded" v-on:click="rotate('-90')">
                  <i class="flaticon-rotate"></i>
                </button>
              </div>
            </div>
          </div>
          <div class="popup-footer gray">
            <button type="button" class="button gray" v-on:click="close_popup()" v-text="$t('button.cancel')" v-if="disable_cancel == false"></button>
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
      cropper: ''
      popup_on: false
      output_min: 600
    }

  props:
    image: String
    viewport_w: type: Number, default: 320
    viewport_h: type: Number, default: 320
    boundary_w: type: Number, default: 400
    boundary_h: type: Number, default: 400
    output_w: type: Number, default: 600
    output_h: type: Number, default: 600
    format: type: String, default: 'png'
    enable_resize: type: Boolean, default: false
    show_zoomer: type: Boolean, default: true
    enable_rotate: type: Boolean, default: false
    ratio_changer: type: Boolean, default: false
    default_ratio: type: Boolean, default: '1 : 1'
    class_name: type: String, default: 'button gray icon rounded'
    button_text: type: String, default: ''
    disable_cancel: type: Boolean, default: false
    disable_button: type: Boolean, default: false

  mounted: ->
    $('body').delegate '.ratio-changer', 'change', ((event) ->
      ratio = $(event.currentTarget).val()
      @update_ratio ratio
    ).bind @

    @output_min = if @output_h > @output_w then @output_w else @output_h
    if $is.mobile() and @viewport_w is @viewport_h
      @viewport_w = 220
      @viewport_h = 220
      @boundary_w = 240
      @boundary_h = 240

  methods:
    show_popup: ->
      @popup_on = true
      if @ratio_changer
        @update_ratio @default_ratio
      else
        setTimeout(( ->
          @cropper = $(@$refs.cropper_ref).croppie
            url: @image
            viewport:
              width: @viewport_w
              height: @viewport_h
            boundary:
              width: @boundary_w
              height: @boundary_h
            enableResize: @enable_resize
            showZoomer: @show_zoomer
            enableOrientation: false
        ).bind(@), 500)

    handle_output: ->
      if @enable_resize
        config =
          type: 'base64'
          format: @format
      else
        config =
          type: 'base64'
          format: @format
          size:
            width: @output_w
            height: @output_h
      @cropper.croppie('result', config).then ((output) ->
        @$emit 'update', output
        @close_popup()
      ).bind @

    close_popup: ->
      if @popup_on is true
        @popup_on = false
        @cropper.croppie('destroy')

    update_ratio: (ratio) ->
      switch ratio
        when '1 : 1'
          @viewport_w = 320
          @viewport_h = 320
        when '4 : 3'
          @viewport_w = 320
          @viewport_h = 240
        when '3 : 4'
          @viewport_w = 240
          @viewport_h = 320
        when '5 : 4'
          @viewport_w = 400
          @viewport_h = 320
        when '4 : 5'
          @viewport_w = 320
          @viewport_h = 400
        when '3 : 2'
          @viewport_w = 360
          @viewport_h = 240
        when '2 : 3'
          @viewport_w = 240
          @viewport_h = 360
        when '16 : 9'
          @viewport_w = 320
          @viewport_h = 180
        when '16 : 10'
          @viewport_w = 320
          @viewport_h = 200

      if @viewport_w > @viewport_h
        @output_h = @output_min
        @output_w = @output_h * (@viewport_w / @viewport_h)
      else
        @output_w = @output_min
        @output_h = @output_w * (@viewport_h / @viewport_w)

      if @cropper != '' then @cropper.croppie('destroy')
      @cropper = $(@$refs.cropper_ref).croppie
        url: @image
        viewport:
          width: @viewport_w
          height: @viewport_h
        boundary:
          width: @boundary_w
          height: @boundary_h
        enableResize: @enable_resize
        showZoomer: @show_zoomer
        enableOrientation: true

    rotate: (degrees) ->
      @cropper.croppie 'rotate', degrees
