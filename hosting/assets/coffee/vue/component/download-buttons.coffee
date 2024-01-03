Vue.component 'generator-action-buttons',
  template: """
    <div class="form-action">
      <div class="download-buttons">
        <button type="button" class="button danger icon" v-on:click="action('download')">
          <i class="flaticon-download padding-right"></i>
          ${$t('button.download_image')}
        </button>
        <button type="button" class="button icon" v-on:click="action('share_to_feed')">
          <i class="flaticon-upload-1 padding-right"></i>
          ${$t('button.share_to_feed')}
        </button>
        <button type="button" class="button icon" v-on:click="action('create_link')">
          <i class="flaticon-link padding-right"></i>
          ${$t('button.create_link')}
        </button>
        <button type="button" class="button icon" v-on:click="show_more_actions">
          <i class="flaticon-more-button-of-three-dots padding-right"></i>
          ${$t('button.more_action')}
        </button>
      </div>
    </div>
  """

  mounted: ->
    $('body').delegate '.action-button', 'click', ((event)->
      swal.close()
      @$emit 'action', $(event.currentTarget).attr 'data-action'
    ).bind @

  methods:
    show_more_actions: ->
      #=require ../swal/generator-more_action_popup.coffee

    action: (action) ->
      @$emit 'action', action
