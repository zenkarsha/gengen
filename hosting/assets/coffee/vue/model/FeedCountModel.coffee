FeedCountModel =
  data: ->
    {
      model: feed_count:
        write: (data, callback, error_callback) ->
          DB.collection('feed_count').doc(data.pid).set(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_item: (pid, callback, error_callback)->
          DB.collection('feed_count').doc(pid).onSnapshot ((result) ->
            callback result
          ), (error) ->
            error_callback error

        read_list: (gid, order_key_1, sort_1, order_key_2, sort_2, limit, callback, error_callback) ->
          DB.collection('feed_count').where('gid', '==', gid).orderBy(order_key_1, sort_1).orderBy(order_key_2, sort_2).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((results) ->
            callback results
          ).catch (error) ->
            error_callback error

        read_list_paginate: (gid, order_key_1, sort_1, order_key_2, sort_2, last_doc, limit, callback, error_callback) ->
          DB.collection('feed_count').where('gid', '==', gid).orderBy(order_key_1, sort_1).orderBy(order_key_2, sort_2).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((results) ->
            callback results
          ).catch (error) ->
            error_callback error

        increase_visit_count: (doc_id, visit_count, callback, error_callback)->
          DB.collection('feed_count').doc(doc_id).update(visit_count: visit_count, last_visit: timestamp()).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        update_like_count: (doc_id, like_count, callback, error_callback)->
          DB.collection('feed_count').doc(doc_id).update(like_count: like_count).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        increase_report_count: (doc_id, report_count, callback, error_callback)->
          DB.collection('feed_count').doc(doc_id).update(report_count: report_count).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        delete_item: (doc_id, callback, error_callback)->
          DB.collection('feed_count').doc(doc_id).update(deleted: true).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
