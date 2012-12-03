#= require ./curation

app = angular.module 'sandbox'

app.directive 'curationStep', ->
  scope: true
  template: """<div modal='showModal' modal-close='curation.reset()'>
                 <div ng-transclude>
               </div>"""
  transclude: true
  replace: true
  link: (scope, elem, attrs) ->
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
        scope.$eval attrs.modalOpen if attrs.modalOpen
        $.zenbox.show(elem)
      else
        $timeout (-> $.zenbox.close() if elem == $.zenbox.lock), 0
]
