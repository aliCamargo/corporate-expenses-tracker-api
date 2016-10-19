(function() {
    'use strict';

    angular
        .module('app.core')

        /* ----------------------------  local ---------------------------------- */
        // .constant('ENDPOINT_URL', 'http://lvh.me:3000/api')
        // .constant('BASE_URL', 'http://localhost:8085/')

        /* ----------------------------  Production ---------------------------------- */
        .constant('ENDPOINT_URL', 'https://corporate-expenses-tracker.herokuapp.com/api')
        .constant('BASE_URL', 'https://corporate-expenses-tracker.herokuapp.com')


})();
