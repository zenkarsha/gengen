Vue.component 'GeneratorAvatar', (resolve, reject) ->
  Vue.http.get('/template/generators/avatar.html').then (template) ->
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

          frame_image: ''
          frame_image_select: ''
          basemap_image: ''
          basemap_default_w: 0
          basemap_default_h: 0
          basemap_w: 0
          basemap_h: 0
          basemap_x: 0
          basemap_y: 0

          preview_w: 0
          preview_h: 0

          container_w: 0
          container_h: 0

          label_w: 0
          label_h: 0
          label_ratio: 0

          loading_preview: false
          dont_move: false
        }

      beforeMount: ->
        @basemap_image = q_auto(@config.example_image)
        @frame_image_select = q_gen_avatar(@config.frame_images[0])
        @base64ify 'basemap_image'

      mounted: ->
        new ResizeSensor($('#app'), @window_resize)
        @init()
        @$parent.$parent.loading = false

      methods:
        init: ->
          @loading_preview = true
          image = new Image
          image.onload = ( ->
            if $('#generator_container').length > 0
              if @container_w is 0 and @container_h is 0
                @container_w = @$refs.generator_container.offsetWidth
                @container_h = @$refs.generator_container.offsetHeight
              @reload_preview image.width, image.height
          ).bind @
          image.src = q_auto @basemap_image

        window_resize: ->
          window_width = window.innerWidth
          setTimeout(( ->
            if window_width is window.innerWidth
              @container_w = 0
              @container_h = 0
              @init()
          ).bind(@), 1, window_width)

        reload_preview: (basemap_w, basemap_h) ->
          image = new Image
          image.onload = ( ->
            if $('#frame_image').length > 0
              @canvas_w = image.width
              @canvas_h = image.height
              @preview_w = @$refs.frame_image.offsetWidth
              @preview_h = @$refs.frame_image.offsetHeight
              @label_w = $('#frame_list_container label')[0].offsetWidth
              @label_h = $('#frame_list_container label')[0].offsetHeight
              @label_ratio = (@label_w - 8) / @preview_w

              if basemap_w > basemap_h
                @basemap_default_h = @basemap_h = @preview_h
                @basemap_default_w = @basemap_w = basemap_w * @preview_h / basemap_h
              else
                @basemap_default_h = @basemap_h = basemap_h * @preview_w / basemap_w
                @basemap_default_w = @basemap_w = @preview_w

              @basemap_x = ( @preview_w - @basemap_w ) * .5
              @basemap_y = ( @preview_h - @basemap_h ) * .5

              @$refs.zoom_slider.reset_value()
              @loading_preview = false
          ).bind @
          image.src = q_auto @frame_image

        handle_dragged: (config) ->
          @basemap_w = config.w
          @basemap_h = config.h
          @basemap_x = config.x
          @basemap_y = config.y

        handle_zoom: (value) ->
          ratio = value * .01
          current_center_x = @basemap_x + @basemap_w * .5
          current_center_y = @basemap_y + @basemap_h * .5
          @basemap_w = @basemap_default_w * ratio
          @basemap_h = @basemap_default_h * ratio
          new_x = current_center_x - .5 * @basemap_w
          new_y = current_center_y - .5 * @basemap_h

          if new_x + @basemap_w < @preview_w
            new_x = @preview_w - @basemap_w
          else if new_x + @basemap_w > @basemap_w
            new_x = 0
          if new_y + @basemap_h < @preview_h
            new_y = @preview_h - @basemap_h
          else if new_y + @basemap_h > @basemap_h
            new_y = 0

          @basemap_x = new_x
          @basemap_y = new_y

        handle_basemap_change: (event) ->
          @loading_preview = true
          @local_preview event, 'basemap_image', false

        load_user_avatar: ->
          if @user.providerData[0].providerId is 'facebook.com'
            @basemap_image = @user.photoURL + '?width=9999'
          else if @user.providerData[0].providerId is 'twitter.com'
            @basemap_image = @user.photoURL.replace '_normal', ''
          else
            @basemap_image = @user.photoURL
          @base64ify_local 'basemap_image'

        basemap_config: ->
          scale = @canvas_w / @preview_w
          config =
            type: 'image'
            url: @basemap_image
            x: @basemap_x * scale
            y: @basemap_y * scale
            w: @basemap_w * scale
            h: @basemap_h * scale

        frame_config: ->
          config =
            type: 'image'
            url: @frame_image
            x: 0
            y: 0
            w: @canvas_w
            h: @canvas_h

        generator: (action) ->
          @output_action = action
          if __client isnt null and __client.isRunning() then @prepare_generator() else @open_captcha @prepare_generator

        prepare_generator: ->
          gogo.start()
          @show_social_share_popup()
          @convert_images ['frame_image', 'basemap_image'], @execute_generator

        execute_generator: ->
          object_configs = [ @basemap_config(), @frame_config() ]
          setTimeout(( ->
            output = @create_image @canvas_w, @canvas_h, object_configs
            @handle_output_action output
          ).bind(@), 1000)

      watch:
        basemap_image: (value) ->
          if @dont_move is false then @init()

        frame_image: (value) ->
          @loading_preview = true
          image = new Image
          image.onload = ( ->
            @loading_preview = false
          ).bind @
          image.src = q_auto value

        frame_image_select: (value) ->
          @frame_image = value
