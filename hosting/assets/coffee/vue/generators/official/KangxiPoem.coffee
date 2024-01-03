Vue.component 'KangxiPoem', (resolve, reject) ->
  Vue.http.get('/template/generators/official/kangxi-poem.html').then (template) ->
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

        FeedModel
      ]

      data: ->
        {
          config: @config

          preview_image: '/images/avatar-placeholder.jpg'
          text: '藏頭詩產生器'
          default_text: '藏頭詩產生器'
          poem: '白日藏名與時集\n何人頭似雪依依\n似我詩人自江湖\n鑿破產因逢花稀\n松下生雲山自古\n非才器獨無風儀'
          poem_length: 5
          poem_position: 3

          font: 'KangxiDict'
          text_input: ''
          text_size: 50
          background_color: '#ffffff'
          text_color: '#000000'

          load_font_total: 0
          load_font_count: 0
          loaded_font: []

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        append_font @font, @init

      mounted: ->
        if @is_desktop then @$refs.text_input.focus()

      methods:
        init: ->
          @generate_preview()
          @initialed = true
          @$parent.$parent.loading = false

        handle_generate_poem: ->
          @$validator.validateAll().then ((result) ->
            if result and chinese_char_only(@text_input).trim() isnt '' and @initialed
              @text = chinese_char_only(@text_input)
              @$nextTick -> @generate_poem()
            else
              @$refs.text_input.focus()
          ).bind @

        generate_poem: ->
          gogo.start()
          @loading_preview = true
          self = @
          $.ajax
            url: 'https://us-central1-gengen-e3b23.cloudfunctions.net/poemGenerator'
            type: 'post'
            data:
              input_str: @text
              position: self.poem_position
              length: self.poem_length
            dataType: 'json'
            success: (result) ->
              self.poem = result.poem
              gogo.stop()
            error: (error) ->
              xx error
              noty self.$t('alert.something_went_wrong'), 'error'
              gogo.stop()
              self.loading_preview = false

        generate_preview: ->
          @loading_preview = true
          self = @
          setTimeout( ->
            self.create_preview_image()
          , 500)

        generator: (action) ->
          @output_action = action
          if __client isnt null and  __client.isRunning() then @prepare_generator() else @open_captcha @prepare_generator

        prepare_generator: ->
          gogo.start()
          @show_social_share_popup()
          @create_image_html2canvas()

      watch:
        text_input: (value) ->
          @$validator.validateAll().then ((result) ->
            if result and chinese_char_only(value).trim() isnt ''
              @text = chinese_char_only(value)
          ).bind @

        poem: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        font: (value) ->
          if @initialed then append_font value, @generate_preview

        text_size: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        text_color: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        background_color: (value) ->
          if @initialed then @$nextTick -> @generate_preview()

        poem_length: (value) ->
          if @initialed then @generate_poem()

        poem_position: (value) ->
          if @initialed then @generate_poem()

        preview_image: (value) ->
          @loading_preview = false
