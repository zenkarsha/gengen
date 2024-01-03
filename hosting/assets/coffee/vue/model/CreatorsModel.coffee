CreatorsModel =
  data: ->
    {
      model: creators:
        write: (data, callback, error_callback) ->
          DB.collection('creators').add(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_item: (cid, callback, error_callback) ->
          DB.collection('creators').where('id', '==', cid).limit(1).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        update_item: (doc, data, callback, error_callback) ->
          DB.collection('creators').doc(doc).update(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
