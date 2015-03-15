@Questions = new Mongo.Collection 'questions'

@Questions.allow
  update: (userId, doc) -> ownsDocument userId, doc
  remove: (userId, doc) -> ownsDocument userId, doc

@Questions.deny
  update: (userId, question, fieldNames) ->
    _.without(fieldNames, 'question', 'title').length > 0

Meteor.methods
  questionInsert: (questionAttributes) ->
    check Meteor.userId(), String
    check questionAttributes,
      title: String,
      url: String
    
    duplicateQuestion = Questions.findOne url: questionAttributes.question
    if duplicateQuestion
      return questionExists: true, _id: duplicateQuestion._id

    user = Meteor.user()
    question = _.extend questionAttributes,
      userId: user._id,
      author: user.username,
      submitted: new Date()

    questionId = Questions.insert question
    
    _id: questionId
