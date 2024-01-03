Vue.component 'feed-list-item',
  template: """
    <div class="item-wrapper">
      <div class="item-label">
        <span class="new" v-if="config.created_at > timestamp() - 432000" v-text="$t('text.new')"></span>
      </div>
      <div class="item-image-wrapper" v-on:click="handle_redirect">
        <div class="item-image" :style="{ backgroundImage: 'url(' + (small_image ? w_fit(config.image, 240) : w_fit(config.image, 400)) + ')' }"></div>
      </div>
      <div class="item-buttons">
        <feed-like-button :pid="config.pid"></feed-like-button>
        <feed-share-button :imgur_id="config.pid" :imgur_link="config.image"></feed-share-button>
      </div>
    </div>
  """

  data: ->
    {
      visit_count: 0
      creator: ''
    }

  props:
    config: Object
    small_image: type: Boolean, default: false

  mixins: [
    CreatorsModel
    FeedCountModel
  ]

  mounted: ->
    $('body').delegate '.share-button-' + @config.pid, 'click', ((event)->
      @show_share_popup()
    ).bind @

  methods:
    handle_redirect: ->
      route_redirect 'feed_post', { pid: @config.pid }

    handle_popup: ->
      self = @
      @model.feed_count.read_item @config.pid, (results) ->
        if !results.empty
          self.visit_count = results.docs[0].data().visit_count + 1
          self.update_visit_count results.docs[0].id, self.visit_count
          self.get_creator_name self.config.uid
      , (error) ->
        xx error
        noty self.$t('alert.something_went_wrong'), 'error'

    show_popup: ->
      #=require ../swal/feed-list-item_popup.coffee

    show_share_popup: ->
      #=require ../swal/feed-list-share_popup.coffee

    update_visit_count: (doc_id, visit_count) ->
      cookie_name = '_gg_i_visit_' + @pid
      visit_check = Cookies.get cookie_name
      if visit_check isnt 'true'
        expire_time = new Date((new Date).getTime() + 360 * 60 * 1000)
        Cookies.set cookie_name, 'true', expires: expire_time
        @model.feed_count.increase_visit_count doc_id, visit_count, (->), (->)

    get_creator_name: (uid) ->
      self = @
      if @_i18n isnt null
        @model.creators.read_item uid, (result) ->
          self.creator = if !result.empty then result.docs[0].data().name else self.$t('text.anonymous')
          self.show_popup()
        , (error) ->
          xx error
          self.creator = self.$t('text.anonymous')
          self.show_popup()
