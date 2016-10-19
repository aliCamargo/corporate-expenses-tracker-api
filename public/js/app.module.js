/**
 * @author ctola
 */
(function() {
  'use strict';
  
  angular
    .module('app',[
        'app.core',
        'ui.materialize',
        'ui.router',
        'ngResource'
    ])
    .run(appRun);

    appRun.$inject =['$rootScope', '$state', '$filter', '$timeout', 'Restangular', 'toastr', 'localStorage', 'SessionManagerFactory'];
    function appRun( $rootScope, $state, $filter, $timeout, Restangular, toastr, localStorage, SessionManagerFactory ) {

        $rootScope.logout = function(){
            SessionManagerFactory.Logout().then(
                    function(result){
                        $rootScope.current_user = null;
                        toastr.success("Logout correctly!");
                        $timeout(function() {
                            $state.go('login');
                        }, 1200);
                    },

                    function(error){
                        toastr.error(error.error, "Error");
                        $timeout(function() {
                            $state.go('login');
                        }, 1200);
                    }
                );
        };

        $rootScope.$on('$stateChangeStart', function(event, next, current) {
            var isAuthenticated = SessionManagerFactory.isAuthenticated();

            if( !isAuthenticated && next.name != 'login'){
                $state.go('login');
                $rootScope.current_user = null;
                localStorage.removeAll();
                event.preventDefault();
            }else if( isAuthenticated ){
                $rootScope.current_user = localStorage.getObject("user");

                //-- If no have permission
                if( next.session.role != $rootScope.current_user.role && next.session.role != 'all' ){
                    toastr.error('You no have permission', "Forbidden");
                    $state.go( $rootScope.current_user.role );
                    event.preventDefault();
                }

                //-- Redirect to specifiq role
                if(next.name == 'login'){
                    $state.go( $rootScope.current_user.role );
                    event.preventDefault();
                }
            }

        });

        $rootScope.$on('$stateChangeSuccess', function() {
            document.body.scrollTop = document.documentElement.scrollTop = 0;
        });

        //-- Angular interceptor
        Restangular.setErrorInterceptor(function(response, deferred, responseHandler) {
            if (response.status === 401) {
                $rootScope.current_user = null;
                localStorage.removeAll();

                angular.forEach(response.data.errors, function (value, key, array) {
                    if( angular.isArray(value) ){
                        toastr.error(value.join('<br/>'), $filter('humanize')(key));
                    }else{
                        toastr.error(value, $filter('humanize')(key));
                    }
                });
                $state.go('login');

                return false; // error handled
            }

            if( response.status === 403 ){
                 console.log( response )
                toastr.error('You role no have permission for access to :' + response.config.method + ' ' + response.config.url, "Forbidden");
            }
            return true; // error not handled
        });
    };

})();
