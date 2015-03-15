Meteor.publish 'questions', (options) ->
  Questions.find {}, options
Meteor.publish 'answers', (options) ->
  Answers.find {}, options

