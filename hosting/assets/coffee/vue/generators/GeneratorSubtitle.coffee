Vue.component 'GeneratorSubtitle',(resolve, reject) ->
  Vue.http.get('/template/generators/subtitle.html').then (template) ->
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

          basemap_image: ''
          basemap_image_select: ''
          subtitle_text: ''
          subtitle_input: ''
          subtitle_x: 0
          subtitle_y: 0
          subtitle_size: 45
          text_positon: 'bottom'

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        @basemap_image_select = q_auto(@config.basemap_images[0])
        @subtitle_text = @subtitle_input = @config.default_text
        if @is_not_desktop then @subtitle_input = ''

      mounted: ->
        @$parent.$parent.loading = false

      methods:
        init: ->
          @loading_preview = true
          @subtitle_x = (@canvas_w - @$refs.subtitle_text.offsetWidth) * .5
          if @text_positon is 'bottom'
            @subtitle_y = @canvas_h - @$refs.subtitle_text.offsetHeight - 30
          else
            @subtitle_y = 30
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
        basemap_image: (value) ->
          if is_data value
            image = new Image
            image.onload = ( ->
              @canvas_w = image.width
              @canvas_h = image.height
              @$nextTick ->
                @initialed = true
                @init()
            ).bind @
            image.src = @basemap_image
          else
            @base64ify 'basemap_image'

        basemap_image_select: (value) ->
          @basemap_image = value

        subtitle_text: (value) ->
          @subtitle_x = 0
          @subtitle_y = 0
          if @initialed then @$nextTick ->
            @check_countdown @init

        subtitle_input: (value) ->
          @subtitle_text = if value is '' then @config.default_text else value

        subtitle_size: (value) ->
          @subtitle_x = 0
          @subtitle_y = 0
          if @initialed then @$nextTick -> @init()

        text_positon: (value) ->
          if @initialed then @$nextTick -> @init()

        preview_image: (value) ->
          @loading_preview = false
