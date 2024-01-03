GeneratorListMixin =
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
            self.query_generator_result doc
          else
            self.handle_list_push doc

    handle_list_push: (doc) ->
      item = doc.data()
      item.gid = doc.id
      @list.push item
      @empty_list = false
      if item.cid and !@official
        @add_creator_name_item item.cid

    query_generator_result: (doc) ->
      self = @
      @model.generators.read_item doc.data().gid, (result) ->
        if result.exists
          self.handle_list_push result
      , (error) ->
        if self.list.length is 0 then self.empty_list = true
        xx error

    handle_list_error: (error) ->
      xx error
      gogo.stop()
      noty @$t('alert.list_loading_failed'), 'error'
