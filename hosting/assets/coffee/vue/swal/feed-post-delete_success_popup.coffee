swal(
  title: self.$t('title.delete_success')
  text: self.$t('message.delete_success_content')
  type: 'success'
  animation: false
  showCancelButton: false
  confirmButtonText: self.$t('button.done')
).then ((result) ->
  route_redirect 'feed', { gid: self.post.gid }
).bind @
