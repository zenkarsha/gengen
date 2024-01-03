CreatorNameMixin =
  data: ->
    {
      creator_name_list: []
      force_update: Math.random().toString(36).substring(7)
      loading_failed: false
    }

  mounted: ->
    wait = setInterval(( ->
      counter = 0
      total = 0
      for key, value of @creator_name_list
        if value isnt '' then counter++
        total++
      if (counter is total and total > 0) or @loading_failed then clearInterval wait
      @force_update = Math.random().toString(36).substring(7)
    ).bind(@), 100)

  methods:
    get_creator_name: (cid) ->
      self = @
      if @_i18n isnt null
        self.model.creators.read_item cid, (result) ->
          if !result.empty
            self.creator_name_list[cid] = result.docs[0].data().name
          else
            if cid is self.user.uid
              self.creator_name_list[cid] = self.user.displayName
            else
              self.creator_name_list[cid] = self.$t('text.anonymous')
        , (error) ->
          xx error
          self.creator_name_list[cid] = self.$t('text.anonymous')

    add_creator_name_item: (cid) ->
      if @creator_name_list.hasOwnProperty(cid) isnt true
        @creator_name_list[cid] = ''
        @get_creator_name cid
