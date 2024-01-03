swal
  html: """
    <h2>#{@$t('title.share')}</h2>
    <div class="social-share-buttons">
      <button class="social-button twitter" data-sharer="twitter" data-url="#{@config.image}"></button>
      <button class="social-button facebook" data-sharer="facebook" data-url="#{@config.image}"></button>
      <button class="social-button googleplus" data-sharer="googleplus" data-url="#{@config.image}"></button>
      <button class="social-button tumblr" data-sharer="tumblr" data-url="#{@config.image}"></button>
      <button class="social-button line" data-sharer="line" data-url="#{@config.image}"></button>
      <button class="social-button email" data-sharer="email" data-url="#{@config.image}"></button>
    </div>
    <div class="share-link">
      <input value="#{@config.image}" readonly="readonly" onclick="this.setSelectionRange(0, 9999)">
      <span class="copy-button clipboard-button" data-clipboard-text="#{@config.image}">#{@$t('button.copy')}</span>
    </div>
  """
  animation: false
  showConfirmButton: false
  onOpen: ( ->
    Sharer.init()
  ).bind @
