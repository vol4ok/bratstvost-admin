angular.module('coreLibs').controller "EventEditor2Ctrl", ($scope, uuid4) ->

    # marked.setOptions
    #   gfm: false
    #   tables: false

    $scope.dateOptions = {}

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

    filterText = (str) ->
      return str
        .replace(/[ ]{2,}/, " ")
        .replace(/ПНИ/g, "<abbr title=\"Психоневрологический интернат\">ПНИ</abbr>")

    REXP_STRIP_P = /^<p>(.*)<\/p>\s*$/
    stripP = (str) -> 
      if REXP_STRIP_P.test(str) then RegExp.$1 else str

    parse_phone = (phone) ->
      return undefined unless phone
      res = ""
      for c,i in phone
        res += c if c in "+0123456789".split("")
      return {
        nums: res.slice(-7)
        code: res.slice(-9,-7)
      }

    format_phone_nice = (p) ->
      p = parse_phone(p) if typeof p is "string"
      n = p.nums.split("")
      return "8 (0#{p.code}) #{n[0]}#{n[1]}#{n[2]}-#{n[3]}#{n[4]}-#{n[5]}#{n[6]}"

    format_phone_raw = (p) ->
      p = parse_phone(p) if typeof p is "string"
      return "+375#{p.code}#{p.nums}"

    format_phone_link = (phone_str) ->
      if phone = parse_phone(phone_str)
        return "<a href=\"tel:#{format_phone_raw(phone)}\">#{format_phone_nice(phone)}</a>"
      return ""


    getEvent = (newEvent) ->
      event = angular.copy(newEvent)
      event._id = uuid4.generate()
      event.title         = filterText(stripP(marked(newEvent.title))).trim()
      event.meeting_time  = filterText(stripP(marked(newEvent.meeting_time))).trim()
      event.meeting_place = filterText(stripP(marked(newEvent.meeting_place))).trim()
      event.event_time    = filterText(stripP(marked(newEvent.event_time))).trim()
      event.event_place   = filterText(stripP(marked(newEvent.event_place))).trim()
      event.phone = format_phone_link(newEvent.phone)
      event.body  = filterText(marked(newEvent.body)).trim()
      event.created = new Date
      event.updated = new Date
      if newEvent.cakes 
        event.custom_field = [] unless event.custom_field
        event.custom_field.push
          icon: "cake-1"
          term: "Выпечка"
          desc: newEvent.cakes
        

      return event

    $scope.eventJSON = getEvent($scope.newEvent)

    $scope.$watchCollection "newEvent", ->
      $scope.eventJSON = JSON.stringify(getEvent($scope.newEvent), null, "  ")
