swal
  html: """
    <h2>#{self.$t('title.share')}</h2>
    <div class="social-share-buttons">
      <button class="social-button twitter" data-sharer="twitter" data-url="https://imgur.com/#{imgur_id}/"></button>
      <button class="social-button facebook" data-sharer="facebook" data-url="#{imgur_link}"></button>
      <button class="social-button googleplus" data-sharer="googleplus" data-url="#{imgur_link}"></button>
      <button class="social-button tumblr" data-sharer="tumblr" data-url="https://imgur.com/#{imgur_id}/"></button>
      <button class="social-button line" data-sharer="line" data-url="https://imgur.com/#{imgur_id}"></button>
      <button class="social-button email" data-sharer="email" data-url="#{imgur_link}"></button>
    </div>
    <div class="share-link">
      <input value="#{imgur_link}" readonly="readonly" onclick="this.setSelectionRange(0, 9999)">
      <span class="copy-button clipboard-button" data-clipboard-text="#{imgur_link}">Copy</span>
    </div>
  """
  animation: false
  showConfirmButton: false
  showCancelButton: true
  cancelButtonText: self.$t('button.close')
  cancelButtonClass: 'button'
  buttonsStyling: false
  onOpen: ( ->
    Sharer.init()
  ).bind @
