Vue.component 'feed-like-button',
  template: """
    <span :class="['like-button', liked ? 'liked' : '']" v-on:click="toggle_like_button">
      <i class="flaticon-heart padding-right"></i>
      ${like_count}
    </span>
  """

  mixins: [
    UserMixin
    FeedCountModel
    FeedLikeLogModel
  ]

  props: ['pid']

  data: ->
    {
      like_count: 0
      liked: false
    }

  mounted: ->
    @get_like_count()

  methods:
    get_like_count: ->
      self = @
      @model.feed_count.read_item @pid, (result) ->
        if result.exists then self.like_count = result.data().like_count
      , (error) ->
        xx error

    get_like_state: ->
      if @user and @user.isAnonymous is false
        self = @
        @model.feed_like_log.read_item @user.uid, @pid, (result) ->
          if result.exists then self.liked = true
        , (error) ->
          xx error

    toggle_like_button: ->
      if @user and @user.isAnonymous is false
        if @liked then @unlike() else @like()
      else
        route_redirect 'login', { lang: i18n.locale }

    like: ->
      data =
        pid: @pid
        uid: @user.uid
      @liked = true
      @like_count += 1
      @model.feed_like_log.write data, (result) ->
        # do nothing
      , (error) ->
        xx error

    unlike: ->
        @liked = false
        like_count = @like_count - 1
        if like_count < 0 then like_count = 0
        @like_count = like_count
        @model.feed_like_log.delete_item @user.uid, @pid, (result) ->
          # do nothing
        , (error) ->
          xx error

  watch:
    user: (value) ->
      if value.isAnonymous is false then @get_like_state()
