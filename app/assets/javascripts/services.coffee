#= require ./curation

app = angular.module 'sandbox'

class Curation
  constructor: ->
    @reset()

  reset: =>
    @step = null
    @history = []
    @imageUrls = []
    @board = {}
    @learning =
      url: ""
      imageUrl: ""

  goToStep: (step, addToHistory = true) =>
    @history.push step if addToHistory
    @step = step

  goBack: =>
    return unless @history.length > 1
    @history.pop()
    lastStep = @history[@history.length - 1]
    @goToStep(lastStep, false)

app.factory 'curation', -> new Curation

app.factory 'flickr', ($http) ->
  (tag, cb) ->
    url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3a460bfe22c136f3ad196f1e64846d75&tags=#{tag}&per_page=10&format=json&jsoncallback=JSON_CALLBACK"
    response = $http.jsonp url
    response.success (data) ->
      cb null, data
    response.error (data) ->
      cb new Error(data)
