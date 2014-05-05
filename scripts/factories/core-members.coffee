$coreMembers = ($q, $http) ->

  return {
    all: () ->
      deffered = $q.defer()

      $http.get('/api/members')
        .success (data, status, headers, config) => 
          deffered.resolve(data)
        .error (data, status, headers, config) => 
          deffered.reject()

      return deffered.promise

    create: (doc) ->
      deffered = $q.defer()
      $http.post('/api/members', doc)
        .success (data, status, headers, config) => 
          deffered.resolve(data)
        .error (data, status, headers, config) => 
          deffered.reject()

      return deffered.promise;

    save: (doc) ->
      deffered = $q.defer()
      doc.updated = moment().toISOString()
      $http.put("/api/members/#{doc._id}", doc)
        .success (data, status, headers, config) => 
          deffered.resolve(data)
        .error (data, status, headers, config) => 
          deffered.reject()
      return deffered.promise

    delete: (id) ->
      deffered = $q.defer()
      $http.delete("/api/members/#{id}")
        .success (data, status, headers, config) => 
          deffered.resolve(data)
        .error (data, status, headers, config) => 
          deffered.reject()
      return deffered.promise;
  }


angular.module('coreLibs').factory "$coreMembers", ["$q", "$http", $coreMembers]