TagsModel =
  data: ->
    {
      model: tags:
        write: (data, callback, error_callback) ->
          DB.collection('tags').add(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_item: (tag, gid, callback, error_callback)->
          DB.collection('tags').where('tag', '==', tag).where('gid', '==', gid).limit(1).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        batch_write: (list, gid, cid, callback, error_callback) ->
          batch = DB.batch()
          __timestamp = timestamp()
          for item in list
            data =
              tag: item
              gid: gid
              cid: cid
              timestamp: __timestamp
            batch.set DB.collection('tags').doc(), data

          batch.commit().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list: (tag, order_key, sort, limit, callback, error_callback) ->
          DB.collection('tags').where('tag', '==', tag).orderBy(order_key, sort).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_list_paginate: (tag, order_key, sort, last_doc, limit, callback, error_callback) ->
          DB.collection('tags').where('tag', '==', tag).orderBy(order_key, sort).startAfter(last_doc).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        delete_item: (doc, callback, error_callback) ->
          DB.collection('tags').doc(doc).delete().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

    }
