(function() {
  'use strict';

  angular
    .module('app')
    .factory('TagFactory', TagFactory);

  TagFactory.$inject = [ '$rootScope', '$q', 'Restangular', 'localStorage' ];

  function TagFactory($rootScope, $q, Restangular, localStorage) {
  	var baseServices = Restangular.all($rootScope.current_user.role+'/tags');

      var factory = {
        get: get
      }
      return factory;


      function get() {
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customGET().then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

  }
})();