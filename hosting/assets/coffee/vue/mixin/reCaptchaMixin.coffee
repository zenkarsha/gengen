reCaptchaMixin =
  data: ->
    {
      recaptcha:
        callback: null
        verified: false
        error: false
    }

  mounted: ->
    window.verify_recaptcha = @verify_recaptcha

  methods:
    open_recaptcha: (callback) ->
      @recaptcha.callback = callback
      swal
        html: """
          <h2>#{@$t('title.human_verify')}</h2>
          <div class="recaptcha-container">
            <div class="g-recaptcha" data-sitekey="6LcabnAUAAAAALufwbPePbpXflDyzigol8ayTouV" data-callback="verify_recaptcha"></div>
          </div>
        """
        animation: false
        showConfirmButton: false
        showCancelButton: true
        cancelButtonText: @$t('button.cancel')
        onBeforeOpen: ( ->
          @add_recaptcha_script()
        ).bind @

    close_recaptcha: ->
      swal.close()
      @remove_recaptcha_script()
      @recaptcha.callback = null
      @recaptcha.verified = false
      @recaptcha.error = false

    add_recaptcha_script: ->
      script = document.createElement 'script'
      script.setAttribute 'src', 'https://www.google.com/recaptcha/api.js'
      script.setAttribute 'async', 'async'
      script.setAttribute 'id', 'recaptcha_script'
      document.head.appendChild script

    remove_recaptcha_script: ->
      (script = document.getElementById('recaptcha_script')).parentNode.removeChild script

    verify_recaptcha: (token) ->
      self = @
      $.ajax
        url: 'https://us-central1-gengen-e3b23.cloudfunctions.net/reCaptchaVerify'
        type: 'post'
        data:
          token: token
        dataType: 'json'
        success: (result) ->
          if result.success
            self.recaptcha.verified = true
          else
            self.recaptcha.error = true
        error: (error) ->
          self.recaptcha.error = true

  watch:
    'recaptcha.verified': (value) ->
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
            @recaptcha.callback()
            @close_recaptcha()
        ).bind @

    'recaptcha.error': (value) ->
      if value is true
        noty @$t('alert.verify_failed'), 'error'
