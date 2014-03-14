configure = ($routeProvider, $locationProvider, $httpProvider) ->
  moment.lang('ru')

  $locationProvider
    .html5Mode(yes)

  $routeProvider
    .when "/",
      templateUrl: "index-view"
    .when "/events",
      templateUrl: "events-view"
    .when "/events2",
      templateUrl: "events2-view"
      controller: "EventEditor2Ctrl"
    .when "/news",
      templateUrl: "news-view"
    .when "/notices",
      templateUrl: "notices-view"

main = () ->

angular.module('appLibs', [])

angular.module('adminApp.ctrl', [
  "EventEditorCtrl"
  "NoticeEditorCtrl"
  "NewsEditorCtrl"
])

angular.module('adminApp.div', [

])

angular.module('adminApp.svc', [
  "EventsSvc"
  "NoticeSvc"
  "NewsSvc"
])

angular.module('adminApp', [
    'ngSanitize'
    'ngRoute'
    'core'
    'appLibs'
    'ui.date',
    'ui.select2'
    'uuid4'
    'ui.codemirror'
    'adminApp.ctrl'
    'adminApp.svc'
  ])
  .config([ '$routeProvider', '$locationProvider', '$httpProvider', configure ])
  .run(["$core", main])