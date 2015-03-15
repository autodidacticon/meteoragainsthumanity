Template.questionEdit.events
  'submit form': (e) ->
    e.preventDefault()

    currentQuestionId = this._id

    questionProperties =
      question: $(e.target).find('[name=question]').val()

    Questions.update currentQuestionId, $set: questionProperties, (error) ->
      if error
        alert error.reason
      else
        Router.go 'questionPage', _id: currentQuestionId

  'click .delete': (e) ->
    e.preventDefault()

    if confirm 'Delete this question?'
      currentQuestionId = this._id
      Questions.remove currentQuestionId
      Router.go 'questionsList'

  'change input.answer': (e) ->
    this.correct.push $(e.target)



Template.questionEdit.helpers
  isCorrect: -> false

