$coreEvents = ($q, $http) ->

  currentCollection = []
  currentItem = null

  return {
    all: () ->
      deffered = $q.defer()

      $http.get('/api/events')
        .success (data, status, headers, config) => 
          deffered.resolve(data)
        .error (data, status, headers, config) => 
          deffered.reject()

      return deffered.promise

    create: (doc) ->
      deffered = $q.defer()
      $http.post('/api/events', doc)
        .success (data, status, headers, config) => 
          deffered.resolve(data)
        .error (data, status, headers, config) => 
          deffered.reject()

      return deffered.promise;
  }


angular.module('coreLibs').factory "$coreEvents", ["$q", "$http", $coreEvents]