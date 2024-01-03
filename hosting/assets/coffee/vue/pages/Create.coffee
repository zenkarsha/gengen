Create = (resolve, reject) ->
  Vue.http.get('/template/create.html').then (template) ->
    resolve
      template: template.body
      mixins: [
        UserMixin
        UseragentMixin
        RouteMixin
        FileuploadPreviewMixin
        CreateFormCheckMixin
        FileuploadMixin
        CreateGeneratorMixin
        reCaptchaMixin

        GeneratorsModel
        GeneratorsCountModel
        CreatorsModel
        TagsModel
        TagsCountModel
      ]

      data: ->
        {
          confirm_user_terms: false

          template: ''
          title: ''
          description: ''
          event_information: ''
          cover_type: 'default'
          default_cover_color: 'shady-water'
          random_cover_color: ''
          cover: ''
          cover_input: null
          cid: ''
          image_copyright: 1
          image_copyright_notice: ''
          public: true

          langs: langs
          multiple_langs: false
          multiple_langs_select:
            en: false
            ja: false
            zh_hant: false
            zh_hans: false
          multiple_title:
            en: ''
            ja: ''
            zh_hant: ''
            zh_hans: ''
          multiple_description:
            en: ''
            ja: ''
            zh_hant: ''
            zh_hans: ''
          multiple_event_information:
            en: ''
            ja: ''
            zh_hant: ''
            zh_hans: ''

          sticker_images: []
          frame_images: []
          basemap_images: []
          role_images: []
          meme_images: []
          example_image: ''
          default_text: ''
          role_name: ''
          default_top_text: ''
          default_bottom_text: ''

          form_step: 0
          form_submit: false
          data: {}

          show_preview: false
          show_sticker_popup: false
          preview_config:
            template: 'loading'
        }

      beforeCreate: ->
        @$parent.loading = true
        self = @
        firebase.auth().onAuthStateChanged (user) ->
          if !user
            route_redirect 'login', { lang: i18n.locale }
          else
            self.$parent.loading = false
            if self.confirm_user_terms is false then self.load_terms()

      beforeMount: ->
        if is_webview()
          @$parent.$parent.show_webview_notice = true
          setTimeout( ->
            lock_html()
          , 500)

      mounted: ->
        if @is_not_safari and @is_not_firefox and @is_desktop then @default_cover_color = 'wavey-fingerprint'

      beforeRouteUpdate: (to, from, next) ->
        @multiple_langs_select.en = false
        @multiple_langs_select.ja = false
        @multiple_langs_select.zh_hant = false
        @multiple_langs_select.zh_hans = false
        next()

      methods:
        load_terms: ->
          file = '/document/terms/' + @$route.params.lang + '.md'
          $.get file, ((data) ->
            lock_html()
            swal(
              html: """
                <h2>#{@$t('user_terms.title')}</h2>
                <div class="markdown-content small" style="max-height: 50vh; overflow-y: scroll;">
                  #{markdownify(data)}
                </div>
              """
              animation: false
              showCancelButton: true
              reverseButtons: true
              focusConfirm: true
              allowOutsideClick: false
              confirmButtonText: @$t('button.agree') + '<i class="flaticon-tick padding-left"></i>'
              cancelButtonText: @$t('button.cancel')
              confirmButtonClass: 'button'
              cancelButtonClass: 'button gray'
              buttonsStyling: false
              allowEscapeKey: false
            ).then ((result) ->
              unlock_html()
              if result.value
                @confirm_user_terms = true
                @create_default_cover()
                [].forEach.call document.querySelectorAll('input[type="tags"]'), tagsInput
              else if result.dismiss is swal.DismissReason.cancel
                redirect_home()
            ).bind @
          ).bind @

        handle_cover_type: ->
          if @cover_type is 'custom' then @cover = '' else @create_default_cover()

        handle_cover_preivew_update: ->
          @cover_type is 'default' && @create_default_cover()

        create_default_cover: ->
          self = @
          if $(@$refs.default_cover).length
            html2canvas(@$refs.default_cover, { scale: 1, logging: false }).then (canvas) ->
              output = canvas.toDataURL 'image/jpeg'
              self.cover = output

        handle_choose_cover_image: ->
          @$refs.cover_image.click()
          current_cover = @cover
          wait = setInterval(( ->
            if @cover isnt current_cover
              clearInterval wait
              @$refs.cover_cropper.show_popup()
          ).bind(@), 100)

        handle_preview: ->
          @$validator.validateAll().then ((result) ->
            if !result
              @check_basic_field()
            else
              if @check_cover() is false then return false
              switch @template
                when 'avatar' then if @check_avatar_fields() is false then return false
                when 'sticker' then if @check_sticker_fields() is false then return false
                when 'subtitle' then if @check_subtitle_fields() is false then return false
                when 'quote' then if @check_quote_fields() is false then return false
                when 'cover' then if @check_avatar_fields() is false then return false
                when 'meme' then if @check_meme_fields() is false then return false

              @preview_config = @handle_form_data()
              @preview_config['cover'] = @cover
              @preview_config['preview_mode'] = true
              switch @template
                when 'avatar', 'cover'
                  @preview_config['example_image'] = @example_image
                  @preview_config['frame_images'] = @frame_images
                when 'sticker'
                  @preview_config['example_image'] = @example_image
                  @preview_config['sticker_images'] = @sticker_images
                when 'subtitle'
                  @preview_config['basemap_images'] = @basemap_images
                when 'quote'
                  @preview_config['role_images'] = @role_images
                when 'meme'
                  @preview_config['meme_images'] = @meme_images

              if @template != 'sticker'
                @show_preview = true
              else
                @show_sticker_popup = true
          ).bind @

        update_sticker_position: (array) ->
          @preview_config['default_sticker_x'] = array.sticker_x
          @preview_config['default_sticker_y'] = array.sticker_y
          @preview_config['default_sticker_w'] = array.sticker_w
          @preview_config['default_sticker_h'] = array.sticker_h
          @preview_config['default_sticker_rotate'] = array.sticker_rotate
          @show_preview = true

        handle_form_check: ->
          @$validator.validateAll().then ((result) ->
            if !result
              @check_basic_field()
            else
              if @check_cover() is false then return false
              switch @template
                when 'avatar' then if @check_avatar_fields() is false then return false
                when 'sticker' then if @check_sticker_fields() is false then return false
                when 'subtitle' then if @check_subtitle_fields() is false then return false
                when 'quote' then if @check_quote_fields() is false then return false
                when 'cover' then if @check_cover_fields() is false then return false
                when 'meme' then if @check_meme_fields() is false then return false
              gogo.stop()
              @open_recaptcha @handle_form_submit
          ).bind @

        handle_form_data: ->
          data =
            template: @template
            title: @title
            description: @description
            event_information: @event_information
            tags: url_escape(@$refs.tags.value)
            image_copyright: @image_copyright
            image_copyright_notice: @image_copyright_notice
            multiple_langs: @multiple_langs
            multiple_langs_select: @multiple_langs_select
            multiple_title: @multiple_title
            multiple_description: @multiple_description
            multiple_event_information: @multiple_event_information
            multiple_tags:
              en: @$refs.tags_en.value
              ja: @$refs.tags_ja.value
              zh_hant: @$refs.tags_zh_hant.value
              zh_hans: @$refs.tags_zh_hans.value
            cid: @user.uid
            timestamp: timestamp()
            public: @public
            banned: false
            flagged: false
            deleted: false
          switch @template
            when 'avatar', 'cover'
              data['frame_images'] = @frame_images
            when 'sticker'
              data['sticker_images'] = @sticker_images
              data['default_sticker_x'] = @preview_config.default_sticker_x
              data['default_sticker_y'] = @preview_config.default_sticker_y
              data['default_sticker_w'] = @preview_config.default_sticker_w
              data['default_sticker_h'] = @preview_config.default_sticker_h
              data['default_sticker_rotate'] = @preview_config.default_sticker_rotate
            when 'subtitle'
              data['basemap_images'] = @basemap_images
              data['default_text'] = @default_text
            when 'quote'
              data['role_images'] = @role_images
              data['default_text'] = @default_text
              data['role_name'] = @role_name
            when 'meme'
              data['meme_images'] = @meme_images
              data['default_top_text'] = @default_top_text
              data['default_bottom_text'] = @default_bottom_text
          return data

      watch:
        confirm_user_terms: (value) ->
          if value is true and !@user then @anonymous_login()

        template: (value) ->
          @sticker_images = []
          @frame_images = []
          @basemap_images = []
          @role_images = []
          @example_image = ''
          @default_text = ''
          @role_name = ''

        default_cover_color: (value) ->
          if value isnt 'random'
            @create_default_cover()

        random_cover_color: (value) ->
          @create_default_cover()

        form_step: (value) ->
          self = @
          if value is 1
            if @title is ''
              setTimeout( ->
                self.$refs.title.focus()
              , 100)
            else if @description is ''
              setTimeout( ->
                self.$refs.description.focus()
              , 100)

          if value is 2
            @$validator.validateAll().then (result) ->
              if !result then self.check_basic_field()

          setTimeout( ->
            zenscroll.to self.$refs.form_steps, 1
          , 100)

        sticker_images: (after, before) ->
          if before.length isnt 0 and after.length isnt 0 then zenscroll.to @$refs.sticker_images_label

        frame_images: (after, before) ->
          self = @
          if before.length isnt 0 and after.length isnt 0 then zenscroll.to @$refs.frame_images_label
          for image in after
            is_tranparency image, (results) ->
              if results is false then noty self.$t('message.avatar_frame_images'), 'error'

        basemap_images: (after, before) ->
          if before.length isnt 0 and after.length isnt 0 then zenscroll.to @$refs.basemap_images_label

        role_images: (after, before) ->
          if before.length isnt 0 and after.length isnt 0 then zenscroll.to @$refs.role_images_label

        example_image: (value) ->
          zenscroll.to @$refs.example_image_label

        meme_images: (after, before) ->
          if before.length isnt 0 and after.length isnt 0 then zenscroll.to @$refs.meme_images_label

        show_preview: (value) ->
          if value is true
            setTimeout( ->
              $('.generator-page').clickBubble
                color: '#E45300'
                size: 50
                borderWidth: 3
            , 50)
          else
            gogo.stop()

      computed:
        preview_generator: -> 'Generator' + ucfirst @preview_config.template
