html = """
  <div class="post-image">
    <img src="#{image}" />
  </div>
"""
swal(
  html: html
  input: 'textarea'
  inputValue: ''
  inputPlaceholder: @$t('message.write_something')
  animation: false
  showCancelButton: true
  confirmButtonText: @$t('button.share_to_feed')
  cancelButtonText: @$t('button.cancel')
  confirmButtonClass: 'button'
  cancelButtonClass: 'button gray'
  buttonsStyling: false
  reverseButtons: true
  focusConfirm: true
  allowOutsideClick: false
  onOpen: ->
    gogo.stop()
).then ((result) ->
  if result.dismiss is swal.DismissReason.cancel
    # do nothing
  else
    message = if result.value then result.value else ''
    @share_to_feed image, message
).bind @
