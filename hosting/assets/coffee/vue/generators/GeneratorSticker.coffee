Vue.component 'GeneratorSticker',(resolve, reject) ->
  Vue.http.get('/template/generators/sticker.html').then (template) ->
    resolve
      template: template.body
      props: ['config']
      mixins: [
        UserMixin
        UseragentMixin
        GeneratorMixin
        GeneratorActionsMixin
        FileuploadPreviewMixin
        CaptchaMixin

        GeneratorsModel
        GeneratorsCountModel
        FeedModel
      ]

      data: ->
        {
          config: @config

          canvas_w: 0
          canvas_h: 0
          scale: 1

          sticker_image: ''
          sticker_image_select: ''
          sticker_w: 0
          sticker_h: 0
          sticker_x: 0
          sticker_y: 0
          sticker_rotate: 0

          basemap_image: ''
          preview_w: 0
          preview_h: 0

          container_w: 0
          container_h: 0

          label_w: 0
          label_h: 0

          history: []
          current_history: 0

          initialed: false
          loading_sticker: false
        }

      beforeMount: ->
        gogo.start()
        @basemap_image = @config.example_image
        @sticker_image_select = @config.sticker_images[0]
        @base64ify 'basemap_image'

      mounted: ->
        new ResizeSensor($('#app'), @window_resize)

        @label_w = $('#sticker_list_container label')[0].offsetWidth
        @label_h = $('#sticker_list_container label')[0].offsetHeight
        @init false
        @$parent.$parent.loading = false

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

        $('.resizable').rotatable
          angle: @config.default_sticker_rotate
          wheelRotate: false
          stop: ((event, ui) ->
            @sticker_rotate = ui.angle.current
          ).bind @

        $('.resizable').addClass 'on'
        $('.preview-area').on 'click', ->
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

      methods:
        window_resize: ->
          @initialed = false
          @container_w = 0
          @container_h = 0
          @init true

        init: (init_sticker) ->
          image = new Image
          image.onload = ( ->
            gogo.stop()
            if $('#basemap_image').length > 0
              if @container_w is 0 and @container_h is 0
                @container_w = @$refs.generator_container.offsetWidth
                @container_h = @$refs.generator_container.offsetHeight
              @canvas_w = image.width
              @canvas_h = image.height
              new_preview_w = @$refs.basemap_image_preview.offsetWidth
              new_preview_h = @$refs.basemap_image_preview.offsetHeight

              if new_preview_w isnt @preview_w or new_preview_h isnt @preview_h
                @preview_w = new_preview_w
                @preview_h = new_preview_h
                @scale = @canvas_w / @preview_w
                if init_sticker
                  image = new Image
                  image.onload = ( ->
                    @init_sticker image.width, image.height
                  ).bind @
                  image.src = q_auto @sticker_image
                else
                  @reload_sticker()
          ).bind @
          image.src = q_auto @basemap_image

        init_sticker: (width, height)->
          @sticker_w = width
          @sticker_h = height
          if @preview_w > @preview_h
            ratio = @preview_h * .5 / @sticker_h
            @sticker_h = @preview_h * .5
            @sticker_w = @sticker_w * ratio
          else
            ratio = @preview_w * .5 / @sticker_w
            @sticker_w = @preview_w * .5
            @sticker_h = @sticker_h * ratio
          @sticker_x = (@preview_w - @sticker_w) * .5
          @sticker_y = (@preview_h - @sticker_h) * .5

        reload_sticker: ->
          @loading_sticker = true
          image = new Image
          image.onload = ( ->
            @loading_sticker = false
            if @initialed is false
              if @config.default_sticker_x and @config.default_sticker_y and @config.default_sticker_w and @config.default_sticker_h
                @sticker_x = @config.default_sticker_x / @scale
                @sticker_y = @config.default_sticker_y / @scale
                @sticker_w = @config.default_sticker_w / @scale
                @sticker_h = @config.default_sticker_h / @scale
                @initialed = true
              else
                @init_sticker image.width, image.height
                @initialed = true
            else
              current_center_x = @sticker_x + @sticker_w * .5
              current_center_y = @sticker_y + @sticker_h * .5
              container_length = if @sticker_w > @sticker_h then @sticker_w else @sticker_h
              if image.width > image.height
                @sticker_w = container_length
                @sticker_h = image.height * @sticker_w / image.width
              else
                @sticker_h = container_length
                @sticker_w = image.width * @sticker_h / image.height
              @sticker_x = current_center_x - @sticker_w * .5
              @sticker_y = current_center_y - @sticker_h * .5
          ).bind @
          image.src = q_auto @sticker_image

        handle_dragged: (config) ->
          @sticker_w = config.w
          @sticker_h = config.h
          @sticker_x = config.x
          @sticker_y = config.y

        handle_basemap_change: (event) ->
          @local_preview event, 'basemap_image', false

        merge_image: ->
          self = @
          if $('#output_container').length
            html2canvas(document.querySelector('#output_container'), { scale: 1, logging: false }).then (canvas) ->
              output = canvas.toDataURL 'image/png'
              if self.history.length is 0 then self.history.push self.basemap_image
              if self.current_history isnt self.history.length - 1 then self.history.length = self.current_history + 1
              self.basemap_image = output
              self.history.push output
              self.current_history += 1
              self.sticker_x += 10
              self.sticker_y += 10
              noty self.$t('alert.merge_success'), 'success'

        handle_history: (__go) ->
          if __go is '+' then @current_history += 1 else @current_history -= 1
          @basemap_image = @history[@current_history]

        generator: (action) ->
          @output_action = action
          if __client isnt null and  __client.isRunning() then @prepare_generator() else @open_captcha @prepare_generator

        prepare_generator: ->
          gogo.start()
          @show_social_share_popup()
          if is_url @sticker_image or is_url @basemap_image
            @convert_images ['sticker_image', 'basemap_image'], @execute_generator
          else
            @execute_generator()

        execute_generator: ->
          setTimeout(( ->
            self = @
            html2canvas(document.querySelector('#output_container'), { scale: 1, logging: false }).then (canvas) ->
              output = canvas.toDataURL 'image/png'
              self.handle_output_action output
          ).bind(@), 1000)

      watch:
        basemap_image: (after, before) ->
          if is_data before then @init true

        sticker_image: (value) ->
          if is_url value then @base64ify 'sticker_image'

        sticker_image_select: (after, before) ->
          @sticker_image = after
          if is_url before
            @initialed = true
            @reload_sticker()
