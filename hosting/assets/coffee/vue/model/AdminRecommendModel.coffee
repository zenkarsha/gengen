AdminRecommendModel =
  data: ->
    {
      model: admin_recommend:
        read_list: (order_key, sort, limit, callback, error_callback) ->
          DB.collection('admin_recommend').orderBy(order_key, sort).limit(limit).get().then((result) ->
            callback result
          ).catch (error) ->
            error_callback error
    }
