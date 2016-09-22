$videoSvc = ($q, $http) ->

  return {
  all: () ->
    deffered = $q.defer()
    $http.get('/api/video')
    .success (data, status, headers, config) =>
      deffered.resolve(data)
    .error (data, status, headers, config) =>
      deffered.reject()
    return deffered.promise;

  create: (doc) ->
    deffered = $q.defer()
    $http.post('/api/video', doc)
    .success (data, status, headers, config) =>
      deffered.resolve(data)
    .error (data, status, headers, config) =>
      deffered.reject()
    return deffered.promise;

  save: (id, doc) ->
    if arguments.length is 1
      doc = id
      id = doc._id
    deffered = $q.defer()
    doc.updated = moment().toISOString()
    $http.put("/api/video/#{id}", doc)
    .success (data, status, headers, config) =>
      deffered.resolve(data)
    .error (data, status, headers, config) =>
      deffered.reject()
    return deffered.promise;

  delete: (id) ->
    deffered = $q.defer()
    $http.delete("/api/video/#{id}")
    .success (data, status, headers, config) =>
      deffered.resolve(data)
    .error (data, status, headers, config) =>
      deffered.reject()
    return deffered.promise;
  }

angular.module('coreLibs').factory("$videoSvc", ["$q", "$http", $videoSvc])