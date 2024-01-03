FeedLikeLogModel =
  data: ->
    {
      model: feed_like_log:
        write: (data, callback, error_callback) ->
          DB.collection('feed_like_log').doc(data.uid + '_' + data.pid).set(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_item: (uid, pid, callback, error_callback)->
          DB.collection('feed_like_log').doc(uid + '_' + pid).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        delete_item: (uid, pid,  callback, error_callback) ->
          DB.collection('feed_like_log').doc(uid + '_' + pid).delete().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
