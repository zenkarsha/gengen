CaptchaMixin =
  data: ->
    {
      captcha:
        callback: null
        verified: false
        error: false
      hashes: 256
    }

  mounted: ->
    window.verify_captcha = @verify_captcha

  methods:
    open_captcha: (callback) ->
      @captcha.callback = callback
      swal
        html: """
          <h2>#{@$t('title.human_verify')}</h2>
          <div class="coinhive-captcha" data-hashes="#{@hashes}" data-whitelabel="true" data-key="D4mNDPMGtSIniJIR5shlV0ucruUumTbP" data-callback="verify_captcha">
            <em>Loading...<br>If loading failed, please trun off Adblock.</em>
          </div>
        """
        animation: false
        showConfirmButton: false
        showCancelButton: true
        cancelButtonText: @$t('button.cancel')
        onBeforeOpen: ( ->
          @add_captcha_script()
        ).bind @


    close_captcha: ->
      swal.close()
      @remove_captcha_script()
      @captcha.callback = null
      @captcha.verified = false
      @captcha.error = false

    add_captcha_script: ->
      script = document.createElement 'script'
      script.setAttribute 'src', 'https://authedmine.com/lib/captcha.min.js'
      script.setAttribute 'async', 'async'
      script.setAttribute 'id', 'captcha_script'
      document.head.appendChild script

    remove_captcha_script: ->
      (script = document.getElementById('captcha_script')).parentNode.removeChild script

    verify_captcha: (token) ->
      self = @
      $.ajax
        url: 'https://us-central1-gengen-e3b23.cloudfunctions.net/captchaVerify'
        type: 'post'
        data:
          token: token
        dataType: 'json'
        success: (result) ->
          if result.success
            self.captcha.verified = true
          else
            self.captcha.error = true
        error: (error) ->
          self.captcha.error = true

  watch:
    'captcha.verified': (value) ->
      if value is true
        swal(
          animation: false
          showConfirmButton: true
          showCancelButton: false
          confirmButtonText: @$t('button.continue')
          type: 'success'
          text: @$t('message.your_are_human')
        ).then ((result) ->
          if result.value
            @captcha.callback()
            @close_captcha()
        ).bind @

    'captcha.error': (value) ->
      if value is true
        noty @$t('alert.verify_failed'), 'error'
