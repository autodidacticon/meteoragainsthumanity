Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'

Router.route '/questions/:_id',
  name: 'questionPage'
  data: ->
    Questions.findOne this.params._id

Router.route '/questions/:_id/edit',
  name: 'questionEdit'
  data: ->
    Questions.findOne this.params._id

Router.route '/submit', name: 'questionSubmit'

QuestionsListController = RouteController.extend
  template: 'questionsList'
  increment: 1
  limit: () ->
    parseInt(this.params.limit) || this.increment
  findOptions: () ->
    limit: this.limit()
  subscriptions: () ->
    this.questSub = Meteor.subscribe 'questions', this.findOptions()
  waitOn: () ->
    Meteor.subscribe 'questions', this.findOptions()
  questions: () ->
    return Questions.find {}, this.findOptions()
  data: () ->
    hasMore = this.questions().count() == this.limit()
    nextPath = this.route.path limit: this.limit() + this.increment

    questions: this.questions()
    ready: this.questSub.ready
    nextPath: if hasMore then nextPath else null

Router.route '/:limit?',
  name: 'questionsList'
  controller: QuestionsListController

requireLogin = ->
  if not Meteor.user()
    if Meteor.loggingIn()
      this.render this.loadingTemplate
    else
      this.render 'accessDenied'
  else
    this.next()

Router.onBeforeAction 'dataNotFound', only: 'questionPage'
Router.onBeforeAction requireLogin, only: 'questionSubmit'

