GeneratorsCountModel =
  data: ->
    {
      model: generators_count:
        write: (data, callback, error_callback) ->
          DB.collection('generators_count').doc(data.gid).set(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_item: (gid, callback, error_callback)->
          DB.collection('generators_count').doc(gid).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list: (order_key_1, sort_1, order_key_2, sort_2, limit, callback, error_callback) ->
          DB.collection('generators_count').orderBy(order_key_1, sort_1).orderBy(order_key_2, sort_2).where('public', '==', true).where('banned', '==', false).where('deleted', '==', false).limit(limit).get().then((results) ->
            callback results
          ).catch (error) ->
            error_callback error

        read_list_paginate: (order_key_1, sort_1, order_key_2, sort_2, last_doc, limit, callback, error_callback) ->
          DB.collection('generators_count').orderBy(order_key_1, sort_1).orderBy(order_key_2, sort_2).where('public', '==', true).where('banned', '==', false).where('deleted', '==', false).startAfter(last_doc).limit(limit).get().then((results) ->
            callback results
          ).catch (error) ->
            error_callback error

        update_item: (doc, data, callback, error_callback)->
          DB.collection('generators_count').doc(doc).update(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        increase_visit_count: (doc_id, visit_count, callback, error_callback)->
          DB.collection('generators_count').doc(doc_id).update(visit_count: visit_count, last_visit: timestamp()).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        increase_use_count: (doc_id, use_count, callback, error_callback)->
          DB.collection('generators_count').doc(doc_id).update(use_count: use_count, last_use: timestamp()).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        increase_like_count: (doc_id, like_count, callback, error_callback)->
          DB.collection('generators_count').doc(doc_id).update(like_count: like_count, last_use: timestamp()).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        increase_report_count: (doc_id, report_count, callback, error_callback)->
          DB.collection('generators_count').doc(doc_id).update(report_count: report_count, last_use: timestamp()).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
