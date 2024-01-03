Vue.component 'KangxiInscribedBoard', (resolve, reject) ->
  Vue.http.get('/template/generators/official/kangxi-inscribed-board.html').then (template) ->
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
          basemap_images: [
            'https://res.cloudinary.com/gengen/image/upload/v1535698922/official/kangxi_inscribed_board/board_1.jpg'
            'https://res.cloudinary.com/gengen/image/upload/v1535698922/official/kangxi_inscribed_board/board_2.jpg'
            'https://res.cloudinary.com/gengen/image/upload/v1535698922/official/kangxi_inscribed_board/board_3.jpg'
            'https://res.cloudinary.com/gengen/image/upload/v1535698922/official/kangxi_inscribed_board/board_4.jpg'
            'https://res.cloudinary.com/gengen/image/upload/v1535698922/official/kangxi_inscribed_board/board_5.jpg'
          ]

          canvas_w: 0
          canvas_h: 0

          preview_image: '/images/cover-placeholder.png'
          text: '明光大正'
          default_text: '明光大正'
          text_input: ''
          text_margin: 45
          basemap_image: ''
          basemap_image_select: ''

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        @basemap_image_select = q_auto(@basemap_images[0])
        append_font 'KangxiDict', @generate_preview

      mounted: ->
        if @is_desktop then @$refs.text_input.focus()
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
          if is_data value
            image = new Image
            image.onload = ( ->
              @canvas_w = image.width
              @canvas_h = image.height
              @$nextTick -> @generate_preview()
            ).bind @
            image.src = @basemap_image
          else
            @base64ify 'basemap_image'

        basemap_image_select: (value) ->
          @basemap_image = value

        text_input: (value) ->
          @$validator.validateAll().then ((result) ->
            if result
              text = chinese_char_only(value).trim()
              @text = if text is '' then @default_text else text.split('').reverse().join('')
          ).bind @

        text: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @generate_preview

        preview_image: (value) ->
          @loading_preview = false
