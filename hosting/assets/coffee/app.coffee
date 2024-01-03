#=require util.coffee
#=require config.coffee
#=require vintage.coffee

#=require vue/langs/*.coffee
#=require vue/mixin/*.coffee
#=require vue/directive/*.coffee
#=require vue/model/*.coffee
#=require vue/pages/*.coffee
#=require vue/generators/**/*
#=require vue/component/*.coffee

#=require vue/util.coffee
#=require vue/router.coffee
#=require vue/lang.coffee

# dev only
##=require vue/dashboard/*.coffee

Vue.use VTooltip

vm = new Vue({
  i18n: i18n
  router: router
  mixins: [
    UserMixin
    UseragentMixin
  ]

  data: ->
    {
      show_webview_notice: false
    }

  mounted: ->
    setTimeout( ->
      $('#page_loading').hide()
    , 500)

}).$mount '#app'
