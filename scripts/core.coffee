angular.module('coreLibs', [])

$core = ($rootScope, $coreEvents, $coreMembers) -> 
  $core.$inject = ["$rootScope", "$coreEvents", "$coreMembers"]
  
  exports = 
    $events: $coreEvents
    $members: $coreMembers
  
  $rootScope.$core = exports
  window.$core = exports
  
  return exports

angular.module('core', ['coreLibs']).factory "$core", $core