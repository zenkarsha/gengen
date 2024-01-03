FeedModel =
  data: ->
    {
      model: feed:
        write: (data, callback, error_callback) ->
          DB.collection('feed').doc(data.pid).set(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_item: (pid, callback, error_callback)->
          DB.collection('feed').doc(pid).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list: (order_key, sort, limit, callback, error_callback) ->
          DB.collection('feed').orderBy(order_key, sort).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list_paginate: (order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('feed').orderBy(order_key, sort).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_generator_list: (gid, order_key, sort, limit, callback, error_callback) ->
          DB.collection('feed').where('gid', '==', gid).orderBy(order_key, sort).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_generator_list_paginate: (gid, order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('feed').where('gid', '==', gid).orderBy(order_key, sort).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_user_list: (uid, order_key, sort, limit, callback, error_callback) ->
          DB.collection('feed').orderBy(order_key, sort).where('uid', '==', uid).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_user_list_paginate: (uid, order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('feed').orderBy(order_key, sort).where('uid', '==', uid).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        delete_item: (doc, callback, error_callback)->
          DB.collection('feed').doc(doc).update({deleted: true}).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
