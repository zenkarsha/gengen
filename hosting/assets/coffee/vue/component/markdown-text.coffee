Vue.component 'markdown-text',
  template: """
    <div>
      <component v-bind:is="transformed"></component>
      <span v-if="enable_read_more && text.length > max_chars">
        <span class="read-more-toggle" v-show="!read_more" v-on:click="read_more = true" v-text="$t('text.show_more')"></span>
        <span class="read-more-toggle" v-show="read_more" v-on:click="read_more = false" v-text="$t('text.show_less')"></span>
      </span>
    </div>
  """

  data: ->
    {
      read_more: false
    }

  props:
    text:
      type: String
      default: undefined
    enable_read_more:
      type: Boolean
      default: false
    max_chars:
      type: Number
      default: 120

  computed:
    transformed: ->
      if @text isnt undefined
        text = @text
        if @enable_read_more and !@read_more and @text.length > @max_chars
          text = text.substring(0, @max_chars) + '...'

        content = markdownify text
        template = """
          <div class="markdown-content">#{content}</div>
        """
        {
          template: template
          props: @$options.props
        }
