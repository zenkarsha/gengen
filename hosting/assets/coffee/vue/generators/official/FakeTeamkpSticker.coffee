Vue.component 'FakeTeamkpSticker', (resolve, reject) ->
  Vue.http.get('/template/generators/official/fake-teamkp-sticker.html').then (template) ->
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

          preview_image: '/images/subtitle-placeholder.jpg'

          text: ''
          default_text: '愚人的問題'
          text_input: '愚人的問題'

          highlight: ''
          default_highlight: '智障可以回答'
          highlight_input: '智障可以回答'

          hashtag: ''
          default_hashtag: '#fakeTeamKP'
          hashtag_input: '#fakeTeamKP'

          text_color: '#000000'
          highlight_color: '#00dbdd'

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        @text = @default_text
        @highlight = @default_highlight
        @hashtag = @default_hashtag

      mounted: ->
        @generate_preview()
        @initialed = true
        @$parent.$parent.loading = false

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
        text_input: (value) ->
          @text = if value is '' then @default_text else value

        text: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @generate_preview

        highlight_input: (value) ->
          @highlight = if value is '' then @default_highlight else value

        highlight: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @generate_preview

        hashtag_input: (value) ->
          @hashtag = if value is '' then @default_hashtag else value

        hashtag: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @generate_preview

        preview_image: (value) ->
          @loading_preview = false
