#observers listen to database queries

#update games as users go offline
offlinePlayers = Meteor.users.find 'status.online': false

oHandle = offlinePlayers.observe
  added: (user) ->
    playerKey = {}
    playerKey['players.' + user.username] = $exists: true
    unset = {}
    unset['players.' + user.username] = ''
    unset['answers.' + user.username] = ''
    Games.update playerKey,
      $unset: unset
      $pullAll:
        voted: [user.username]

#remove games with no players
emptyGames = Games.find players: { }

eHandle = emptyGames.observe
  added: (game) ->
    if _.isEmpty game.players
      Games.remove _id: game._id

#listen for votes
voted = Games.find {}

vHandle = voted.observeChanges
  changed: (_id, fields) ->
    g = Games.findOne _id: _id
    if fields.voted? and g.voted.length >= _.size g.players
      newQuestion = Questions.findOne
        random:
          $near: [Math.random(), 0]
        _id:
          $nin: g.usedQuestions
      Games.update
        _id: _id
       ,
        $set:
          voted: [],
          answers: {}
          question: newQuestion

