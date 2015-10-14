update = (type) ->
  verb = 'GET'
  route = 'get'
  document.getElementById('increment').disabled = cur >= cap
  document.getElementById('decrement').disabled = cur <= 0
  guess = cur
  if type != 0
    verb = 'POST'
    if type > 0
      route = 'increment'
      guess++
      document.getElementById('count').textContent = cur + 1
      document.getElementById('decrement').disabled = false
      document.getElementById('increment').disabled = cur + 1 >= cap
    else
      route = 'decrement'
      guess--
      document.getElementById('count').textContent = cur - 1
      document.getElementById('increment').disabled = false
      document.getElementById('decrement').disabled = cur - 1 <= 0
  xmlhttp = new XMLHttpRequest

  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState == 4 and xmlhttp.status == 200
      response = JSON.parse(xmlhttp.responseText)
      console.log response.count
      cap = parseInt(response.cap)
      cur = parseInt(response.count)
      if guess != response.count
        if verb != 'GET'
          document.getElementById('count').textContent = response.count
        else
          guess = response.count
      else
        document.getElementById('count').textContent = response.count
    return

  xmlhttp.open verb, eventid + '/' + route
  xmlhttp.setRequestHeader 'Content-Type', 'application/json;charset=UTF-8'
  xmlhttp.send()
  return

refresh = ->
  setTimeout (->
    update 0
    refresh()
    return
  ), 1000
  return

document.addEventListener 'DOMContentLoaded', ->
  userAgent = window.navigator.userAgent
  if userAgent.match(/iPad/i) or userAgent.match(/iPhone/i)
    if confirm('Would you like to open this event in the iOS app?')
      document.location.href = 'clickityclack://' + eventid

  document.getElementById('increment').onclick = ->
    update 1
    return

  document.getElementById('label').onclick = ->
    update 0
    return

  document.getElementById('decrement').onclick = ->
    update -1
    return

  refresh()
  update 0
  return
guess = undefined
cap = undefined
cur = undefined
