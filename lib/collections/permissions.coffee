#check that the userId specified owns the document
@ownsDocument = (userId, doc) ->
  doc and doc.userId == userId
