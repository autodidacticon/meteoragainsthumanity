@Questions = new Mongo.Collection 'questions'
if Meteor.isServer
  Meteor.startup () ->
    @Questions._ensureIndex random: '2d'
