Vue.component 'GeneratorMeme',(resolve, reject) ->
  Vue.http.get('/template/generators/meme.html').then (template) ->
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

        GeneratorsModel
        GeneratorsCountModel
        FeedModel
      ]

      data: ->
        {
          config: @config

          canvas_w: 0
          canvas_h: 0

          preview_image: '/images/subtitle-placeholder.jpg'

          meme_image: ''
          meme_image_select: ''
          top_text: ''
          top_text_input: ''
          top_text_size: 35
          bottom_text: ''
          bottom_text_input: ''
          bottom_text_size: 35

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        @meme_image_select = q_auto(@config.meme_images[0])
        @top_text = @top_text_input = @config.default_top_text
        @bottom_text = @bottom_text_input = @config.default_bottom_text
        if @is_not_desktop then @top_text_input = @bottom_text_input = ''

      mounted: ->
        @$parent.$parent.loading = false

      methods:
        init: ->
          @loading_preview = true
          @$nextTick -> @create_preview_image()

        generator: (action) ->
          @output_action = action
          if __client isnt null and  __client.isRunning() then @prepare_generator() else @open_captcha @prepare_generator

        prepare_generator: ->
          gogo.start()
          @show_social_share_popup()
          setTimeout(( ->
            @create_image_html2canvas()
          ).bind(@), 1000)

      watch:
        meme_image: (value) ->
          if is_data value
            image = new Image
            image.onload = ( ->
              @canvas_w = image.width
              @canvas_h = image.height
              @$nextTick ->
                @initialed = true
                @init()
            ).bind @
            image.src = @meme_image
          else
            @base64ify 'meme_image'

        meme_image_select: (value) ->
          @meme_image = value

        top_text: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @init

        top_text_input: (value) ->
          @top_text = if value is '' then @config.default_top_text else value

        top_text_size: (value) ->
          if @initialed then @$nextTick -> @init()

        bottom_text: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @init

        bottom_text_input: (value) ->
          @bottom_text = if value is '' then @config.default_bottom_text else value

        bottom_text_size: (value) ->
          if @initialed then @$nextTick -> @init()

        preview_image: (value) ->
          @loading_preview = false
