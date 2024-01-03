Vue.component 'vintage-filter',
  template: """
    <div class="vintage-container">
      <button type="button" :class="class_name" v-on:click="show_popup">
        <i class="icon-filter"></i>${button_text}
      </button>
      <div class="popup-container mobile-fullscreen" v-show="popup_on">
        <div class="popup-wrapper">
          <div class="popup-header black">
            <div class="vintage-image" :style="{ backgroundImage: 'url(' + image + ')' }"></div>
          </div>
          <div class="popup-content">
            <ul class="vintage-filters">
              <li :style="{ backgroundImage: 'url(' + original_image + ')'}" v-on:click="add_effect('original')" :class="[current_filter == 'original' ? 'active' : '']">
                <span>Original</span>
              </li>
              <li v-for="(value, key, index) in vintage_presets" :style="{ backgroundImage: 'url(/images/vintage-fliter/' + key + '.jpg)'}" v-on:click="add_effect(key)" :class="[current_filter == key ? 'active' : '']">
                <span v-text="ucfirst(key)"></span>
              </li>
            </ul>
          </div>
          <div class="popup-footer gray">
            <button type="button" class="button gray" v-on:click="close_popup()" v-text="$t('button.cancel')"></button>
            <button type="button" class="button" v-on:click="handle_output()">
              ${$t('button.done')}
              <i class="flaticon-tick padding-left"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  """
  data: ->
    {
      popup_on: false
      original_image: ''
      current_filter: 'original'
    }

  props:
    image: String
    class_name: type: String, default: 'button'
    button_text: type: String, default: 'Add Vintage'

  methods:
    show_popup: ->
      @$emit 'toggle_dont_move', true
      @popup_on = true
      @original_image = @image

    add_effect: (filter) ->
      @current_filter = filter
      if filter is 'original'
        @image = @original_image
      else
        @vintage @original_image, filter, @preview

    preview: (image) ->
      @image = image

    vintage: (image, filter, callback) ->
      vintagejs(image, vintage_presets[filter]).then((res) ->
        res.getDataURL()
      ).then (result) ->
        callback result

    handle_output: ->
      @$emit 'update', @image
      @close_popup()
      setTimeout(( ->
        @$emit 'toggle_dont_move', false
      ).bind(@), 500)

    close_popup: ->
      if @popup_on is true
        @original_image = ''
        @popup_on = false
