(function() {
    'use strict';
    angular
        .module('app')
        .factory('localStorage', localStorage);
    localStorage.$inject = ['$window'];
    /* @ngInject */
    function localStorage($window) {
        var service = {
            set: set,
            get: get,
            setObject: setObject,
            getObject: getObject,
            remove: remove,
            removeAll: removeAll
        };
        return service;


        function set(key, value) {
            $window.localStorage[key] = value;
        }

        function get(key){
            return $window.localStorage[key] || null;
        }

        function setObject(key, value){
            $window.localStorage[key] = angular.toJson(value);
        }

        function getObject(key){
            return angular.fromJson($window.localStorage[key] || null);
        }

        function remove(key){
            $window.localStorage.removeItem(key);
        }

        function removeAll(){
            $window.localStorage.removeItem("user");
            $window.localStorage.removeItem("access_token");
            $window.localStorage.removeItem("member");
        }
    }
})();
