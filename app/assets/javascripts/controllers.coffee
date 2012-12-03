#= require ./curation

app = angular.module 'sandbox'

app.controller 'CurationController', ($scope, curation) ->
  $scope.curation = curation
  window.curation = curation
  $scope.getCuration = -> curation
  $scope.busy = false

  $scope.startCuration = ->
    curation.goToStep 'introduction'

  $scope.back = ->
    return if $scope.busy
    curation.goBack()

app.controller 'CurationIntroductionController', ($scope, curation) ->
  $scope.chooseAddUrl = -> curation.goToStep 'url'
  $scope.chooseUpload = -> curation.goToStep 'upload'
  $scope.chooseAddBoard = -> curation.goToStep 'board'

app.controller 'CurationUrlController', ($scope, curation, flickr) ->
  $scope.changeUrl = ->
    curation.learning.url ?= "" # never let it be completely unset
    curation.learning.imageUrl = ""

  $scope.next = ->
    $scope.busy = true
    flickr 'kitten', (err, data) ->
      if err?
        curation.reset()
        curation.error = err
      else
        curation.imageUrls = data.photos.photo.map (photo) ->
          farm   = photo.farm
          server = photo.server
          id     = photo.id
          secret = photo.secret
          "http://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}_m.jpg"
        curation.goToStep 'image'
        $scope.busy = false

app.controller 'CurationImageController', ($scope, curation) ->
  $scope.select = (image) ->
    curation.learning.imageUrl = image
  $scope.selected = (image) ->
    curation.learning.imageUrl == image

app.controller 'CurationUploadController', ($scope, curation) ->
app.controller 'CurationBoardController', ($scope, curation) ->
