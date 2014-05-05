angular.module('appLibs').controller "EventEditor2Ctrl", ($scope, $core, uuid4, phoneHelpers, textHelpers) ->

    # marked.setOptions
    #   gfm: false
    #   tables: false

    {filterText, stripP, FSM} = textHelpers

    $scope.dateOptions =
      dateFormat: 'dd.mm.yy'
      firstDay: 1
      dafaultDate: moment().startOf('day').toDate()

    $scope.alerts = []

    $scope.newEvent = {
      date: new Date
      title: ""
      body: ""
      meeting_time: ""
      meeting_place: ""
      event_time: ""
      event_place: ""
      organizer: "брат Сергий"
      phone: "8 (029) 373-72-50"
      published: true
      type: 'event'
    }

    $scope.saveEvent = ->
      $core.$events.create($scope.event).then ->
        $scope.alerts.push({type: "success", msg: "Added!"})

    getEvent = (newEvent) ->
      event = angular.copy(newEvent)
      event._id = uuid4.generate()
      event.date = moment.utc(newEvent.date).zone('+0300').startOf('day').add(12,'h').format()
      event.title         = FSM(newEvent.title)
      event.meeting_time  = FSM(newEvent.meeting_time)
      event.meeting_place = FSM(newEvent.meeting_place)
      event.event_time    = FSM(newEvent.event_time)
      event.event_place   = FSM(newEvent.event_place)
      event.phone = phoneHelpers.formatPhoneLink(newEvent.phone)
      event.body  = filterText(marked(newEvent.body)).trim()
      event.created = new Date
      event.updated = new Date
      if newEvent.cakes 
        event.custom_field = [] unless event.custom_field
        event.custom_field.push
          icon: "cake-1"
          term: "Выпечка"
          desc: FSM(newEvent.cakes)
      return event

    $scope.eventJSON = getEvent($scope.newEvent)

    $scope.$watchCollection "newEvent", ->
      $scope.event = getEvent($scope.newEvent)
      $scope.eventJSON = JSON.stringify($scope.event, null, "  ")

