Template.registerHelper 'keyVals',
  (obj) ->
    key: k, value: v for k, v of obj

Template.registerHelper 'eq',
  (v1, v2) ->
    v1 == v2
