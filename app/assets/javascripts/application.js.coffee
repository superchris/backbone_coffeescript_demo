window.TodoApp = {}

$ ->
  TodoApp.appView = new TodoApp.AppView collection: new TodoApp.TodoList
