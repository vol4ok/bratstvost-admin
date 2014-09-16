configure = ($routeProvider, $locationProvider, $httpProvider) ->
  moment.lang('ru')

  $locationProvider
    .html5Mode(yes)

  $routeProvider
    .when "/",
      templateUrl: "events-view"
      controller: "EventEditorCtrl"
    .when "/events",
      templateUrl: "events-view"
      controller: "EventEditorCtrl"
    .when "/news",
      templateUrl: "news-view"
      controller: "NewsEditorCtrl"
    .when "/notices",
      templateUrl: "notices-view"
      controller: "NoticeEditorCtrl"
    .when "/members",
      templateUrl: "members-view"
      controller: "MembersCtrl"
    .when "/videos",
      templateUrl: "videos-view"
      controller: "VideoEditorCtrl"


main = () ->

angular.module('appLibs', [])

angular.module('adminApp.filters', []).filter('isShowed', ->
  return (published) ->
    if published
      return 'Да'
    else
      return 'Нет'
)

angular.module('adminApp', [
    'ngSanitize'
    'ngRoute'
    'core'
    'appLibs'
    'ui.date',
    'ui.select2'
    'uuid4'
    'ui.codemirror'
    'ui.bootstrap.tpls'
    'ui.bootstrap'
    'adminApp.filters'
    'ui.tinymce'
  ])
  .config([ '$routeProvider', '$locationProvider', '$httpProvider', configure ])
  .run(["$core", main])