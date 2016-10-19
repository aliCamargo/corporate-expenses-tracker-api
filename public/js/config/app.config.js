/**
 * @author ctola
 */
angular
    .module("app")
    .config(appConfig);

appConfig.$inject =['$httpProvider', 'RestangularProvider', 'ENDPOINT_URL'];

function appConfig($httpProvider, RestangularProvider, ENDPOINT_URL) {
    RestangularProvider.setBaseUrl(ENDPOINT_URL);

    $httpProvider.interceptors.push(function($q, toastr) {
        return {
            responseError: function(rejection) {
                if(rejection.status <= 0) {
                    toastr.error('Connection refused', 'Error');
                    return false;
                }
                return $q.reject(rejection);
            }
        };
    });
}