Vue.component 'KangxiAmnesty', (resolve, reject) ->
  Vue.http.get('/template/generators/official/kangxi-amnesty.html').then (template) ->
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
        InputBindMixin

        FeedModel
      ]

      data: ->
        {
          config: @config

          canvas_w: 0
          canvas_h: 0

          preview_image: '/images/avatar-placeholder.jpg'
          text: '御賜金牌'
          default_text: '御賜金牌'
          text_input: '御賜金牌'
          basemap_image: ''

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        @basemap_image = q_auto(@config.basemap_image)
        if @is_not_desktop then @text_input = ''
        append_font 'KangxiDict', @generate_preview

      mounted: ->
        @initialed = true
        @$parent.$parent.loading = false
        @loading_preview = true

      methods:
        generate_preview: ->
          @loading_preview = true
          @create_preview_image()

        generator: (action) ->
          @output_action = action
          if __client isnt null and  __client.isRunning() then @prepare_generator() else @open_captcha @prepare_generator

        prepare_generator: ->
          gogo.start()
          @show_social_share_popup()
          @create_image_html2canvas()

      watch:
        basemap_image: (value) ->
          if is_data value and @initialed
            image = new Image
            image.onload = ( ->
              @canvas_w = image.width
              @canvas_h = image.height
              @$nextTick -> @generate_preview()
            ).bind @
            image.src = @basemap_image
          else
            @base64ify 'basemap_image'

        text_input: (value) ->
          @$validator.validateAll().then ((result) ->
            if result
              text = chinese_char_only(value).trim()
              @text = if text is '' then @default_text else text
          ).bind @

        text: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @generate_preview

        preview_image: (value) ->
          @loading_preview = false
