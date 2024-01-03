Vue.component 'tag-link',
  template: '<component v-bind:is="transformed"></component>'
  props: ['text']

  methods:
    convert_tag: (string) ->
      if !string then return ''
      string = url_escape string
      string = string.replace(/([^\s!@#$%^&*()=+.\/,\[{\]};:'"?><]+)/g, '#$1')
      spanned = '<div class="tags">' + string + '</div>'
      spanned.replace(/#([^\s!@#$%^&*()=+.\/,\[{\]};:'"?><]+),?/g, '<router-link :to="{name: \'tag\', params: {lang: $route.params.lang, tag: \'$1\'}}">#$1</router-link>')

  computed:
    transformed: ->
      template = @convert_tag @text
      {
        template: template
        props: @$options.props
      }
