(function() {
  'use strict';

  angular
    .module('app')
    .factory('SessionManagerFactory', SessionManagerFactory);

  SessionManagerFactory.$inject = ['$q', 'Restangular', 'localStorage'];

  function SessionManagerFactory($q, Restangular, localStorage) {
      var factory = {
        Login: Login,
        Logout: Logout,
        isAuthenticated: isAuthenticated,
        isAdmin: isAdmin,
        isEmployee: isEmployee
      }
      return factory;

      function Login(form) {
          var baseServices = Restangular.all('sessions');
          var def = $q.defer();

          baseServices.customPOST(form).then(function(result) {
                  localStorage.setObject('access_token', result.token);
                  localStorage.setObject('user', result.user);
                  def.resolve(result);
              },
              function(error) {
                  def.reject(error);
              });

          return def.promise;
      }

      function Logout() {
          var objetcUser = localStorage.getObject("access_token");

          Restangular.setDefaultHeaders({ Authorization: objetcUser.access_token });

          var baseServices = Restangular.all('sessions');
          var def = $q.defer();

          baseServices.customDELETE().then(function(result) {
                  def.resolve(result);
                  localStorage.removeAll();
              },
              function(error) {
                  def.reject(error.data);
              });

          return def.promise;
      }

      function isAuthenticated(){
        var authenticated = true;
        if( localStorage.getObject("access_token") == null ){
          authenticated = false;
        }
        return authenticated;
      }

      function isAdmin(){
          var   admin = false,
                user = localStorage.getObject("user");
          if( isAuthenticated() && user.role == 'employee' ){
              admin = true;
          }
          return admin;
      }

      function isEmployee(){
          var   employee = false,
                user = localStorage.getObject("user");
          if( isAuthenticated() && user.role == 'employee' ){
              employee = true;
          }
          return employee;
      }
  }
})();