GeneratorsModel =
  data: ->
    {
      model: generators:
        write: (data, callback, error_callback) ->
          DB.collection('generators').add(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_item: (gid, callback, error_callback)->
          DB.collection('generators').doc(gid).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list: (order_key, sort, limit, callback, error_callback) ->
          DB.collection('generators').where('public', '==', true).orderBy(order_key, sort).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list_multiple_order: (order_key_1, sort_1, order_key_2, sort_2, limit, callback, error_callback) ->
          DB.collection('generators').where('public', '==', true).orderBy(order_key_1, sort_1).orderBy(order_key_2, sort_2).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list_paginate: (order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('generators').where('public', '==', true).orderBy(order_key, sort).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_creator_list: (cid, order_key, sort, limit, callback, error_callback) ->
          DB.collection('generators').where('public', '==', true).orderBy(order_key, sort).where('cid', '==', cid).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_creator_list_paginate: (cid, order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('generators').where('public', '==', true).orderBy(order_key, sort).where('cid', '==', cid).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_user_list: (cid, order_key, sort, limit, callback, error_callback) ->
          DB.collection('generators').orderBy(order_key, sort).where('cid', '==', cid).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_user_list_paginate: (cid, order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('generators').orderBy(order_key, sort).where('cid', '==', cid).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        update_item: (doc, data, callback, error_callback)->
          DB.collection('generators').doc(doc).update(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        delete_item: (doc, callback, error_callback)->
          DB.collection('generators').doc(doc).update({deleted: true}).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
