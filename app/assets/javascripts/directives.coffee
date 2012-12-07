#= require ./curation
#= require ./controllers

app = angular.module 'sandbox'

app.directive 'curationStep', ->
  scope: true
  template: "<div modal='showModal' modal-close='curation.reset()'>" +
              "<div ng-transclude></div>" +
            "</div>"
  transclude: true
  replace: false
  link: (scope, elem, attrs) ->
    scope.$watch 'curation.step', (value) ->
      if value == attrs.curationStep
        scope.showModal = true
      else
        scope.showModal = false

app.directive 'modal', ($timeout, $compile, $rootScope) ->
  compile: (tElement, tAttributes, transclude) ->
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
          elem.one 'zenbox-reset', ->
            elem.find('[ng-transclude]').first().empty()
            fn = $compile tElement.contents(), transclude
            fn(scope)
        else
          $timeout (-> $.zenbox.close() if elem == $.zenbox.lock), 0
