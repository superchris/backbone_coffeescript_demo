describe "Todo", ->
  todo = null
  ajaxCall = (param) -> jQuery.ajax.mostRecentCall.args[0][param]

  beforeEach ->
    todo = new TodoApp.Todo
    todos = new TodoApp.TodoList [todo]

  it "should initialize with empty content", ->
    expect(todo.get "content").toEqual "empty todo..."

  it "should initialize as not done", ->
    expect(todo.get "done").toBeFalsy()

  it "should save after toggle", ->
    spyOn jQuery, "ajax"
    todo.toggle()
    expect(ajaxCall "url").toEqual "/todos"
    expect(todo.get "done").toBeTruthy()

describe "TodoList", ->
  attributes = [
    content: "First"
    done: true
  ,
    content: "Second"
  ]
  todos = null

  beforeEach ->
    todos = new TodoApp.TodoList attributes

  it "should return done todos", ->
    expect(_.invoke todos.done(), "toJSON").toEqual [attributes[0]]

  it "should return remaining todos", ->
    expect(_.invoke todos.remaining(), "toJSON").toEqual [attributes[1]]
