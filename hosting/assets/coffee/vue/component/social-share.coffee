Vue.component 'social-share',
  template: """
    <button type="button" class="button danger mini" v-on:click="show_popup">
      <i class="flaticon-next padding-right"></i>
      ${$t('title.share_generator')}
    </button>
  """
  props: ['link']
  methods:
    show_popup: ->
      link = @link
      #=require ../swal/link-share-popup.coffee
