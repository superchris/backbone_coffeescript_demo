Overview
========

This is sample Rails application that demonstrates usage of

* [Backbone.js](http://documentcloud.github.com/backbone/)
* [CoffeeScript](http://jashkenas.github.com/coffee-script/)
* [Jasmine](http://pivotal.github.com/jasmine/)
* Rails 3.1 asset pipeline

This code is from the demo used during [RailsWayCon 2011](http://railswaycon.com/2011/sessions#session-17838) conference presentation [Rails-like JavaScript using CoffeeScript, Backbone.js and Jasmine](http://www.slideshare.net/rsim/railslike-javascript-using-coffeescript-backbonejs-and-jasmine-8196890).
Source code is based on original [Todos application](http://documentcloud.github.com/backbone/docs/todos.html) by [Jérôme Gravel-Niquet](https://github.com/jeromegn).

In this fork, I've moved it around and upgraded it to rails 3.1

Running application
===================

Install gems, run migrations and start application with

    bundle install
    rake db:migrate
    rails server

And then visit `http://localhost:3000`.

Running tests
=============

Start the rails server and visit `http://localhost:3000/SpecRunner.html` to execute Jasmine tests.

Application source code
=======================

Backbone.js models and views written in CoffeeScript are located in `app/assets/javascripts` directory and Jasmine tests are located in `spec/coffeescripts` directory.
