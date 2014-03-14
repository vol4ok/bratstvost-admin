angular.module('coreLibs', [])

$core = ($rootScope) -> 
  $core.$inject = ["$rootScope"]
  
  exports = {}
  
  $rootScope.$core = exports
  window.$core = exports
  
  return exports

angular.module('core', ['coreLibs']).factory "$core", $core