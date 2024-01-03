UseragentMixin =
  data: ->
    {
      is_mobile: false
      is_not_mobile: false
      is_tablet: false
      is_desktop: false
      is_not_desktop: false
      is_safari: false
      is_not_safari: false
      is_firefox: false
      is_not_firefox: false
    }

  created: ->
    $is.mobile() && @is_mobile = true
    $is.not.mobile() && @is_not_mobile = true
    $is.tablet() && @is_tablet = true
    $is.desktop() && @is_desktop = true
    $is.not.desktop() && @is_not_desktop = true
    $is.safari() && @is_safari = true
    $is.not.safari() && @is_not_safari = true
    $is.firefox() && @is_firefox = true
    $is.not.firefox() && @is_not_firefox = true

