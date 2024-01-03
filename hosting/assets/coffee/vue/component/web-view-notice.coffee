Vue.component 'web-view-notice',
  template: """
    <div class="web-view-notice">
      <div class="notice-container">
        <h3 v-text="$t('message.open_in_browser')"></h3>
        <div class="share-link">
          <input :value="page_link" readonly="readonly" onclick="this.setSelectionRange(0, 9999)">
          <span class="copy-button clipboard-button" :data-clipboard-text="page_link">Copy</span>
        </div>
        <br />
        <a href="/" v-text="$t('button.close')" class="button full-width"></a>
      </div>
    </div>
  """

  data: ->
    {
      page_link: window.location.href
    }
