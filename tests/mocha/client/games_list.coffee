MochaWeb?.testOnly ->
  describe 'templates', ->
    before ->
      _id = Accounts.createUser
        username: 'testUser'
        password: 'password'

    describe 'games_list', ->
      before ->
        spy = sinon.spy Router, 'go'
      after ->
        Router.go.restore()

      it 'should show New Game button when signed in', ->
        Meteor.loginWithPassword 'testUser', 'password', ->
          expect($('#newgame')[0]).to.exist

      it 'should not show the "New Game" button when not signed in',  ->
        expect($('#newgame')[0]).to.not.exist

      it 'should show current games',  ->
        Meteor.loginWithPassword 'testUser', 'password', ->
          testGame =
            _id: 'testId'
            players:
              testUser: Meteor.user()
          Games.insert testGame
          expect($('.game_preview').length).to.eql 1

      it 'should call Method "newGame" when "New Game" button is selected',  ->
        Meteor.loginWithPassword 'testUser', 'password', ->
          $('#newgame').click()
          expect(spy.called).to.be.true

    describe 'game_preview', ->
      before ->
        spy = sinon.spy Router, 'go'
      after ->
        Router.go.restore()

      it 'should show a "Join Game" button when signed in',  ->
        Meteor.loginWithPassword 'testUser', 'password', ->
          expect($('.join.btn')[0]).to.exist

      it 'should not show a "Join Game" button when not signed in',  ->
        expect($('.join.btn')[0]).to.not.exist

      it 'should open a game when "Join Game" is selected', ->
        testGame =
          _id: 'testId'
          players:
            testUser: Meteor.user()
        Games.insert testGame
        Meteor.loginWithPassword 'testUser', 'password', ->
          $('#newgame').click()
          expect(spy.calledWith '/game/testId').to.be.true

