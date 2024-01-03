FileuploadMixin =
  data: ->
    {
      uploading: false
      uploading_failed: false
      uploading_queue: 0
      uploading_finish: 0
    }
  methods:
    fileupload: (file, data_key, multiple) ->
      if file
        @uploading = true
        @uploading_queue += 1

        xhr = new XMLHttpRequest
        form_data = new FormData
        xhr.open 'POST', CLOUDINARY.MAIN.upload_uri, true
        xhr.setRequestHeader 'X-Requested-With', 'XMLHttpRequest'

        xhr.onreadystatechange = ((e) ->
          if xhr.readyState == 4
            @uploading = false
            if xhr.status == 200
              @uploading_finish += 1
              result = JSON.parse xhr.responseText
              if multiple
                eval 'var index = this.' + data_key + '.indexOf(file)'
                eval 'this.' + data_key + '[index] = result.secure_url'
              else
                eval 'this.' + data_key + ' = result.secure_url'
            else
              @uploading_failed = true
              noty @$t('alert.image_upload_failed'), 'error'
        ).bind @

        form_data.append 'upload_preset', CLOUDINARY.MAIN.upload_preset
        form_data.append 'tags', 'browser_upload'
        form_data.append 'file', file
        xhr.send form_data
