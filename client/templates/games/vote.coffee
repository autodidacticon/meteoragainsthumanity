Template.vote.helpers
  answers: ->
#helper to combine current question with submitted answers
    game = Template.parentData().game
    _.map game.answers,
      (e) ->
        e.text = game.question.text.replace '_', '<b>'+ e.text.replace '.', '' + '</b>'
        e
  numPlayers: ->
#helper to count the number of current players
    game = Template.parentData().game
    _.size game.players
  numAnswers: ->
#helper to count the number of current answers
    game = Template.parentData().game
    _.size game.answers
  voted: ->
#helper to determine if current user has voted
    _.contains Template.parentData().game.voted, Meteor.user().username

Template.vote.events
  'click #vote': (e) ->
#call server side method to vote on answer, mutate game state
    return if $('#vote').hasClass('disabled')
    username = $('input:checked').val()
    gId = Template.parentData().game._id
    Meteor.call 'vote', username, gId, (e,r) ->
      if e
        return alert e.reason
      Session.set 'aRandom', Math.random()
      Session.set 'qRandom', Math.random()

  'click input': (e) ->
    $('.btn.disabled').removeClass('disabled')
