Vue.component 'KangxiAvatar', (resolve, reject) ->
  Vue.http.get('/template/generators/official/kangxi-avatar.html').then (template) ->
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

          preview_image: '/images/avatar-placeholder.jpg'
          text: ''
          default_text: '正大光明'
          text_input: ''
          text_size: 200
          background_color: '#000000'
          text_color: '#ffffff'
          text_align: 'center'
          vertical_text: false

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

      mounted: ->
        if @is_desktop then @$refs.text_input.focus()
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
          if @initialed
            if value.length is 1
              @text_size = 300
            else if value.length <= 4
              @text_size = 200
            else if value.length <= 9
              @text_size = 140
            else if value.length <= 16
              @text_size = 110
            else if value.length <= 25
              @text_size = 90
            else if value.length <= 36
              @text_size = 70
            else
              @text_size = 60

            @$refs.text_size_slider.update_value @text_size
            @$nextTick -> @check_countdown @generate_preview

        text_size: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        text_color: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        background_color: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        text_align: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        vertical_text: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        preview_image: (value) ->
          @loading_preview = false
