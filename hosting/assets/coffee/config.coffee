#==============================================================
# Debug
#==============================================================
DEBUG = true
DEBUG = false


#==============================================================
# Vue
#==============================================================
Vue.options.delimiters = ['${', '}']
Vue.use(VeeValidate)


#==============================================================
# Firebase
#==============================================================
DB = firebase.firestore()
DB.settings timestampsInSnapshots: true


#==============================================================
# Firebase Auth
#==============================================================
AUTH =
  google: new firebase.auth.GoogleAuthProvider()
  github: new firebase.auth.GithubAuthProvider()
  twitter: new firebase.auth.TwitterAuthProvider()
  facebook: new firebase.auth.FacebookAuthProvider()


#==============================================================
# Cloudinary
#==============================================================
CLOUDINARY =
  MAIN:
    upload_preset: 'wdlpmlto'
    upload_uri: 'https://api.cloudinary.com/v1_1/gengen/upload'
  SUB:
    upload_preset: 'dbnbbefd'
    upload_uri: 'https://api.cloudinary.com/v1_1/ggproject/upload'


#==============================================================
# Ajax
#==============================================================
$.ajaxSetup
  cache: false
  crossDomain: true


#==============================================================
# Clipboard
#==============================================================
clipboard = new ClipboardJS('.clipboard-button')

clipboard.on 'success', (event) ->
  event.clearSelection()
  noty 'Copied!', 'success'

clipboard.on 'error', (error) ->
  noty 'Copy failed!', 'error'


#==============================================================
# AppLoading
#==============================================================
appLoading.setColor '#e45300'

