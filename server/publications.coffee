Meteor.publish 'answers', (query = {}, options) ->
  Answers.find query, options

Meteor.publish 'games', (query = {}, options) ->
  Games.find query, options
