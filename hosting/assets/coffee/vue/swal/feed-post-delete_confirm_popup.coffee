swal(
  title: self.$t('title.delete_confirm')
  type: 'warning'
  animation: false
  showCancelButton: true
  reverseButtons: true
  confirmButtonText: self.$t('button.yes_delete')
  cancelButtonText: self.$t('button.cancel')
).then ((result) ->
  if result.value
    @delete_post()
).bind @
