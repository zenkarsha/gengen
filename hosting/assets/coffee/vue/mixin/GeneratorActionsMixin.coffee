GeneratorActionsMixin =
  data: ->
    {
      output_action: 'download'
      share_dialog: null
    }

  mounted: ->
    $('body').delegate '.action-button', 'click', ((event)->
      swal.close()
      @generator $(event.currentTarget).attr 'data-action'
    ).bind @

  beforeDestroy: ->
    if @$parent.$parent.processing is true then @$parent.$parent.processing = false
    if @$parent.$parent.publishing is true then @$parent.$parent.publishing = false

  methods:
    handle_output_action: (output) ->
      @$parent.$parent.processing = true
      if @config.gid isnt undefined and typeof @config.official is 'undefined' then @update_use_count()
      switch @output_action
        when 'download'
          @save output
          @download_image output
        when 'create_link' then @create_link output
        when 'post_to_facebook' then @social_share output, 'facebook'
        when 'post_to_twitter' then @social_share output, 'twitter'
        when 'post_to_googleplus' then @social_share output, 'googleplus'
        when 'send_to_line' then @social_share output, 'line'
        when 'share_to_feed' then @show_feed_share_popup output
        else @download_image output

    save: (output)->
      if @user and @user.isAnonymous is false
        json = localStorage.getItem 'user_images'
        if json is null then json = [] else json = JSON.parse json
        inserted = false
        while !inserted
          try
            filename = md5(timestamp() + @config.gid + Math.random().toString(36).substring(7))
            localStorage.setItem filename, output
            inserted = true
          catch error
            json = sort_object json, 'timestamp'
            last = json[json.length - 1]
            index = json.indexOf last
            json.splice(index, 1)
            localStorage.removeItem last.image
        official = if typeof @config.official is 'undefined' then false else true
        data =
          gid: @config.gid
          official: official
          image: filename
          timestamp: timestamp()
        json.push data
        localStorage.setItem 'user_images', JSON.stringify(json)

    save_link: (result) ->
      if @user and @user.isAnonymous is false
        json = localStorage.getItem 'user_links'
        if json is null then json = [] else json = JSON.parse json
        data =
          url: 'https://imgur.com/' + result.data.id
          image: result.data.link
          deletehash: result.data.deletehash
          timestamp: timestamp()
        json.push data
        localStorage.setItem 'user_links', JSON.stringify(json)

    update_use_count: ->
      self = @
      @model.generators_count.read_item @config.gid, (result) ->
        if result.exists
          use_count = result.data().use_count + 1
          self.model.generators_count.increase_use_count result.id, use_count, (result) ->
          , (error) -> xx error
      , (error) -> xx error

    download_image: (image) ->
      @$parent.$parent.processing = false
      gogo.stop()
      if @is_not_desktop
        #=require ../swal/generator-download_image_popup.coffee
      else
        force_download image, 'image.png'

    create_link: (image) ->
      self = @
      noty @$t('alert.link_generating'), 'alert'
      @upload_imgur image, (result) ->
        self.$parent.$parent.processing = false
        if result.data.link
          imgur_id = result.data.id
          imgur_link = result.data.link
          #=require ../swal/imgur-share-popup.coffee
        else
          noty self.$t('alert.link_generate_failed'), 'error'
      , (error) ->
        xx error
        self.$parent.$parent.processing = false
        noty self.$t('alert.link_generate_failed'), 'error'

    show_social_share_popup: ->
      switch @output_action
        when 'post_to_facebook', 'post_to_twitter', 'post_to_googleplus', 'send_to_line'
          if @is_desktop then @share_dialog = window.open '/loading', 'share_dialog', 'height=600,width=500'

    social_share: (image, target) ->
      noty @$t('alert.processing'), 'alert'
      self = @
      @upload_imgur image, (result) ->
        self.$parent.$parent.processing = false
        if result.data.id
          switch target
            when 'twitter'
              url = 'https://twitter.com/intent/tweet/?url=' + encodeURIComponent('https://imgur.com/' + result.data.id)
            when 'facebook'
              url = 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(result.data.link)
            when 'googleplus'
              url = 'https://plus.google.com/share?url=' + encodeURIComponent(result.data.link)
            when 'line'
              url = 'https://social-plugins.line.me/lineit/share?url=' + encodeURIComponent('https://imgur.com/' + result.data.id)
          if self.is_not_desktop then redirect url else self.share_dialog.location.href = url
        else
          if self.is_desktop then self.share_dialog.location.href = '/loading-failed'
          noty self.$t('alert.link_generate_failed'), 'error'
      , (error) ->
        self.$parent.$parent.processing = false
        noty self.$t('alert.link_generate_failed'), 'error'

    show_feed_share_popup: (image) ->
      @$parent.$parent.processing = false
      #=require ../swal/generator-feed_share_popup.coffee

    share_to_feed: (image, message) ->
      @$parent.$parent.publishing = true
      gogo.start()
      self = @
      noty @$t('alert.processing'), 'alert'
      @upload_imgur image, (result) ->
        uid = if self.user then self.user.uid else 'anonymous'
        if result.data.id
          pid = result.data.id
          data =
            pid: pid
            gid: self.config.gid
            uid: uid
            image: result.data.link
            message: message
            created_at: timestamp()
            updated_at: timestamp()
            public: self.config.public
            banned: false
            flagged: false
            deleted: false

          if typeof self.config.official != 'undefined'
            data.official = true

          gogo.stop()
          self.model.feed.write data, (result) ->
            redirect '/' + self.$route.params.lang + '/post/' + pid
          , (error) ->
            xx error
            self.$parent.$parent.publishing = false
            noty self.$t('alert.something_went_wrong'), 'error'
        else
          xx 'imgur upload failed'
          gogo.stop()
          self.$parent.$parent.publishing = false
          noty self.$t('alert.something_went_wrong'), 'error'
      , (error) ->
        gogo.stop()
        self.$parent.$parent.publishing = false
        noty self.$t('alert.something_went_wrong'), 'error'

    upload_imgur: (base64, callback, error_callback) ->
      self = @
      $.ajax
        url: 'https://api.imgur.com/3/image'
        type: 'post'
        headers: Authorization: 'Client-ID 36f2c6c4618678a'
        data:
          image: base64.split(",")[1]
          type: 'base64'
          description: 'Image generate by: https://gengen.co/g/' + @config.gid
        dataType: 'json'
        success: (result) ->
          gogo.stop()
          if result.success
            if self.config.gid isnt undefined and self.output_action is 'create_link'
              self.save_link result
            callback result
          else
            noty self.$t('alert.link_generate_failed'), 'error'
        error: (error) ->
          error_callback error
