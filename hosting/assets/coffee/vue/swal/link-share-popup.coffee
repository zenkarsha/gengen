swal
  html: """
    <h2>#{@$t('title.share')}</h2>
    <div class="social-share-buttons">
      <button class="social-button twitter" data-sharer="twitter" data-url="#{link}"></button>
      <button class="social-button facebook" data-sharer="facebook" data-url="#{link}"></button>
      <button class="social-button googleplus" data-sharer="googleplus" data-url="#{link}"></button>
      <button class="social-button tumblr" data-sharer="tumblr" data-url="#{link}"></button>
      <button class="social-button line" data-sharer="line" data-url="#{link}"></button>
      <button class="social-button email" data-sharer="email" data-url="#{link}"></button>
    </div>
    <div class="share-link">
      <input value="#{link}" readonly="readonly" onclick="this.setSelectionRange(0, 9999)">
      <span class="copy-button clipboard-button" data-clipboard-text="#{link}">#{@$t('button.copy')}</span>
    </div>
  """
  animation: false
  showConfirmButton: false
  onOpen: ( ->
    Sharer.init()
  ).bind @
