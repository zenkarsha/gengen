GeneratorsOfficialModel =
  data: ->
    {
      model: generators_official:
        read_item: (gid, callback, error_callback)->
          DB.collection('generators_official').doc(gid).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list: (order_key, sort, limit, callback, error_callback) ->
          DB.collection('generators_official').where('public', '==', true).orderBy(order_key, sort).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list_paginate: (order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('generators_official').where('public', '==', true).orderBy(order_key, sort).startAfter(last_doc).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
