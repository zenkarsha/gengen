MobileNavMixin =
  data: ->
    {
      mobile_nav_on: false
    }

  methods:
    toggle_mobile_nav: ->
      @mobile_nav_on = if @mobile_nav_on is false then true else false
