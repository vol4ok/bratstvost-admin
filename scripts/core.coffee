angular.module('coreLibs', [])

$core = ($rootScope, $coreMembers) ->
  $core.$inject = ["$rootScope", "$coreMembers"]
  
  exports = 
    $members: $coreMembers
  
  $rootScope.$core = exports
  window.$core = exports
  
  return exports

angular.module('core', ['coreLibs']).factory "$core", $core