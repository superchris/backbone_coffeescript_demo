# Todo Model
# ----------

# Our basic **Todo** model has `content`, `order`, and `done` attributes.
class TodoApp.Todo extends Backbone.Model

  # If you don't provide a todo, one will be provided for you.
  EMPTY: "empty todo..."

  # Ensure that each todo created has `content`.
  initialize: ->
    unless @get "content"
      @set content: @EMPTY

  # Toggle the `done` state of this todo item.
  toggle: ->
    @save done: not @get "done"


# Todo Collection
# ---------------
# 
# The collection of todos is backed by TodosController
# 
class TodoApp.TodoList extends Backbone.Collection

  # Reference to this collection's model.
  model: TodoApp.Todo

  # Save all of the todo items under the `"todos"` namespace.
  url: '/todos'

  # Filter down the list of all todo items that are finished.
  done: ->
    @filter (todo) -> todo.get 'done'

  # Filter down the list to only todo items that are still not finished.
  remaining: ->
    @without this.done()...

  # We keep the Todos in sequential order, despite being saved by unordered
  # GUID in the database. This generates the next order number for new items.
  nextOrder: ->
    if @length then @last().get('order') + 1 else 1

  # Todos are sorted by their original insertion order.
  comparator: (todo) ->
    todo.get 'order'
