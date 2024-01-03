Vue.component 'feed-comments',
  template: """
    <div class="feed-comments">
      <div class="form">
        <div class="form-wrapper">
          <div class="comment-form form-group">
            <textarea ref="new_message" name="new_message" v-model="new_comment.message" :placeholder="$t('message.comment_placeholder')" v-validate="'max:1000'" :class="{'input': true, 'is-danger': errors.has('new_message') }" v-on:focus="user_check"></textarea>
            <span class="field-message" v-if="errors.has('new_message')">${$t('message.comment_message')}</span>
          </div>
        </div>
        <transition name="fade">
          <div class="buttons" v-if="new_comment.message.length > 0">
              <button type="button" class="button gray" v-text="$t('button.cancel')" v-on:click="cancel_comment"></button>
              <button type="button" class="button" v-text="$t('button.comment')" v-on:click="submit_comment"></button>
          </div>
        </transition>
      </div>
      <div class="comment-list">
        <div class="comment-item" v-for="item in list">
          <div class="avatar">
            <div class="avatar-image" :style="{ backgroundImage: 'url(' + item.avatar }"></div>
          </div>
          <div class="comment-body">
            <span class="name" v-text="item.name"></span>
            <span class="time" v-text="readable_time(item.timestamp)"></span>
            <p class="message">
              <span v-for="line in item.message.split('\\n')" v-text="line"></span>
            </p>
          </div>
        </div>
      </div>
    </div>
  """

  data: ->
    {
      new_comment:
        name: ''
        avatar: ''
        message: ''
        uid: 'anonymous'
        timestamp: ''
        banned: false
        deleted: false
      list: []
      last_doc: null
      per_page: 20
      no_more_data: false
      empty_list: false
    }

  props:
    pid: type: String, default: ''

  mixins: [
    UserMixin
    FeedCommentsModel
  ]

  methods:
    init: ->
      gogo.start()
      self = @
      @model.feed_comments.read_list @pid, 'timestamp', 'desc', @per_page, (results) ->
        gogo.stop()
        if results.empty
          if self.last_doc isnt null
            self.no_more_data = true
          else
            self.empty_list = true
        else
          if results.docs.length < self.per_page then self.no_more_data = true
          self.last_doc = results.docs[results.docs.length - 1]
          results.forEach (doc) ->
            self.list.push doc.data()
      , (error) ->
        xx error
        gogo.stop()
        noty self.$t('alert.something_went_wrong'), 'error'

    user_check: ->
      if !@user then route_redirect 'login', { lang: i18n.locale }

    submit_comment: ->
      if @new_comment.message.trim() isnt ''
        self = @
        gogo.start()
        @new_comment.pid = @pid
        @new_comment.avatar = @handle_user_avatar()
        @new_comment.name = if @user and !@user.isAnonymous then @user.displayName else @$t('text.anonymous')
        @new_comment.uid = if @user then @user.uid else 'anonymous'
        @new_comment.timestamp = timestamp()
        @model.feed_comments.write @new_comment, (result) ->
          self.list.unshift JSON.parse JSON.stringify self.new_comment
          self.cancel_comment()
          gogo.stop()
        , (error) ->
          xx error
          gogo.stop()
          noty self.$t('alert.something_went_wrong'), 'error'
      else
        zenscroll.to @$refs.new_message

    cancel_comment: ->
      @new_comment.message = ''
      @$refs.new_message.style.cssText = 'height: 60px'

  watch:
    pid: (value) ->
      if value isnt '' then @init()
