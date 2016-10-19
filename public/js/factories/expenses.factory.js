(function() {
  'use strict';

  angular
    .module('app')
    .factory('ExpenseFactory', ExpenseFactory);

  ExpenseFactory.$inject = [ '$rootScope', '$q', 'Restangular', 'localStorage' ];

  function ExpenseFactory($rootScope, $q, Restangular, localStorage) {

      var factory = {
        save: save,
        update: update,
        get: get, 
        show: show,
        remove: remove
      }
      return factory;

      function save(form, trip_id) {
        var baseServices = Restangular.all($rootScope.current_user.role + '/trips' );
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customPOST(form, trip_id + '/expenses').then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }


      function update(form, trip_id, id) {
        var baseServices = Restangular.all($rootScope.current_user.role + '/trips' );
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customPUT(form, trip_id + '/expenses/' + id).then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

      function get(trip_id) {
        var baseServices = Restangular.all($rootScope.current_user.role + '/trips' );
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customGET(trip_id + '/expenses').then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

      function show(trip_id, id) {
        var baseServices = Restangular.all($rootScope.current_user.role + '/trips' );
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customGET('', trip_id + '/expenses/' + id).then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

      function remove(trip_id, id) {
        var baseServices = Restangular.all($rootScope.current_user.role + '/trips' );
      	var token =  localStorage.getObject("access_token");
      	Restangular.setDefaultHeaders({Authorization: token});
		
          var def = $q.defer();

          baseServices.customDELETE('', trip_id + '/expenses' + id).then(function(result) {
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

  }
})();