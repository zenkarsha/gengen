CreateGeneratorMixin =
  data: ->
    {
      insert_total: 0
      insert_counter: 0
    }

  beforeDestroy: ->
    if @$parent.processing is true then @$parent.processing = false

  methods:
    handle_form_submit: ->
      noty @$t('alert.processing'), 'alert'
      @$parent.processing = true
      @form_submit = true
      @data = @handle_form_data()
      @handle_fileupload()
      wait = setInterval(( ->
        if !@uploading and @uploading_queue is @uploading_finish
          clearInterval wait
          @insert_generator()
      ).bind(@), 100)

    handle_fileupload: ->
      @fileupload @cover, 'data.cover', false
      switch @template
        when 'avatar', 'cover'
          @fileupload @example_image, 'data.example_image', false
          for image, index in @frame_images then @fileupload image, 'data.frame_images', true
        when 'sticker'
          @fileupload @example_image, 'data.example_image', false
          for image, index in @sticker_images then @fileupload image, 'data.sticker_images', true
        when 'subtitle'
          for image, index in @basemap_images then @fileupload image, 'data.basemap_images', true
        when 'quote'
          for image, index in @role_images then @fileupload image, 'data.role_images', true

    insert_generator: ->
      self = @
      @insert_creator()
      @model.generators.write @data, (result) ->
        self.handle_redirect result.id
      , (error) ->
        xx error
        gogo.stop()
        self.$parent.processing = true
        noty self.$t('alert.generator_create_failed'), 'error'

    insert_creator: ->
      self = @
      @model.creators.read_item @user.uid, (results) ->
        if results.empty and self.user.isAnonymous is false
          data =
            id: self.user.uid
            name: self.user.displayName
            avatar: self.user.photoURL
            provider: self.user.providerData[0].providerId
          self.model.creators.write data, (->), (->)
      , (error) -> xx error

    handle_redirect: (gid) ->
      gogo.stop()
      redirect '/' + @$route.params.lang + '/g/' + gid
