TagMixin =
  methods:
    add_tag: (tag, gid, cid) ->
      self = @
      data =
        tag: tag
        gid: gid
        cid: cid
        timestamp: timestamp()
      @model.tags.write data, (result) ->
        self.increase_tag_count tag
      , (error) -> xx error

    delete_tag: (tag, gid) ->
      self = @
      @model.tags.read_item tag, gid, (result) ->
        if !result.empty
          doc = result.docs[0].id
          self.model.tags.delete_item doc, (result) ->
            self.decrease_tag_count tag
          , (error) -> xx error
      , (error) -> xx error

    increase_tag_count: (tag) ->
      self = @
      @model.tags_count.read_item tag, (query_tag, result) ->
        if result.empty
          data =
            tag: query_tag
            count: 1
            created_at: timestamp()
            updated_at: timestamp()
          self.model.tags_count.write data, ( -> ), ( -> )
        else
          id = result.docs[0].id
          count = result.docs[0].data().count + 1
          self.model.tags_count.update_count id, count, ( -> ), ( -> )
      , (error) -> xx error

    decrease_tag_count: (tag) ->
      self = @
      @model.tags_count.read_item tag, (query_tag, result) ->
        if !result.empty
          id = result.docs[0].id
          count = result.docs[0].data().count - 1
          self.model.tags_count.update_count id, count, ( -> ), ( -> )
      , (error) -> xx error
