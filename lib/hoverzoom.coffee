(($) ->
  max = (x,y) ->
    if x > y
      x
    else
      y
  min = (x,y) ->
    if x < y
      x
    else
      y
  em = (el) ->
    Number(getComputedStyle(el, "").fontSize.match(/(\d+)px/)[1])
  $.fn.hoverzoom = (ele) ->
    jq = $(ele)
    jq.mouseenter ->
      src = jq.attr('src')
      position = jq.position()
      middle = {}
      middle.left = position.left + jq.width()/2
      middle.top = position.top + jq.height()/2
      full = $('<img class="hoverzoomed" style="pointer-events:none;" src="' + jq.attr('src') + '">')
      height = 16*em(jq.get(0)) # em TODO: constants and store them somewhere
      width = 24*em(jq.get(0)) # em
      return if height*0.9 < jq.height()
      full.appendTo('body')
      full.height(jq.height())
      full.width(jq.width())
      full.hide()
      for name in ['left', 'top']
        full.css(name, max(position[name], 0))
      full.css('position', 'absolute')
      full_left = min($(document).width() - width, middle.left - width/2)
      full_top = min($(document).height() - height, middle.top - height/2)
      full.show()
      jq.mouseleave ->
        full.animate
          height: jq.height()
          width: jq.width()
          left: position.left
          top: position.top
          , 200 ,
          -> full.remove()
      full.animate
        height: height
        width: width
        left: max(0, full_left)
        top: max(0, full_top)
      , 200
)(jQuery)