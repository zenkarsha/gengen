Vue.component 'header-search',
  template: """
    <div class="header-search">
      <div class="search-input-wrapper">
        <div id="search_input" :class="[show_input ? 'on' : '']"></div>
        <button type="button" class="button icon rounded small transparent" v-on:click="toggle_input">
          <i class="menuicon search" v-if="!show_input"></i>
          <i class="flaticon-cancel" v-if="show_input"></i>
        </button>
      </div>
      <div id="search_result" v-show="show_result"></div>
    </div>
  """

  data: ->
    {
      algolia: null
      show_input: false
      show_result: false
    }

  mounted: ->
    @init()
    $('body').delegate '#search_input input', 'keyup', ((event) ->
      if event.keyCode == 27 and @show_input then @toggle_input()
    ).bind @

  methods:
    init: ->
      self = @
      lang = @$route.params.lang
      @algolia = instantsearch(
        appId: '1PN8RNLG1P'
        apiKey: '37df6b0549ad175eb0f3264c077e4a35'
        indexName: 'generators'
        searchParameters:
          attributesToRetrieve: [
            'cover',
            'title'
            'description'
            'event_information'
            'tags'
            'multiple_title'
            'multiple_description'
            'multiple_event_information'
            'multiple_tags'
          ]
        searchFunction: (helper) ->
          if helper.state.query == ''
            self.show_result = false
          else
            helper.search()
            self.show_result = true
      )

      @algolia.addWidget instantsearch.widgets.searchBox(
        container: '#search_input'
        placeholder: @$t('text.search')
        autofocus: false
      )

      @algolia.addWidget instantsearch.widgets.hits(
        container: '#search_result'
        templates:
          item: (result) ->
            """
              <a class="search-result-item" href="/#{lang}/g/#{result.objectID}">
                <div class="item-cover">
                  <img src="#{q_avatar(result.cover)}" />
                </div>
                <div class="item-content">
                  <h3>
                    <i class="flaticon-lightning-electric-energy"></i>
                    #{result.title}
                  </h3>
                  <p>#{result.description}</p>
                </div>
              </a>
            """
      )

      @algolia.start()

    toggle_input: ->
      if @show_input
        @close()
      else
        @show_input = true

    close: ->
      @show_input = false
      @show_result = false
      $('#search_input input').val ''

  watch:
    show_input: (value) ->
      if value is true then $('#search_input input').focus()

    $route: (to, from) ->
      @algolia.dispose()
      i18n.locale = to.params.lang
      Cookies.set '_gg_lang', to.params.lang, expires: 42689
      @init()
