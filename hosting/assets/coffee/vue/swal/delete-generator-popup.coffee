swal(
  title: @$t('title.delete_confirm')
  type: 'warning'
  animation: false
  showCancelButton: true
  reverseButtons: true
  confirmButtonText: @$t('button.yes_delete')
  cancelButtonText: @$t('button.cancel')
).then ((result) ->
  if result.value
    @delete_generator()
).bind @
