FileuploadPreviewMixin =
  methods:
    local_preview: (event, data_key, input_ref, multiple) ->
      @load_preview event.target.files, data_key, input_ref, multiple

    load_preview: (files, data_key, input_ref, multiple) ->
      self = @
      gogo.start()
      if files and files[0]
        if multiple
          i = 0
          while i < files.length
            ((file, i) ->
              self.compress_image files[i], (result) ->
                self.load_preview_image result, data_key, input_ref, true
              , (error) ->
                xx error
                gogo.stop()
                noty self.$t('alert.local_preview_failed'), 'error'
            ) files[i], i
            i++
          eval 'this.$refs.' + input_ref + '.value = null'
          gogo.stop()
        else
          @compress_image files[0], (result) ->
            self.load_preview_image result, data_key, input_ref, false
          , (error) ->
            xx error
            gogo.stop()
            noty self.$t('alert.local_preview_failed'), 'error'

    load_preview_image: (file, data_key, input_ref, multiple) ->
      reader = new FileReader
      reader.onload = ((e) ->
        if multiple
          eval 'this.' + data_key + '.push(e.target.result)'
        else
          eval 'this.' + data_key + ' = e.target.result'
          eval 'this.' + input_ref + '_input = null'
          gogo.stop()
      ).bind @
      reader.readAsDataURL file

    compress_image: (file, callback, error_callback) ->
      new ImageCompressor(file,
        quality: .6
        maxWidth: 1024
        maxHeight: 1024
        success: (result) ->
          callback result
        error: (error) ->
          error_callback error
      )
