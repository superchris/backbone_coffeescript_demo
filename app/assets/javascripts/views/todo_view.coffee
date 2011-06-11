# Todo Item View
# --------------

# The DOM element for a todo item...
class TodoApp.TodoView extends Backbone.View
  # ... is a list tag.
  tagName:  "li"

  # Cache the template function for a single item.
  template: TodoApp.template '#item-template'

  # The DOM events specific to an item.
  events:
    "click .check"              : "toggleDone"
    "dblclick div.todo-content" : "edit"
    "click span.todo-destroy"   : "destroy"
    "keypress .todo-input"      : "updateOnEnter"

  # The TodoView listens for changes to its model, re-rendering. Since there's
  # a one-to-one correspondence between a **Todo** and a **TodoView** in this
  # app, we set a direct reference on the model for convenience.
  initialize: ->
    _.bindAll this, 'render', 'close'
    @model.bind 'change', @render
    @model.bind 'destroy', => @remove()

  # Re-render the contents of the todo item.
  render: ->
    $(@el).html @template @model.toJSON()
    @setContent()
    this

  # To avoid XSS (not that it would be harmful in this particular app),
  # we use `jQuery.text` to set the contents of the todo item.
  setContent: ->
    content = @model.get 'content'
    @$('.todo-content').text content
    @input = @$('.todo-input')
    @input.blur @close
    @input.val content

  # Toggle the `"done"` state of the model.
  toggleDone: ->
    @model.toggle()

  # Switch this view into `"editing"` mode, displaying the input field.
  edit: ->
    $(@el).addClass "editing"
    @input.focus()

  # Close the `"editing"` mode, saving changes to the todo.
  close: ->
    @model.save content: @input.val()
    $(@el).removeClass "editing"

  # If you hit `enter`, we're through editing the item.
  updateOnEnter: (e) ->
    @close() if e.keyCode == 13

  # Destroy the model.
  destroy: ->
    @model.destroy()


# The Application
# ---------------

# Our overall **AppView** is the top-level piece of UI.
class TodoApp.AppView extends Backbone.View

  # Instead of generating a new element, bind to the existing skeleton of
  # the App already present in the HTML.
  el: "#todoapp"

  # Our template for the line of statistics at the bottom of the app.
  statsTemplate: TodoApp.template '#stats-template'

  # Delegated events for creating new items, and clearing completed ones.
  events:
    "keypress #new-todo"  : "createOnEnter"
    "keyup #new-todo"     : "showTooltip"
    "click .todo-clear a" : "clearCompleted"

  # At initialization we bind to the relevant events on the `Todos`
  # collection, when items are added or changed. Kick things off by
  # loading any preexisting todos that might be saved
  initialize: ->
    _.bindAll this, 'addOne', 'addAll', 'renderStats'

    @input = @$("#new-todo")

    @collection.bind 'add',     @addOne
    @collection.bind 'refresh', @addAll
    @collection.bind 'all',     @renderStats

    @collection.fetch()

  # Re-rendering the App just means refreshing the statistics -- the rest
  # of the app doesn't change.
  renderStats: ->
    @$('#todo-stats').html @statsTemplate
      total:      @collection.length
      done:       @collection.done().length
      remaining:  @collection.remaining().length

  # Add a single todo item to the list by creating a view for it, and
  # appending its element to the `<ul>`.
  addOne: (todo) ->
    view = new TodoApp.TodoView model: todo
    @$("#todo-list").append view.render().el

  # Add all items in the collection at once.
  addAll: ->
    @collection.each @addOne

  # Generate the attributes for a new Todo item.
  newAttributes: ->
    content: @input.val()
    order:   @collection.nextOrder()
    done:    false

  # If you hit return in the main input field, create new **Todo** model,
  # persisting it to server.
  createOnEnter: (e) ->
    if e.keyCode == 13
      @collection.create @newAttributes()
      @input.val ''

  # Clear all done todo items, destroying their views and models.
  clearCompleted: ->
    todo.destroy() for todo in @collection.done()
    false

  # Lazily show the tooltip that tells you to press `enter` to save
  # a new todo item, after one second.
  showTooltip: (e) ->
    tooltip = @$(".ui-tooltip-top")
    val = @input.val()
    tooltip.fadeOut()
    clearTimeout @tooltipTimeout if @tooltipTimeout
    unless val == '' or val == @input.attr 'placeholder'
      @tooltipTimeout = _.delay ->
        tooltip.show().fadeIn()
      , 1000
