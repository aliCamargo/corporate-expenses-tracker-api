(function() {
    'use strict';

    angular
        .module('app.core')

        /* ----------------------------  local ---------------------------------- */
        // .constant('ENDPOINT_URL', 'http://lvh.me:3000/api')

        /* ----------------------------  Production ---------------------------------- */
        .constant('ENDPOINT_URL', 'https://corporate-expenses-tracker.herokuapp.com/api')

})();
