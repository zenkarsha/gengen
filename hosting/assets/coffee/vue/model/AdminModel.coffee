AdminModel =
  data: ->
    {
      model: admin:
        read_item: (uid, callback, error_callback) ->
          DB.collection('admin').where('uid', '==', uid).limit(1).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
