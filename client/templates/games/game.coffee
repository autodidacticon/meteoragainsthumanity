Template.game.helpers
  answered: ->
#helper to determine if current user has answered
    _.has @game.answers, Meteor.user().username

