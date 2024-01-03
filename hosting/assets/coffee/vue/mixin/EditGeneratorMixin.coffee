EditGeneratorMixin =
  data: ->
    {
      edit_mode: false
      form_edited: false
      cover_cropping: false

      form_config: []
      original_config: []
      cover_input: null

      show_sticker_popup: false
    }

  updated: ->
    setTimeout(( ->
      if $('input[type="tags"]').length > 0 then @init_tag_input()
    ).bind(@), 500)

  methods:
    init_tag_input: ->
      if @edit_mode
        $('input[type="tags"]').not('.initialed').each (index) ->
          tagsInput $(this)[0]
          $(this).addClass 'initialed'
        $('#tags')[0].addEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.tags = event.target.value
        ).bind(@)
        $('#tags_en')[0].addEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.multiple_tags.en = event.target.value
        ).bind(@)
        $('#tags_ja')[0].addEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.multiple_tags.ja = event.target.value
        ).bind(@)
        $('#tags_zh_hant')[0].addEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.multiple_tags.zh_hant = event.target.value
        ).bind(@)
        $('#tags_zh_hans')[0].addEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.multiple_tags.zh_hans = event.target.value
        ).bind(@)

    cancel_edit_generator: ->
      @edit_mode = false
      @edit_config = []
      @original_config = []

    update_generator: ->
      @$validator.validateAll().then ((result) ->
        if !result
          @check_basic_field()
        else
          switch @form_config.template
            when 'avatar' then if @check_avatar_fields() is false then return false
            when 'sticker' then if @check_sticker_fields() is false then return false
            when 'subtitle' then if @check_subtitle_fields() is false then return false
            when 'quote' then if @check_quote_fields() is false then return false
          @handle_form_submit()
      ).bind @

    handle_form_submit: ->
      self = @
      gogo.start()
      @$parent.$parent.loading = true
      @handle_fileupload()
      wait = setInterval(( ->
        if !@uploading and @uploading_queue is @uploading_finish
          clearInterval wait
          @update_data()
      ).bind(@), 100)

    update_data: ->
      self = @
      @model.generators.update_item @form_config.gid, @form_config, (results) ->
        noty self.$t('alert.setting_updated'), 'success'
        scroll_top()
        gogo.stop()
        self.$parent.$parent.loading = false
      , (error) ->
        xx error
        gogo.stop()
        noty self.$t('alert.something_went_wrong'), 'error'

    handle_fileupload: ->
      if is_data(@form_config.cover)
        @fileupload @form_config.cover, 'form_config.cover', false
      switch @form_config.template
        when 'avatar'
          if @form_config.example_image isnt @original_config.example_image
            @fileupload @form_config.example_image, 'form_config.example_image', false
          for image, index in @form_config.frame_images
            if is_data(image) then @fileupload image, 'form_config.frame_images', true
        when 'sticker'
          if @form_config.example_image isnt @original_config.example_image
            @fileupload @form_config.example_image, 'form_config.example_image', false
          for image, index in @form_config.sticker_images
            if is_data(image) then @fileupload image, 'form_config.sticker_images', true
        when 'subtitle'
          for image, index in @form_config.basemap_images
            if is_data(image) then @fileupload image, 'form_config.basemap_images', true
        when 'quote'
          for image, index in @form_config.role_images
            if is_data(image) then @fileupload image, 'form_config.role_images', true

    confirm_delete: ->
      #=require ../swal/delete-generator-popup.coffee

    delete_generator: ->
      self = @
      gogo.start()
      @model.generators.delete_item @form_config.gid, (results) ->
        gogo.stop()
        swal self.$t('title.delete_success'), self.$t('message.delete_success_content'), 'success'
        self.reload_list()
        self.edit_mode = false
        self.edit_config = []
        self.original_config = []
        setTimeout( ->
          scroll_top()
        , 500)
      , (error) ->
        xx error
        gogo.stop()
        noty self.$t('alert.something_went_wrong'), 'error'

    update_sticker_position: (array) ->
      @form_config.default_sticker_x = array.sticker_x
      @form_config.default_sticker_y = array.sticker_y
      @form_config.default_sticker_w = array.sticker_w
      @form_config.default_sticker_h = array.sticker_h
      @form_config.default_sticker_rotate = array.sticker_rotate
      @show_sticker_popup = false

  watch:
    form_config:
      {
        deep: true
        handler: (after, before) ->
          if before.length isnt 0
            @original_config = JSON.parse JSON.stringify @form_config
            @form_edited = true
      }

    'form_config.cover': (value) ->
      if is_data value
        if @cover_cropping
          @cover_cropping = false
        else
          @cover_cropping = true
          self = @
          setTimeout( ->
            self.$refs.cover_cropper.show_popup()
          , 1000)

    edit_mode: (value) ->
      if value is false
        $('#tags')[0].removeEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.tags = event.target.value
        ).bind(@)
        $('#tags_en')[0].removeEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.multiple_tags.en = event.target.value
        ).bind(@)
        $('#tags_ja')[0].removeEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.multiple_tags.ja = event.target.value
        ).bind(@)
        $('#tags_zh_hant')[0].removeEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.multiple_tags.zh_hant = event.target.value
        ).bind(@)
        $('#tags_zh_hans')[0].removeEventListener 'change', ((event) ->
          if @form_edited is false then @form_edited = true
          @form_config.multiple_tags.zh_hans = event.target.value
        ).bind(@)
