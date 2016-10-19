/**
 * @author ctola
 */
(function() {
    angular
        .module('app')
        .controller('AdminHomeController', AdminHomeController);
	
	AdminHomeController.$inject = [ '$filter', 'toastr', 'EmployeeFactory', 'TripFactory' ];
    function AdminHomeController( $filter, toastr, EmployeeFactory, TripFactory ) {

        var vm = this;
            vm.createEmployee = createEmployee,
            vm.newTrip = newTrip,
            vm.createTrip = createTrip,
            vm.openModal = false,
            vm.openModalTrip = false,
            vm.params = {},
            vm.trip_params = {},
            vm.employees = [];

        
        EmployeeFactory.get().then(
            function (r) {
                    vm.employees = r.users;
                }
        );

        vm.params = {
            user: {
                email: ''
            }
        };

        //-- Create Employee
        function createEmployee(){
            EmployeeFactory.save(vm.params).then(
                function (user) {

                    vm.employees.push(user);
                    toastr.success('User created correctly');
                    vm.openModal = false;
                    vm.params = {
                            user: {
                                email: ''
                            }
                        }
                },
                function(err){

                    angular.forEach(err.data.errors, function (value, key, array) {
                            if( angular.isArray(value) ){
                                toastr.error(value.join('<br/>'), $filter('humanize')(key));
                            }else{
                                toastr.error(value, $filter('humanize')(key));
                            }
                        });
                }
            )
        };

        //-- load form for new trip
        function newTrip(user){
            vm.openModalTrip = true;
            vm.full_name =  user.first_name + ' ' + user.last_name
            vm.trip_params = {
                "trip": {
                    user_id: user.id
                }
            };
        };

        //-- Create Trip for user
        function createTrip(){
            TripFactory.save(vm.trip_params).then(
                function (trip) {
                    toastr.success('Trip created correctly');
                    vm.openModalTrip = false;
                    vm.trip_params = {
                        "trip": {
                            user_id: ''
                        }
                    };
                },
                function(err){
                    angular.forEach(err.data.errors, function (value, key, array) {
                        if( angular.isArray(value) ){
                            toastr.error(value.join('<br/>'), $filter('humanize')(key));
                        }else{
                            toastr.error(value, $filter('humanize')(key));
                        }
                    });
                }
            )
        };

        

    }
})();