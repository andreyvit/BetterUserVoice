element = (tagName, className, children...) ->
  el = document.createElement(tagName)
  el.className = className
  for child in children
    if typeof child is "object" and child.constructor is Object
      # attributes
      for own k, v of child
        el.setAttribute k, v
    else
      # child node
      child = document.createTextNode(child)  if typeof child is "string"
      el.appendChild child

  el

extendGearMenu = ->
  unless document.querySelector("button.gear + menu > .better-uservoice-item")
    menu = document.querySelector("button.gear + menu")
    menu.appendChild element("li", "menu-separator better-uservoice-item")
    menu.appendChild element("li", "menu-item better-uservoice-item better-uservoice-mark-as-spam", element("a",
      href: "#"
    , "Mark as spam"))

getSelectedTicketElements = ->
  Array::slice.call document.querySelectorAll ".better-uservoice-selected-ticket"

getSelectedTicketIds = ->
  getSelectedTicketElements().map (el) -> el.id.replace(/^uv_search_result_/, '')


getSelectedTicketCount = ->
  getSelectedTicketElements().length

updateGearMenu = ->
  extendGearMenu()
  count = getSelectedTicketCount()
  document.querySelector(".better-uservoice-mark-as-spam a").innerText = "Mark As Spam (#{count})"

closest = (el, className) ->
  while el
    return el  if el.classList.contains(className)
    el = el.parentElement
  null

ticketSelectorClicked = (e, el) ->
  console.log "click!!"
  e.preventDefault()
  e.stopPropagation()
  el.classList.toggle "better-uservoice-selected-ticket"
  updateGearMenu()

ticketMarkAsSpamClicked = (e, el) ->
  e.preventDefault()

  results = []

  await
    for ticketId in getSelectedTicketIds()
      do (ticketId) ->
        console.log "Marking as spam: #{ticketId}",

        # Content-Type: application/x-www-form-urlencoded
        $.ajax
          url: "/admin/tickets/#{ticketId}/spam"
          type: "PUT"
          data: {}
          dataType: "json"
          headers:
            'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
          error: (xhr, textStatus, errorThrown) ->
            results.push "• Error marking as spam: #{ticketId}",
          success: (data, textStatus, xhr) ->
            results.push "• Marked as spam: #{ticketId}",
          complete: defer(xhr, textStatus)

  alert "Done.\n\n" + results.join("\n")


document.addEventListener "click", ((e) ->
  el = undefined
  if el = closest(e.target, "ticket-search-result")
    baseX = $("#uv-admin-search-results-container").offset().left
    w = 20
    ticketSelectorClicked e, el  if e.pageX < baseX + w
  else ticketMarkAsSpamClicked e, el  if el.classList.contains("better-uservoice-mark-as-spam")  if el = closest(e.target, "better-uservoice-item")
), true
