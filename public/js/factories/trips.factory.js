(function() {
  'use strict';

  angular
    .module('app')
    .factory('TripFactory', TripFactory);

  TripFactory.$inject = [ '$rootScope', '$q', 'Restangular', 'localStorage' ];

  function TripFactory($rootScope, $q, Restangular, localStorage) {
  	var baseServices = Restangular.all($rootScope.current_user.role+'/trips');

      var factory = {
        save: save,
        update: update,
        get: get, 
        show: show,
        remove: remove
      }
      return factory;

      function save(form) {
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customPOST(form).then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }


      function update(form, id) {
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customPUT(form, id).then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

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

      function show(id) {
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customGET(id).then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

      function remove(id) {
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customDELETE('', id).then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

  }
})();