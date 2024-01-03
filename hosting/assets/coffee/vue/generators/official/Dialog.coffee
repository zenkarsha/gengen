Vue.component 'Dialog',(resolve, reject) ->
  Vue.http.get('/template/generators/dialog.html').then (template) ->
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
          text_config: JSON.parse @config.text_config

          canvas_w: 0
          canvas_h: 0

          preview_image: '/images/subtitle-placeholder.jpg'
          basemap_image: ''

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        @basemap_image = q_auto(@config.basemap_image)

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
          @create_image_html2canvas()

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

        text_config:
          {
            deep: true
            handler: (after, before) ->
              if @initialed then @$nextTick ->
                @check_countdown @init
          }

        preview_image: (value) ->
          @loading_preview = false
