FeedListMixin =
  data: ->
    {
      list: []
      last_doc: null
      per_page: 24
      no_more_data: false
      empty_list: false
    }

  methods:
    handle_list_result: (results, is_nested) ->
      gogo.stop()
      self = @
      if results.empty
        if @last_doc isnt null
          @no_more_data = true
          noty @$t('alert.no_more_data'), 'info'
        else
          @empty_list = true
      else
        if results.docs.length < @per_page then @no_more_data = true
        @last_doc = results.docs[results.docs.length - 1]
        results.forEach (doc) ->
          if is_nested
            self.query_feed_result doc
          else
            self.handle_list_push doc

    handle_list_push: (doc) ->
      item = doc.data()
      item.gid = doc.id
      @list.push item

    query_feed_result: (doc) ->
      self = @
      @model.feed.read_item doc.data().pid, (result) ->
        if result.exists
          self.handle_list_push result
      , (error) -> self.handle_list_error error

    handle_list_error: (error) ->
      xx error
      gogo.stop()
      noty @$t('alert.list_loading_failed'), 'error'
