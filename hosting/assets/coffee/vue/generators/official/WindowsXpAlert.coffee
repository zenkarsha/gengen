Vue.component 'WindowsXpAlert',(resolve, reject) ->
  Vue.http.get('/template/generators/official/windows-xp-alert.html').then (template) ->
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
          text_config: [
            {
              key: 'text_1'
              label_text: '警告內容'
              text: '您的大腦即將在2001/08/07停止終止支援，按此了解更多詳情'
              width: 320
              max_lines: 2
              left_offset: 190
              top_offset: -28
            }
            {
              key: 'text_2'
              label_text: '勾選確認文字'
              text: '不要再顯示這個訊息'
              width: 300
              max_lines: 1
              left_offset: 210
              top_offset: 18
            }
          ]

          canvas_w: 0
          canvas_h: 0

          preview_image: '/images/subtitle-placeholder.jpg'
          basemap_image: ''

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        append_font 'PMingLiU', @create_preview_image
        @basemap_image = q_auto(@config.basemap_image)

      mounted: ->
        @loading_preview = true
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
