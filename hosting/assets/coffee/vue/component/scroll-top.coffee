Vue.component 'scroll-top',
  template: """
    <transition name="bounce">
      <div class="scroll-top" v-on:click="scroll_top" v-show="on">
        <i class="flaticon-up-arrow"></i>
      </div>
    </transition>
  """

  data: ->
    {
      on: false
    }

  mounted: ->
    window.onscroll = ( -> @detect_scroll_position() ).bind @

  methods:
    detect_scroll_position: ->
      @on = if ($(window).scrollTop()  > $('body').height() / 2) or ($(window).scrollTop() > $(window).height()) then true else false
