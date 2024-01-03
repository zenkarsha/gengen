Vue.directive 'click-outside',
  bind: (el, binding, vnode) ->
    el.clickOutsideEvent = (event) ->
      if !(el == event.target or el.contains(event.target) or in_array(binding.arg, event.target.classList))
        vnode.context[binding.expression] event
    document.body.addEventListener 'click', el.clickOutsideEvent

  unbind: (el) ->
    document.body.removeEventListener 'click', el.clickOutsideEvent
