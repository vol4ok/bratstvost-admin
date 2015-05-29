angular.module('appLibs').controller "EventEditorCtrl", ($scope, $eventsSvc, $core, $modal) ->

  $eventsSvc.all().then (events) ->
    $scope.events = events

  alerts = $scope.alerts = []
  $scope.isHiden = (event) ->
    if event.published and new Date(event.date) > new Date()
      return true
    else if $scope.activeHiden
      return true
    else
      return false

  $scope.onDelete = (index, event) ->
    console.log("onDelete", index, event)
    if confirm("Удалить событие?")
      _.remove $scope.events, (evt) -> evt._id == event._id
      $eventsSvc.delete(event._id).then ->
        alerts.push({type: "danger", msg: "Удалено!"})

  $scope.onEditOrAdd = (index, event) ->
    editMode = if event then true else false
    console.log("onEditOrAdd", index, event)

    modalInstance = $modal.open
      templateUrl: 'eventModalContent.html'
      controller: ($scope, $modalInstance) ->

        $scope.datepicker = { isOpen: false }

        if editMode
          $scope.newEvent = angular.copy(event)
        else
          $scope.newEvent = {
            type:          "event"
            date:          moment().toISOString()
            title:         ""
            body:          ""
            event_time:    ""
            event_place:   ""
            meeting_time:  ""
            meeting_place: ""
            organizer:     "брат Сергий"
            phone:         "8 (029) 373-72-50"
            cost:          ""
            published:     true
            updated:       moment().toISOString()
            created:       moment().toISOString()
          }

        getEventObj = (newEvent) ->
          event = angular.copy(newEvent)
          event.body = newEvent.body.trim()
          event.date = newEvent.date
          event.updated = new Date
          if newEvent.cakes
            event.custom_field = [] unless event.custom_field
            if event.custom_field.length == 0
              event.custom_field.push
                icon: "cake-1"
                term: "Выпечка"
                desc: newEvent.cakes

          return event

        $scope.eventJSON = JSON.stringify(getEventObj($scope.newEvent), null, "  ")

        $scope.$watchCollection "newEvent", ->
          $scope.eventObj = getEventObj($scope.newEvent)
          $scope.eventJSON = JSON.stringify($scope.eventObj, null, "  ")

        $scope.save = ->
          result = getEventObj($scope.newEvent)
          #  fix timezone: https://github.com/angular-ui/bootstrap/issues/2072
          if result.date && result.date instanceof Date
            result.date.setHours(0)
            result.date = new Date(result.date.getTime() + Math.abs(result.date.getTimezoneOffset()) * 60000)
          console.log "SAVE EVENT", result
          $modalInstance.close(result)

        $scope.cancel = ->
          $modalInstance.dismiss('cancel')

        setTimeout( (() -> angular.element('#new-event-title').trigger('focus')), 100 )

    .result.then (event) ->
      if editMode
        index = _.findIndex $scope.events, (evt) ->
          return evt._id == event._id
        console.log("CHECK", index, $scope.events, $scope.events[index], event)
        $scope.events[index] = event
        $eventsSvc.save(event._id, event).then ->
          alerts.push({type: "warning", msg: "Обновлено!"})
      else
        $scope.events.push(event)
        $eventsSvc.create(event).then (d) ->
          event._id = d._id
          alerts.push({type: "success", msg: "Добавлено!"})
    , ->
      console.log "Modal dismissed"
