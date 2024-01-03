CreateFormCheckMixin =
  methods:
    check_basic_field: ->
      if (@title and @title.trim() is '') or (@edit_mode and @form_config.title.trim() is '')
        @form_step = 1
        zenscroll.to @$refs.title_label
        setTimeout(( ->
          @$refs.title.focus()
          noty @$t('alert.generator_title_empty'), 'info'
        ).bind(@), 500)
      if (@description and @description.trim() is '') or (@edit_mode and @form_config.description.trim() is '')
        @form_step = 1
        zenscroll.to @$refs.description_label
        setTimeout(( ->
          @$refs.description.focus()
          noty @$t('alert.generator_description_empty'), 'info'
        ).bind(@), 500)

    check_cover: ->
      if @cover_type is 'custom' and @cover is ''
        @form_step = 2
        zenscroll.to @$refs.cover_label
        noty @$t('alert.generator_cover_empty'), 'info'
        return false

    check_avatar_fields: ->
      if (@frame_images and !@frame_images.length) or (@edit_mode and !@form_config.frame_images.length)
        zenscroll.to @$refs.frame_images_label
        noty @$t('alert.frame_image_empty'), 'info'
        return false
      if (@example_image and !@example_image) or (@edit_mode and !@form_config.example_image)
        zenscroll.to @$refs.example_image_label
        noty @$t('alert.example_image_empty'), 'info'
        return false

    check_sticker_fields: ->
      if (@sticker_images and !@sticker_images.length) or (@edit_mode and !@form_config.sticker_images.length)
        zenscroll.to @$refs.sticker_images_label
        noty @$t('alert.sticker_image_empty'), 'info'
        return false
      if (@example_image and !@example_image) or (@edit_mode and !@form_config.example_image)
        zenscroll.to @$refs.example_image_label
        noty @$t('alert.example_image_empty'), 'info'
        return false

    check_subtitle_fields: ->
      if (@basemap_images and !@basemap_images.length) or (@edit_mode and !@form_config.basemap_images.length)
        zenscroll.to @$refs.basemap_images_label
        noty @$t('alert.example_image_empty'), 'info'
        return false
      if (@default_text and @default_text.trim() is '') or (@edit_mode and @form_config.default_text.trim() is '')
        zenscroll.to @$refs.default_text_label
        noty @$t('alert.default_text_empty'), 'info'
        setTimeout(( ->
          @$refs.default_text.focus()
        ).bind(@), 500)
        return false

    check_quote_fields: ->
      if (@role_images and !@role_images.length) or (@edit_mode and !@form_config.role_images.length)
        zenscroll.to @$refs.role_images_label
        noty @$t('alert.role_image_empty'), 'info'
        return false
      if (@default_text and @default_text.trim() is '') or (@edit_mode and @form_config.default_text.trim() is '')
        zenscroll.to @$refs.default_text_label
        noty @$t('alert.default_text_empty'), 'info'
        setTimeout(( ->
          @$refs.default_text.focus()
        ).bind(@), 500)
        return false
      if (@role_name and @role_name.trim() is '') or (@edit_mode and @form_config.role_name.trim() is '')
        zenscroll.to @$refs.role_name_label
        noty @$t('alert.role_name_empty'), 'info'
        setTimeout(( ->
          @$refs.role_name.focus()
        ).bind(@), 500)
        return false

    check_cover_fields: ->
      if (@frame_images and !@frame_images.length) or (@edit_mode and !@form_config.frame_images.length)
        zenscroll.to @$refs.frame_images_label
        noty @$t('alert.frame_image_empty'), 'info'
        return false
      if (@example_image and !@example_image) or (@edit_mode and !@form_config.example_image)
        zenscroll.to @$refs.example_image_label
        noty @$t('alert.example_image_empty'), 'info'
        return false

    check_meme_fields: ->
      if (@meme_images and !@meme_images.length) or (@edit_mode and !@form_config.meme_images.length)
        zenscroll.to @$refs.meme_images_label
        noty @$t('alert.example_image_empty'), 'info'
        return false
      if (@default_bottom_text and @default_bottom_text.trim() is '') or (@edit_mode and @form_config.default_bottom_text.trim() is '')
        zenscroll.to @$refs.default_text_label
        noty @$t('alert.default_text_empty'), 'info'
        setTimeout(( ->
          @$refs.default_bottom_text.focus()
        ).bind(@), 500)
        return false
