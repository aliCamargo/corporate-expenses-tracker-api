/**
 * @author ctola
 */
(function() {
    angular
        .module('app')
        .controller('AdminTripController', AdminTripController);
	
	AdminTripController.$inject = [ '$filter', 'EmployeeFactory', 'TripFactory', 'toastr' ];
    function AdminTripController( $filter, EmployeeFactory, TripFactory, toastr ) {

        var vm = this;
            vm.showExpenses = showExpenses,
            vm.createTrip = createTrip,
            vm.openModal = false,
            vm.trips = [],
            vm.users = [];
            vm.trip_params = {
                trip: {
                    name: ''
                }
            };


        EmployeeFactory.get().then(
            function (r) {
                angular.forEach(r.users, function(attr, index){
                    if(attr.role == 'employee'){
                        vm.users.push( r.users[index] );
                    }
                })

            }
        );

        TripFactory.get().then(
            function (r) {
                    vm.trips = r.trips;
                }
        );


        //-- load expenses list
        function showExpenses(trip){
            vm.openModal = true;
            vm.trip =  trip
        };

        //-- Create Trip for user
        function createTrip(){
            TripFactory.save(vm.trip_params).then(
                function (trip) {
                    toastr.success('Trip created correctly');
                    vm.trips.push(trip);
                    vm.openModalTrip = false;
                    vm.trip_params = {
                        "trip": {
                            name: ''
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