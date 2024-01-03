InputBindMixin =
  data: ->
    {
      countdown: Date.now()
    }

  methods:
    update_countdown: ->
      @countdown = Date.now()

    check_countdown: (callback) ->
      setTimeout(( ->
        if Date.now() - @countdown >= 990
          callback()
      ).bind(@), 1000)
