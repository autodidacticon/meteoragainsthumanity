Template.game_preview.events
  'click .join': (e) ->
    #call server side method to join game
    gId = Template.currentData()._id
    #goto game after method completes
    Router.go '/game/' + gId
