swal
  html: """
    <div class="feed-item-popup">
      <div class="image">
        <a href="/#{@$route.params.lang}/post/#{@config.pid}">
          <img src="#{w_80(@config.image)}" />
        </a>
      </div>
      <div class="image-caption">
        <div class="image-info">
          <span class="image-creator">
            <i class="flaticon-user padding-right"></i>
            #{@creator}
          </span>
          <span class="image-visit-count">
            <i class="flaticon-eye padding-right"></i>
            #{@visit_count}
          </span>
        </div>
        <div class="buttons">
          <button type="button" class="button gray rounded icon share-button-#{@config.pid}">
            <i class="flaticon-next"></i>
          </button>
          <a class="button gray rounded icon" href="/#{@$route.params.lang}/post/#{@config.pid}" target="_blank">
            <i class="flaticon-link"></i>
          </a>
        </div>
      </div>
    </div>
  """
  animation: false
  showConfirmButton: false
