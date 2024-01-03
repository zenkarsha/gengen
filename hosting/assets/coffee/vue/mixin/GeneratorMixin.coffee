GeneratorMixin =
  data: ->
    {
      canvas_background: '#ccc'
      mouse_down: 0
    }

  created: ->
    document.body.addEventListener 'mousedown', ( ->
      @mouse_down += 1
    ).bind(this)

    document.body.addEventListener 'mouseup', ( ->
      @mouse_down -= 1
    ).bind(this)

  methods:
    base64ify: (data_key) ->
      if is_url @$data[data_key]
        _url = w_base64(@$data[data_key])
        if source_exists _url
          self = @
          gogo.start()
          Vue.http.get(_url).then (result) ->
            eval 'self.' + data_key + ' = result.body'
            gogo.stop()
        else
          @base64ify_local data_key

    base64ify_local: (data_key) ->
      if is_url @$data[data_key]
        gogo.start()
        image = document.createElement 'img'
        image.onload = ( ->
          canvas = document.createElement 'canvas'
          canvas.width = image.width
          canvas.height = image.height
          ctx = canvas.getContext '2d'
          ctx.drawImage image, 0, 0
          output = canvas.toDataURL 'image/png'
          eval 'this.' + data_key + ' = output'
          gogo.stop()
        ).bind @
        image.setAttribute 'crossOrigin', 'anonymous'
        image.src = @$data[data_key]

    convert_images: (images, callback) ->
      self = @
      for item in images then @base64ify item
      wait = setInterval(( ->
        if images.map((item) -> self.$data[item]).every is_data
          clearInterval wait
          callback()
      ), 1)

    create_preview_image: ->
      setTimeout(( ->
        if $('#output_container').length > 0
          self = @
          html2canvas(document.querySelector('#output_container'), { scale: 1, logging: false, backgroundColor: null }).then((canvas) ->
            output = canvas.toDataURL 'image/png'
            if typeof self.preview_image isnt 'undefined' then self.preview_image = output
          ).catch (error) ->
            xx error
      ).bind(@), 500)

    create_image: (width, height, object_configs) ->
      canvas = document.createElement 'canvas'
      canvas.width = width
      canvas.height = height
      ctx = canvas.getContext '2d'
      ctx.rect 0, 0, width, height
      ctx.fillStyle = @canvas_background
      ctx.fill()
      for config in object_configs
        if config.type is 'image'
          image = new Image
          image.src = config.url
          ctx.drawImage image, config.x, config.y, config.w, config.h
        else if config.type is 'text'
          ctx.font = config.font
          ctx.strokeText config.text, config.x, config.y
          ctx.fillStyle = config.color
          ctx.fillText config.text, config.x, config.y
      canvas.toDataURL 'image/png'

    create_image_html2canvas: ->
      gogo.start()
      self = @
      if $('#output_container').length
        html2canvas(document.querySelector('#output_container'), { scale: 1, logging: false, backgroundColor: null }).then (canvas) ->
          output = canvas.toDataURL 'image/png'
          self.handle_output_action output
          gogo.stop()
