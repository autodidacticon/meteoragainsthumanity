#global router configuration includes basic layout (includes/layout.html), 
#loading (includes/loading.html), and notfound (application/notfound.html) templates
Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'

#helper function to redirect to context root when not logged in
requireLogin = ->
  if not Meteor.userId()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @redirect '/'
  else
    @next()

Router.onBeforeAction requireLogin, except: ['gamesList']

#root route controller, mapped to '/', returns the current list of logged in games
GamesListController = RouteController.extend
  template: 'gamesList'
  games: ->
    Games.find {}, sort: createDate: -1
  waitOn: ->
    [
      @gameSub = Meteor.subscribe 'games'
      @ansSub = Meteor.subscribe 'answers'
    ]
  waitOn: ->
    Meteor.subscribe 'games'
  data: ->
    games: @games()

Router.route '/',
  name: 'gamesList'
  controller: GamesListController

#game controller, directs browser to intended game state
GameController = RouteController.extend
  template: 'game'
  waitOn: ->
    #have to inject some redirect logic here because waitOn loads prior to
    #before hooks
    #https://github.com/iron-meteor/iron-router/issues/1010
    if not Meteor.userId()
      Router.go '/'
    [
      Meteor.subscribe('answers'),
      Meteor.subscribe('games', _id: @params._id)
    ]
  random: ->
#helper method that allows UI to trigger reactive computation from an event
#see gameItem.coffee
    r = Session.get('aRandom') ? Math.random()
    random: $near: [r, 0]
  aFindOptions: ->
    limit: 4
  cards: ->
    #this cursor will be refreshed when random is called
    Answers.find @random(), @aFindOptions()
  game: ->
    Games.findOne()
  data: ->
    cards: @cards()
    game: @game()

Router.route '/game/:_id',
  name: 'game'
  controller: GameController
  onBeforeAction: ->
    if not Games.findOne(_id: @params._id)
      Router.go '/'
      #game doesnt exist!
    else
      Meteor.call 'joinGame', @params._id, (e,r) ->
        if e
          return alert e.reason
      @next()

