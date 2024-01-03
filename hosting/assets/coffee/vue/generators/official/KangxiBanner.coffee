Vue.component 'KangxiBanner', (resolve, reject) ->
  Vue.http.get('/template/generators/official/kangxi-banner.html').then (template) ->
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

          preview_image: '/images/cover-placeholder.png'

          text: ''
          default_text: '自己的[[國家]]自己[[救]]'
          text_input: '自己的[[國家]]自己[[救]]'

          subtext: ''
          default_subtext: 'FUCK THE GOVERNMENT'
          subtext_input: 'FUCK THE GOVERNMENT'

          text_size: 65
          text_align: 'right'
          background_color: '#000000'
          text_color: '#ffffff'
          highlight_color: '#ff0000'

          load_font_total: 0
          load_font_count: 0
          loaded_font: []

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        append_font 'KangxiDict', @generate_preview
        @text = @default_text
        @subtext = @default_subtext

      mounted: ->
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

        replace_highlight_tags: (string, color) ->
          string.replace(/(\[\[)([^[]*)(\]\])/g, '<span style="color: ' + color + '">$2</span>')

      watch:
        text_input: (value) ->
          @text = if value is '' then @default_text else value

        text: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @generate_preview

        subtext_input: (value) ->
          @subtext = if value is '' then @default_subtext else value

        subtext: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @generate_preview

        text_size: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        text_color: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        highlight_color: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        background_color: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        text_align: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        preview_image: (value) ->
          @loading_preview = false
