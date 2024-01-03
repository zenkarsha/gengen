swal
  html: """
    <h2>#{@$t('title.share')}</h2>
    <div class="social-share-buttons">
      <button class="social-button twitter" data-sharer="twitter" data-url="#{item.url}"></button>
      <button class="social-button facebook" data-sharer="facebook" data-url="#{item.image}"></button>
      <button class="social-button googleplus" data-sharer="googleplus" data-url="#{item.image}"></button>
      <button class="social-button tumblr" data-sharer="tumblr" data-url="#{item.url}"></button>
      <button class="social-button line" data-sharer="line" data-url="#{item.url}"></button>
      <button class="social-button email" data-sharer="email" data-url="#{item.image}"></button>
    </div>
    <div class="share-link">
      <input value="#{item.image}" readonly="readonly" onclick="this.setSelectionRange(0, 9999)">
      <span class="copy-button clipboard-button" data-clipboard-text="#{item.image}">#{@$t('button.copy')}</span>
    </div>
  """
  animation: false
  showConfirmButton: false
  onOpen: ( ->
    Sharer.init()
  ).bind @
