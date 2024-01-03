Vue.mixin
  methods: {
    q_auto: (url) -> q_auto url
    q_avatar: (url) -> q_avatar url
    q_quote: (url) -> q_quote url
    q_gen_avatar: (url) -> q_gen_avatar url
    q_gen_cover: (url) -> q_gen_cover url
    q_label: (url) -> q_label url
    w_80: (url) -> w_80 url
    w_fit: (url, size) -> w_fit url, size
    w_square: (url, size) -> w_square url, size
    nl2br: (text) -> nl2br text
    ucfirst: (string) -> ucfirst string
    html_encode: (value) -> html_encode value
    timestamp: (value) -> timestamp value
    array_set_first: (array, element) -> array_set_first array, element
    px: (value) -> px value
    is_url: (value) -> is_url value
    scroll_top: -> scroll_top()
    url_escape: (string) -> url_escape string

    readable_time: (timestamp) ->
      date = new Date(timestamp * 1000)
      seconds = Math.floor((new Date - date) / 1000)
      interval = Math.floor(seconds / 31536000)
      if interval > 1 then return interval + @$t('time.years_ago')
      interval = Math.floor(seconds / 2592000)
      if interval > 1 then return interval + @$t('time.months_ago')
      interval = Math.floor(seconds / 86400)
      if interval > 1 then return interval + @$t('time.days_ago')
      interval = Math.floor(seconds / 3600)
      if interval > 1 then return interval + @$t('time.hours_ago')
      interval = Math.floor(seconds / 60)
      if interval > 1 then return interval + @$t('time.mins_ago')
      return @$t('time.just_now')
  }
