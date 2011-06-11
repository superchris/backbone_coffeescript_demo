# Compile and store template function from DOM element with specified selector
TodoApp.template = (selector) ->
  template = null
  ->
    template ?= Handlebars.compile(if selector.charAt(0) == "#" then $(selector).html() else selector)
    template.apply this, arguments

Handlebars.registerHelper 'debug', (ctx) ->
  context = typeof ctx == "function" ? ctx.call this : ctx
  console.log context


Handlebars.registerHelper 'pluralize', (count, word, fn) ->
  if count != 1 then word+"s" else word
