swal
  html: """
    <h2>#{@$t('button.more_action')}</h2>
    <div class="more-actions">
      <button type="button" class="button twitter action-button" data-action="post_to_twitter">
        <i class="social-icon-twitter padding-right"></i>
        #{@$t('button.share_to_twitter')}
      </button>
      <button type="button" class="button facebook action-button" data-action="post_to_facebook">
        <i class="social-icon-facebook padding-right"></i>
        #{@$t('button.share_to_facebook')}
      </button>
      <button type="button" class="button line action-button" data-action="send_to_line">
        <i class="social-icon-line-logo padding-right"></i>
        #{@$t('button.share_to_line')}
      </button>
      <button type="button" class="button googleplus action-button" data-action="post_to_googleplus">
        <i class="social-icon-googleplus padding-right"></i>
        #{@$t('button.share_to_googleplus')}
      </button>
    </div>
  """
  animation: false
  showConfirmButton: false
  showCancelButton: false
  cancelButtonText: @$t('button.close')
  cancelButtonClass: 'button'
  buttonsStyling: false
