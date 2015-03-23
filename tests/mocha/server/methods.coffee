MochaWeb?.testOnly ->
  testAnswer = text: 'testAnswer', _id: 'aId'
  testUser = username: 'testUser'

  describe 'methods', ->
    before ->
      Games.remove {}
      sinon.stub(Meteor, 'user').returns testUser
      sinon.stub(Answers, 'findOne').returns testAnswer
      random = sinon.stub().returns random: $near: [.5, 0]
      
    beforeEach ->
      Games.insert
        _id: 'testId'
        usedQuestions: []
        voted: []

    afterEach ->
      Games.remove {}

    describe 'joinGame', ->
      before ->
        sinon.stub(Games, 'findOne').returns players: {}, scores: {}
      it 'should add a user to a game', ->
        Meteor.call 'joinGame', 'testId'
        Games.findOne.restore()
        game = Games.findOne('testId')
        chai.assert.deepPropertyVal game, 'players.testUser.username', 'testUser'

    describe 'newGame', ->
      before ->
        sinon.stub(Questions, 'findOne').returns text: 'testQuestion', _id: 1
      it 'should create a new game', ->
        _id = 0
        Meteor.call 'newGame', (e,r) -> _id = r
        game = Games.findOne _id: _id
        chai.assert.deepPropertyVal game, 'players.testUser.username', 'testUser'
        chai.assert.deepPropertyVal game, 'scores.testUser', 0
        chai.assert.propertyVal game, 'name', 'testAnswer'
        chai.assert.deepPropertyVal game, 'question.text','testQuestion'
        chai.assert.include game.usedQuestions, 1, 'usedQuestions contains current question id'
        Questions.findOne.restore()
        chai.assert.property game, 'answers'
        chai.assert.isArray game.voted

    describe 'play', ->
      it 'should add the players answer to the answer set', ->
        Meteor.call 'play', 'testId', 'aId'
        game = Games.findOne _id: 'testId'
        chai.assert.deepEqual game.answers.testUser, testAnswer

    describe 'vote', ->
      it 'should add the username to the voted list and increment score', ->
        Meteor.call 'vote', 'testUser', 'testId'
        game = Games.findOne _id: 'testId'
        chai.assert.equal game.scores.testUser, 1
        chai.assert.includeMembers game.voted, ['testUser']
