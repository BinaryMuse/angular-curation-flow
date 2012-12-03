app = angular.module 'sandbox', ['ngResource']

class Curation
  constructor: ->
    @reset()

  reset: =>
    @step = null
    @history = []
    @creatingLearning = false
    @creatingBoard = false
    @board = {}
    @learning = {}

  goToStep: (step, addToHistory = true) =>
    @history.push step if addToHistory
    @step = step

  goBack: =>
    return unless @history.length > 1
    @history.pop()
    lastStep = @history[@history.length - 1]
    @goToStep(lastStep, false)

app.factory 'curation', -> new Curation

app.controller 'CurationController', ($scope, curation) ->
  $scope.curation = curation

  $scope.startCuration = ->
    curation.goToStep 'introduction'
  $scope.back = ->
    curation.goBack()

app.controller 'CurationIntroductionController', ($scope, curation) ->
  $scope.chooseAddUrl = -> curation.goToStep 'url'
  $scope.chooseUpload = -> curation.goToStep 'upload'
  $scope.chooseAddBoard = -> curation.goToStep 'board'

app.controller 'CurationUrlController', ($scope, curation) ->
  $scope.next = ->
    # TODO: make this analyze the URL
    curation.reset()

app.controller 'CurationUploadController', ($scope, curation) ->

app.directive 'curationStep', ->
  scope: true
  template: """<div modal='showModal' modal-close='close()'>
                 <div ng-transclude>
              </div>"""
  transclude: true
  replace: true
  link: (scope, elem, attrs) ->
    scope.close = ->
      scope.curation.reset()
    scope.$watch 'curation.step', (value) ->
      if value == attrs.curationStep
        scope.showModal = true
      else
        scope.showModal = false

app.directive 'modal', ['$timeout', ($timeout) ->
  (scope, elem, attrs) ->
    scope.$watch attrs.modal, (value) ->
      if !!value
        if attrs.modalClose
          $(document).one 'zenbox-closed', ->
            return unless $.zenbox.lock == elem
            scope.$apply attrs.modalClose
        $.zenbox.lock = elem
        $.zenbox.show(elem)
      else
        $timeout (-> $.zenbox.close() if elem == $.zenbox.lock), 0
]
