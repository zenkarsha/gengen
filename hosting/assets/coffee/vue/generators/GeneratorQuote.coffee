Vue.component 'GeneratorQuote',(resolve, reject) ->
  Vue.http.get('/template/generators/quote.html').then (template) ->
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

          canvas_w: 850
          canvas_h: 315
          padding: 20

          preview_image: '/images/cover-placeholder.png'

          role_image: ''
          role_image_select: ''
          role_image_w: 0
          role_image_h: 0

          quote_text: ''
          quote_input: ''
          quote_x: 0
          quote_y: 0
          quote_size: 35
          default_quote_size: 35
          quote_max_height: 0
          role_name: ''

          initialed: false
          loading_preview: false
        }

      beforeMount: ->
        gogo.start()
        @role_image_select = q_quote(@config.role_images[0])
        @quote_text = @quote_input = @config.default_text
        if @is_not_desktop then @quote_input = ''
        @role_name = @config.role_name

      mounted: ->
        @$parent.$parent.loading = false

      methods:
        init: ->
          @loading_preview = true
          @quote_x = @$refs.role_image.offsetWidth + @padding
          @quote_y = (@canvas_h - @$refs.quote_text.offsetHeight) * .5 - @padding
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

      computed:
        calc_max_height: ->
          switch true
            when @quote_size < 32 then return @quote_size * 1.3 * 6
            when @quote_size > 35 then return @quote_size * 1.3 * 4
            else return @quote_size * 1.3 * 5

      watch:
        role_image: (value) ->
          if is_data value
            image = new Image
            image.onload = ( ->
              @role_image_w = image.width
              @role_image_h = image.height
              @$nextTick ->
                @initialed = true
                @init()
            ).bind @
            image.src = @role_image
          else
            @base64ify 'role_image'

        role_image_select: (value) ->
          @role_image = value

        quote_text: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @init

        quote_input: (value) ->
          @quote_text = if value is '' then @config.default_text else value

        quote_size: (value) ->
          if @initialed then @$nextTick -> @init()

        role_name: (value) ->
          if @initialed then @$nextTick ->
            @check_countdown @init

        preview_image: (value) ->
          @loading_preview = false
