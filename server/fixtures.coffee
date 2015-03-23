if Questions.find().count() is 0
  cards = JSON.parse Assets.getText 'cards.json'
  _.each cards, (e,i,l)->
    e.random = [Math.random(), 0]
    if e.cardType == 'Q' and e.numAnswers == 1
      #add underscore 
      e.text += ' _' if e.text.indexOf('_') == -1
      Questions.insert e
    else if e.cardType == 'A'
      Answers.insert e

if Meteor.users.find().count() == 0
    Accounts.createUser
        username: 'bigburton'
        email: 'email'
        password: 'asdfasdf'
