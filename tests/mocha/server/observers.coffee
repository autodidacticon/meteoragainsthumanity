MochaWeb?.testOnly ->
  describe 'observers', ->
    testAnswer = text: 'testAnswer', _id: 'aId'
    testUser = username: 'testUser'
    testUser2 = username: 'testUser2'
    testGame =
      _id: 'testId'
      players:
        testuser: testUser
        testuser2: testUser2
      answers:
        testuser: testAnswer
      voted: ['testuser']
      usedQuestions: []

    testGame2 =
      _id: 'testId2'
      players:
        testuser: testUser
        testuser2: testUser2
      answers:
        testuser: testAnswer
      voted: ['testuser']
      usedQuestions: []

    describe 'offlinePlayers', ->
      before ->
        Meteor.users.remove {}
        Accounts.createUser testUser
        Games.insert testGame

      after ->
        Games.remove _id: 'testId'

      it 'should remove inactive players from games', ->
        Meteor.users.update testUser, $set: 'status.online' : false
        game = Games.findOne _id: 'testId'
        chai.assert.notProperty game.players, 'testUser'
        chai.assert.notDeepProperty game, 'answers.testUser'
        chai.assert.notInclude game.voted, 'testUser'
    
    describe 'emptyGames', ->
      before ->
        Games.insert testGame2

      after ->
        Games.remove _id: 'testId2'
        
      it 'should remove empty games', ->
        set = {}
        set['players'] = {}
        Games.update
          _id: 'testId2'
         ,
          $set:
            players: {}
        #wait for observer to fire
        Meteor._sleepForMs 10
        count = Games.find(_id: 'testId2').count()
        chai.assert.equal(count, 0)

    describe 'voted', ->
      before ->
        Games.insert testGame
        sinon.stub(Questions, 'findOne').returns text: 'testQuestion', _id: 1

      after ->
        Games.remove _id: 'testId'
        
      it 'should update games with complete voting', ->
        Games.update
          _id: 'testId'
         ,
          $addToSet:
            voted: 'testUser2'
        #wait for observer to fire
        Meteor._sleepForMs 10
        game = Games.findOne _id: 'testId'
        chai.assert.lengthOf game.voted, 0
        chai.assert.isTrue _.isEmpty game.answers
        chai.assert.deepPropertyVal game, 'question.text', 'testQuestion'


