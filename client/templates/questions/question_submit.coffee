Template.questionSubmit.events
  'submit form': (e) ->
    e.preventDefault()

    question = 
      url: $(e.target).find('[name=url]').val()
      title: $(e.target).find('[name=title]').val()

    Meteor.call 'questionInsert', question, (error, result) ->
      if error
        return alert error.reason
      if result.questionExists
        alert 'This link has already been questioned'
      Router.go 'questionPage', _id: result._id

