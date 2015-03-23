Template.game_item.events
  'click #newCards': (e) ->
#update the Session triggering reactive computation that updates cards
    Session.set 'aRandom', Math.random()
    $('#play').addClass('disabled')
  'click #play': (e) ->
#call server side method to play card / mutate game state
    gId = Template.parentData().game._id
    aId = $('input:checked').val()
    Meteor.call 'play', gId, aId, (e,r) ->
      if e
        return alert e.reason
  'click input': (e) ->
#activate play button when answer has been selected
    $('#play').removeClass('disabled')
