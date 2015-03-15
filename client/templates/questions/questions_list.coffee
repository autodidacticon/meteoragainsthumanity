Template.questionsList.helpers
  answers: (limit)->
    Answers.find {}, limit: limit*4