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
    url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=82ecacaf73ea3db7bb19c6aab867f265&tags=#{tag}&per_page=20&format=json&jsoncallback=JSON_CALLBACK"
    response = $http.jsonp url
    response.success (data) ->
      imageUrls = data.photos.photo.map (photo) ->
        farm   = photo.farm
        server = photo.server
        id     = photo.id
        secret = photo.secret
        "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}_s.jpg"
      cb null, imageUrls
    response.error (data) ->
      cb new Error(data)
