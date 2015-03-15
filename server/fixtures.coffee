if Questions.find().count() is 0
  cards = JSON.parse Assets.getText 'cards.json'
  _.each cards, (e,i,l)->
    if e.cardType == 'Q'
      Questions.insert e
    else
      Answers.insert e
