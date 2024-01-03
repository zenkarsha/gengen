VintageMixin =
  methods:
    vintage: (image, filter, data_key) ->
      self = @
      effect = vintage_presets[filter]
      vintagejs(image, effect).then((res) ->
        res.getDataURL()
      ).then (result) ->
        eval 'self.' + data_key + ' = result'
