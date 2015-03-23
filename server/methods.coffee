#Meteor methods, these server side functions control game state and obscure implementation
#details from the client

random = ->
  random: $near: [Math.random(), 0]

Meteor.methods
  joinGame: (gId) ->
    #called when user selects the 'join' button
    user = Meteor.user()
    game = Games.findOne _id: gId
    if not game.players.hasOwnProperty user.username
      #update only if player doesnt exist
      playerKey = 'players.' + user.username
      playerObj = {}
      playerObj[playerKey] = user
      #if rejoining an old game dont reset score
      if not game.scores.hasOwnProperty user.username
        playerObj['scores.' + user.username] = 0
      Games.update
        _id: gId
       ,
        $set: playerObj

  newGame: ->
    #called when the user selects the 'new game' button
    user = Meteor.user()
    gameObj = {}
    gameObj.createDate = new Date()
    #manually created objects to use mongodb's dot notation for subdocuments
    gameObj.players = {}
    gameObj.players[user.username] = user
    gameObj.scores = {}
    gameObj.scores[user.username] = 0
    #name game after random answer
    gameObj.name = Answers.findOne(random()).text
    #instantiate game with random question
    gameObj.question = Questions.findOne(random())
    #update usedQuestions list with question
    gameObj.usedQuestions = [gameObj.question._id]
    gameObj.answers = {}
    gameObj.voted = []
    #return new game id to caller
    _id = Games.insert gameObj

  play: (gId, aId) ->
    #called when user plays a card 
    user = Meteor.user()
    answers = {}
    answer = Answers.findOne _id: aId
    answer.username = user.username
    answers['answers.' + user.username] = answer
    Games.update
      _id: gId
     ,
    #updates answers subdocument
      $set: answers
    #updates usedAnswers list
      $addToSet: usedAnswers: aId

  vote: (username, gId) ->
    #called when user selects an answer
    user = Meteor.user()
    incScore = {}
    incScore['scores.' + username] = 1
    Games.update
      _id: gId
     ,
      $inc:
        #increment the score of the player with the answer
        incScore
      $addToSet:
        #add the caller to the voted list
        voted: user.username

