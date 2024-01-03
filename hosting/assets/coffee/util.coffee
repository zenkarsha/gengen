#==============================================================
# Basic
#==============================================================
index = (obj, i) -> obj[i]
redirect = (path) -> window.location = path
random = (array) -> array[Math.floor(Math.random() * array.length)]
isset = (variable) -> return if typeof variable != 'undefined' then true else false
scroll_top = -> zenscroll.toY 0, 1
url_escape = (string) -> return string.replace(/([\s!@#$%^&*()=+.\/\[{\]};:'"?><]+)/g, '')
in_array = (needle, haystack) ->
  length = haystack.length
  i = 0
  while i < length
    if haystack[i] == needle
      return true
    i++
  false
random_string = (length) ->
  text = ''
  possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  i = 0
  while i < length
    text += possible.charAt(Math.floor(Math.random() * possible.length))
    i++
  return text
source_exists = (src) ->
  http = new XMLHttpRequest
  http.open 'HEAD', src, false
  http.send()
  http.status is 200


#==============================================================
# String
#==============================================================
text2lines = (text) -> text.match(/[^\r\n]+/g)
ucfirst = (string) -> string.charAt(0).toUpperCase() + string.slice(1)
px2float = (string) -> parseFloat string.replace('px', '')
markdownify = (text) -> markdown.toHTML text
px = (value) -> value + 'px'
nl2br = (string) ->
  if typeof string == 'undefined' or string == null then return ''
  string = (string + '').replace /([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1</div><div>$2'
  string = '<div>' + string + '</div>'
shave = -> $('.shave-me').shave 24
chinese_char_only = (string) ->
  string = string.replace(/[^\u4e00-\u9fa5]/g, '')
  string = string.replace(/[\ufe30-\uffa0]/g, '')


#==============================================================
# Array
#==============================================================
array_set_first = (array, element) ->
  array.sort (x, y) ->
    if x == element then -1 else if y == element then 1 else 0
  return array


#==============================================================
# Object
#==============================================================
sort_object = (object, sort_key) ->
  object.sort (a, b) -> b[sort_key] - (a[sort_key])


#==============================================================
# Color
#==============================================================
random_gradient = ->
  color_1 =
    r: Math.floor(Math.random() * 255)
    g: Math.floor(Math.random() * 255)
    b: Math.floor(Math.random() * 255)
  color_2 =
    r: Math.floor(Math.random() * 255)
    g: Math.floor(Math.random() * 255)
    b: Math.floor(Math.random() * 85)
  color_1.rgb = 'rgb(' + color_1.r + ',' + color_1.g + ',' + color_1.b + ')'
  color_2.rgb = 'rgb(' + color_2.r + ',' + color_2.g + ',' + color_2.b + ')'
  return 'radial-gradient(at top left, ' + color_1.rgb + ', ' + color_2.rgb + ')'

hex_to_rgb = (hex) ->
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  if result
    [parseInt(result[1], 16), parseInt(result[2], 16), parseInt(result[3], 16)]
  else
    null

get_text_color = (hex) ->
  rgb = hex_to_rgb(hex)
  contrast = Math.round((parseInt(rgb[0]) * 299 + parseInt(rgb[1]) * 587 + parseInt(rgb[2]) * 114) / 1000)
  if contrast > 125 then '#000' else '#fff'


#==============================================================
# Is or not
#==============================================================
is_data = (string) ->
  pattern = /^\s*data:([a-z]+\/[a-z0-9-+.]+(;[a-z-]+=[a-z0-9-]+)?)?(;base64)?,([a-z0-9!$&',()*+;=\-._~:@\/?%\s]*)\s*$/i;
  regex = new RegExp pattern
  regex.test string

is_url = (string) ->
  a = document.createElement('a')
  a.href = string
  a.host and a.host != window.location.host

is_webview = ->
  useragent = navigator.userAgent
  rules = [
    'WebView'
    '(iPhone|iPod|iPad)(?!.*Safari/)'
    'Android.*(wv|.0.0.0)'
  ]
  regex = new RegExp(rules.join('|'), 'ig')
  Boolean useragent.match(regex)

is_tranparency = (src, callback) ->
  image = new Image
  canvas = document.createElement 'canvas'
  ctx = canvas.getContext '2d'
  result = false
  detection = ->
    canvas.width = image.width
    canvas.height = image.height
    ctx.drawImage(image, 0, 0)
    image_data = ctx.getImageData(0, 0, canvas.width, canvas.height)
    data = image_data.data
    i = 0
    while i < data.length
      if data[i + 3] < 255
        result = true
        break
      i += 4
    wait = setInterval(( ->
      if i >= data.length or result is true
        clearInterval wait
        callback result
    ).bind(callback), 1)
  image.crossOrigin = 'anonymous'
  image.onload = detection
  image.src = src


#==============================================================
# Date & Time
#==============================================================
timestamp = -> Math.floor(Date.now() / 1000)


#==============================================================
# Language
#==============================================================
lang_initial = ->
  cookie_lang = Cookies.get '_gg_lang'
  if cookie_lang isnt undefined and cookie_lang isnt 'undefined'
    lang = cookie_lang
  else
    browser_lang = window.navigator.userLanguage or window.navigator.language
    switch browser_lang
      when 'ja' then lang = 'ja'
      when 'zh-TW', 'zh-HK', 'zh-MO' then lang = 'zh_hant'
      when 'zh-SG', 'zh-CN' then lang = 'zh_hant'
      else lang = 'en'
  Cookies.set '_gg_lang', lang, expires: 42689
  i18n.locale = lang


#==============================================================
# Routing
#==============================================================
route_redirect = (route_name, route_params) ->
  router.push
    name: route_name
    params: route_params

save_current_route = ->
  Cookies.set '_gg_redirect_from', window.location.pathname
  Cookies.set '_gg_redirect_from_namespace', router.history.current.name

route_back = ->
  redirect_from = Cookies.get '_gg_redirect_from'
  redirect_from_namespace = Cookies.get '_gg_redirect_from_namespace'
  if redirect_from isnt undefined and redirect_from isnt '' and redirect_from isnt 'null' and redirect_from_namespace isnt undefined and redirect_from_namespace isnt '' and redirect_from_namespace isnt 'null' and redirect_from_namespace isnt 'login' and redirect_from_namespace isnt 'logout'
    Cookies.set '_gg_redirect_from', ''
    Cookies.set '_gg_redirect_from_namespace', ''
    redirect redirect_from
  else
    Cookies.set '_gg_redirect_from', ''
    Cookies.set '_gg_redirect_from_namespace', ''
    redirect_home()

redirect_home = ->
  route_redirect 'home', { lang: i18n.locale }

route_get_all = ->
  query = window.location.search.substring(1)
  vars = query.split('&')
  query_string = {}
  i = 0
  while i < vars.length
    pair = vars[i].split('=')
    if typeof query_string[pair[0]] == 'undefined'
      query_string[pair[0]] = decodeURIComponent(pair[1])
    else if typeof query_string[pair[0]] == 'string'
      arr = [query_string[pair[0]], decodeURIComponent(pair[1])]
      query_string[pair[0]] = arr
    else
      query_string[pair[0]].push decodeURIComponent(pair[1])
    i++
  query_string

route_get = (target, default_value = '') ->
  object = route_get_all()
  return if object[target] is undefined then default_value else object[target]


#==============================================================
# URL
#==============================================================
url_encode = (url) ->
  url.replace(/\s/g, '+')

check_url_exist = (url) ->
  request = if window.XMLHttpRequest then new XMLHttpRequest else new ActiveXObject('Microsoft.XMLHTTP')
  request.open 'GET', url, false
  request.send()
  if request.status == 404 then false else true

force_download = (url, filename) ->
  link = document.createElement 'a'
  link.href = url
  link.download = filename
  document.body.appendChild link
  link.click();
  document.body.removeChild link


#==============================================================
# HTML encode
#==============================================================
html_encode = (value) -> $('<div/>').text(value).html()
html_decode = (value) -> $('<div/>').html(value).text()


#==============================================================
# Font
#==============================================================
append_font = (font, callback) ->
  link = document.createElement('link')
  link.setAttribute 'rel', 'stylesheet'
  link.setAttribute 'type', 'text/css'
  link.onload = ->
    FontFaceOnload font,
      success: -> callback()
  link.setAttribute 'href', 'https://font.gengen.co/fonts/' + font + '/font.css?v=1.0'
  document.getElementsByTagName('head')[0].appendChild link


#==============================================================
# Open Popup Window
#==============================================================
open_popup_window = (url, w, h) ->
  screen_left = if window.screenLeft != undefined then window.screenLeft else window.screenX
  screen_top = if window.screenTop != undefined then window.screenTop else window.screenY
  width = if window.innerWidth then window.innerWidth else if document.documentElement.clientWidth then document.documentElement.clientWidth else screen.width
  height = if window.innerHeight then window.innerHeight else if document.documentElement.clientHeight then document.documentElement.clientHeight else screen.height
  left = width / 2 - (w / 2) + screen_left
  top = height / 2 - (h / 2) + screen_top

  new_window = window.open url, "", 'scrollbars=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left
  if window.focus
    new_window.focus()


#==============================================================
# Noty
#==============================================================
noty = (text, type) ->
  new Noty(
    text: text
    theme: 'relax'
    type: type
    layout: 'topCenter'
    timeout: 4000
    progressBar: false
    killer: true
  ).show()


#==============================================================
# Loading bar
#==============================================================
gogo =
  start: -> appLoading.start()
  stop: ->
    setTimeout( ->
      appLoading.stop()
    , 800)


#==============================================================
# Cloudinary
#==============================================================
q_auto = (url) ->
  url.replace '/image/upload/', '/image/upload/q_auto/'

q_avatar = (url) ->
  url.replace '/image/upload/', '/image/upload/w_96,h_96,c_crop,c_fill,q_auto/'

q_quote = (url) ->
  url.replace '/image/upload/', '/image/upload/h_315,q_auto/'

q_gen_avatar = (url) ->
  url.replace '/image/upload/', '/image/upload/w_600,h_600,q_auto/'

q_gen_cover = (url) ->
  url.replace '/image/upload/', '/image/upload/w_850,h_315,q_auto/'

q_label = (url) ->
  url.replace '/image/upload/', '/image/upload/w_200,q_auto/'


#==============================================================
# Weserv.nl
#==============================================================
w_80 = (url) ->
  _url = 'https://images.weserv.nl/?url=' + url.replace('https://', '') + '&q=80&output=jpg'
  _backup_url = 'https://aqkzhs8un.cloudimg.io/cdn/n/q80.png-lossy-80/' + url.replace('https://', '')
  # return if source_exists _url then _url else _backup_url
  return _url

w_fit = (url, size) ->
  _url = 'https://images.weserv.nl/?url=' + url.replace('https://', '') + '&w=' + size + '&h=' + size + '&t=letterbox&bg=373737&q=80&output=jpg'
  _backup_url = 'https://aqkzhs8un.cloudimg.io/fit/' + size + 'x' + size + '/c373737/' + url.replace('https://', '')
  # return if source_exists _url then _url else _backup_url
  return _url

w_square = (url, size) ->
  _url = 'https://images.weserv.nl/?url=' + url.replace('https://', '') + '&w=' + size + '&h=' + size + '&t=square&q=80&output=jpg'
  _backup_url = 'https://aqkzhs8un.cloudimg.io/crop/' + size + 'x' + size + '/q80.png-lossy-80/' + url.replace('https://', '')
  # return if source_exists _url then _url else _backup_url
  return _url

w_base64 = (url) ->
  'https://images.weserv.nl/?url=' + url.replace('https://', '') + '&encoding=base64'


#==============================================================
# Html
#==============================================================
lock_html = ->
  $('body').addClass 'lock-scroll'

unlock_html = ->
  $('body').removeClass 'lock-scroll'


#==============================================================
# Debug
#==============================================================
consoler = (x) -> console.log '%c' + x, 'background: black; padding:3px 5px; font-size: 10px; color: #ffffff; border-radius: 3px'
xx = (x) -> DEBUG && console.log x
xxx = (x) -> consoler x
