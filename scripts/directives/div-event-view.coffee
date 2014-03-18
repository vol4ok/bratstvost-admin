angular.module("coreLibs").directive "eventview", () ->
  restrict: "E"
  replace: yes
  scope: {
    event: "="
  }
  templateUrl: "eventview-template"
  link: (scope, element, attrs) ->
    scope.expanded = true
    scope.$watch "event", () ->
      return unless event || event.date
      mdate = moment(scope.event.date)
      scope.event._date = mdate.toDate()
      scope.event.month = mdate.format("MMM")
      scope.event.day   = mdate.format("D")
      scope.event.isNew = false
