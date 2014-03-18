angular.module('coreLibs', [])

$core = ($rootScope, $coreEvents) -> 
  $core.$inject = ["$rootScope", "$coreEvents"]
  
  exports = 
    $events: $coreEvents
  
  $rootScope.$core = exports
  window.$core = exports
  
  return exports

angular.module('core', ['coreLibs']).factory "$core", $core