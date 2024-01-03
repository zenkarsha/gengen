TagsCountModel =
  data: ->
    {
      model: tags_count:
        write: (data, callback, error_callback) ->
          DB.collection('tags_count').add(data).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        read_item: (query_tag, callback, error_callback)->
          DB.collection('tags_count').where('tag', '==', query_tag).limit(1).get().then((result) ->
            callback query_tag, result
          ).catch (error) ->
            error_callback error

        read_list: (order_key, sort, limit, callback, error_callback) ->
          DB.collection('tags_count').where('count', '>', 0).orderBy(order_key, sort).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error

        update_count: (doc, count, callback, error_callback)->
          DB.collection('tags_count').doc(doc).update(count: count, updated_at: timestamp()).then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
