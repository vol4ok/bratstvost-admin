configure = ($routeProvider, $locationProvider, $httpProvider, datepickerConfig, datepickerPopupConfig) ->
  moment.lang('ru')

  $locationProvider
    .html5Mode({
      enabled: true,
      requireBase: false
    })

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

  datepickerConfig.startingDay = 1;
  datepickerConfig.showWeeks = false;

#  datepickerPopupConfig.datepickerPopup = "dd-MM-yyyy";
  datepickerPopupConfig.currentText = "Сегодня";
  datepickerPopupConfig.clearText = "Очистить";
  datepickerPopupConfig.closeText = "Закрыть";

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
    'ui.select2'
    'uuid4'
    'ui.bootstrap'
    'adminApp.filters'
    'summernote'
  ]).config([ '$routeProvider', '$locationProvider', '$httpProvider', 'datepickerConfig', 'datepickerPopupConfig', configure ])
  .run ($rootScope) ->
    # configure global functions here
    # set up ui.bootstrap.datepicker

    $rootScope.openDatepicker = (datepicker, $event) ->
      $event.preventDefault()
      $event.stopPropagation()
      datepicker.isOpen = true

