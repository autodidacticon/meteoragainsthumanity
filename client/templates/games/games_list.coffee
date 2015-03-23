Template.gamesList.events
  'click #newgame': (e) ->
    #create a new game with current user, call server side function 'newGame'
    Meteor.call 'newGame', (e,r) ->
      if e
        #abort and alert if error
        return alert e.reason
      #goto newly created game
      Router.go '/game/' + r

