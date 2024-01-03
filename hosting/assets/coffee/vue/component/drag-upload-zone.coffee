Vue.component 'drag-upload-zone',
  template: """
    <div ref="drag_zone" :class="['drag-upload-zone', show_drag_zone ? 'on' : '']">
      <i class="flaticon-upload"></i>
      <span v-text="$t('text.drag_file_here')"></span>
    </div>
  """

  data: ->
    {
      counter: 0
      show_drag_zone: false
    }

  mounted: ->
    if !@is_mobile
      @counter = 0
      $('#app')[0].addEventListener 'dragenter', ((event) ->
        event.preventDefault()
        @counter++
        if !@show_drag_zone then @show_drag_zone = true
      ).bind @

      $('#app')[0].addEventListener 'dragleave',  ->
        @counter--
        if @counter is 0 and @show_drag_zone then @show_drag_zone = false

      @$refs.drag_zone.addEventListener 'mouseover',  ->
        if @show_drag_zone then @show_drag_zone = false

      $('#app')[0].addEventListener 'dragover', ((event) ->
        event.stopPropagation()
        event.preventDefault()
        event.dataTransfer.dropEffect = 'copy'
      )

      $('#app')[0].addEventListener 'drop', ((event) ->
        event.stopPropagation()
        event.preventDefault()
        if @show_drag_zone then @show_drag_zone = false
        image_types = [
          'image/png'
          'image/gif'
          'image/bmp'
          'image/jpg'
          'image/jpeg'
        ]
        if event.dataTransfer and event.dataTransfer.files
          file_type = event.dataTransfer.files[0].type
          if image_types.includes(file_type)
            @$emit 'callback', event.dataTransfer.files
      ).bind(@)

      $('#app')[0].addEventListener 'mouseup', ((event) ->
        if @show_drag_zone then @show_drag_zone = false
      ).bind(@)
