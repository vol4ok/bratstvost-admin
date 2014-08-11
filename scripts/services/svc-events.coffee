$eventsSvc = ($q, $http) ->

  return {
    all: () ->
      deffered = $q.defer()
      $http.get('/api/events')
      .success (data, status, headers, config) =>
        deffered.resolve(data)
      .error (data, status, headers, config) =>
        deffered.reject()
      return deffered.promise;

    create: (doc) ->
      deffered = $q.defer()
      $http.post('/api/events', doc)
      .success (data, status, headers, config) =>
        deffered.resolve(data)
      .error (data, status, headers, config) =>
        deffered.reject()
      return deffered.promise;

    save: (doc) ->
      deffered = $q.defer()
      doc.updated = moment().toISOString()
      $http.put("/api/events/#{doc._id}", doc)
      .success (data, status, headers, config) =>
        deffered.resolve(data)
      .error (data, status, headers, config) =>
        deffered.reject()
      return deffered.promise;

    delete: (id) ->
      deffered = $q.defer()
      $http.delete("/api/events/#{id}")
      .success (data, status, headers, config) =>
        deffered.resolve(data)
      .error (data, status, headers, config) =>
        deffered.reject()
      return deffered.promise;
  }
  
angular.module('coreLibs').factory("$eventsSvc", ["$q", "$http", $eventsSvc])