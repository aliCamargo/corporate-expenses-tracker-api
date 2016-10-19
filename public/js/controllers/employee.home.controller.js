/**
 * @author ctola
 */
(function() {
    angular
        .module('app')
        .controller('EmployeeHomeController', EmployeeHomeController);

    EmployeeHomeController.$inject = [ '$filter', 'toastr', 'TripFactory' ];
    function EmployeeHomeController( $filter, toastr, TripFactory ) {

        var vm = this;
            vm.finishTrip = finishTrip,
            vm.trips = [];

        TripFactory.get().then(
            function (r) {
                vm.trips = r.trips;
            }
        );

        //-- Finish a trip
        function finishTrip( trip_id, index ){
            var trip_params = {
                trip: {
                    status: 'finished'
                }
            }

            TripFactory.update(trip_params, trip_id).then(
                function (trip) {
                    vm.trips[index] = trip;
                    toastr.success('Trip finished correctly');

                    vm.params = {
                        trip: {
                            status: ''
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
        }

    }
})();