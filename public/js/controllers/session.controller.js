/**
 * @author ctola
 */
(function() {
    angular
        .module('app')
        .controller('SessionController', SessionController);

    function SessionController($state, toastr, $timeout, SessionManagerFactory, localStorage) {
        //vars
        /* jshint validthis: true */
        var vm = this;

        vm.session = {
            "session": {

            }
        }
        vm.loginSubmit = function (){
            SessionManagerFactory.Login(vm.session).then(
                function(result){
                    console.log(result)
                    localStorage.removeAll();
                    if( result.errors ){
                        toastr.error(result.errors.message);
                    }else{
                        console.log(result);
                        localStorage.setObject('access_token', result.token);
                        localStorage.setObject('user', result.user);
                        toastr.success("Login successfully!");
                        $timeout(function() {
                            $state.go(result.user.role);
                        }, 1000);
                    }

                },function(errors){
                    toastr.error(errors.data.error);
                });
        }


    }
})();