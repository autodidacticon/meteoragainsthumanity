@Answers = new Mongo.Collection 'answers'
if Meteor.isServer
  Meteor.startup () ->
    @Answers._ensureIndex random: '2d'
