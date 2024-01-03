AdminTemplateModel =
  data: ->
    {
      model: admin_template:
        read_item: (doc, callback, error_callback) ->
          DB.collection('admin_template').doc(doc).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
