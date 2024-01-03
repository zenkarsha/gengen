GG =
  template: """
    <component v-bind:is="page_template"></component>
  """

  mixins: [
    UserMixin

    AdminModel
    AdminTemplateModel
  ]

  data: ->
    {
      page_template: 'page-not-found'
    }

  mounted: ->
    @$parent.loading = false

  watch:
    user: (value) ->
      self = @
      @model.admin.read_item value.uid, (results) ->
        if !results.empty
          self.model.admin_template.read_item 'dashboard', (result) ->
            script = document.createElement('script')
            script.type = 'text/javascript'
            script.innerHTML = result.data().template
            document.body.appendChild script
            self.page_template = 'dashboard'
            self.$parent.loading = false
          , (error) ->
            # do nothing
      , (error) ->
        # do nothing
