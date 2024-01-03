FeedCommentsModel =
  data: ->
    {
      model: feed_comments:
        write: (data, callback, error_callback) ->
          DB.collection('feed_comments').add(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list: (pid, order_key, sort, limit, callback, error_callback) ->
          DB.collection('feed_comments').where('pid', '==', pid).orderBy(order_key, sort).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((results) ->
            callback results
          ).catch (error) ->
            error_callback error

        read_list_paginate: (pid, order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('feed_comments').where('pid', '==', pid).orderBy(order_key, sort).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((results) ->
            callback results
          ).catch (error) ->
            error_callback error
    }
