/**
 * @author ctola
 */
(function() {
    angular
        .module('app')
        .controller('EmployeeExpenseController', EmployeeExpenseController);

    EmployeeExpenseController.$inject = [ '$stateParams', '$filter', 'toastr', 'TripFactory', 'ExpenseFactory' ];
    function EmployeeExpenseController( $stateParams, $filter, toastr, TripFactory, ExpenseFactory ) {

        var vm = this;
            vm.saveExpense = saveExpense,
            vm.dayFilter = dayFilter,
            vm.finishTrip = finishTrip,
            vm.openModal = false,
            vm.expense_params = {
                expense: {
                    name: ''
                }
            },
            vm.searchDay = null,
            vm.current_trip = null,
            vm.expenses = [];

        TripFactory.show($stateParams.trip_id).then(
            function (trip) {

                vm.current_trip = trip;
            }
        );

        ExpenseFactory.get($stateParams.trip_id).then(
            function (r) {
                vm.expenses = r.expenses;
            }
        );

        //-- Save Expense
        function saveExpense(){

            ExpenseFactory.save(vm.expense_params, vm.current_trip.id).then(
                function (expense) {
                    vm.openModal = false;
                    vm.expenses.push( expense );
                    toastr.success('Expense created correctly');

                    vm.expense_params  = {
                        expense: {
                            name: ''
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

                        //console.log("a[" + index + "] = " + element);
                    });
                }
            )
        }

        //-- Filter by day
        function dayFilter(property, pickedDate) {
            return function (item) {
                if (pickedDate === null || pickedDate === '' || pickedDate === undefined) return true;
                if (item[property] === null) return false;

                var itemDate = $filter('date')(item[property], 'dd-MM-yyyy');
                var pd = $filter('date')(pickedDate, 'dd-MM-yyyy');

                if ( itemDate == pd ) return true;
                return false;
            }
        }

        //-- Finish a trip
        function finishTrip(){
            var trip_params = {
                trip: {
                    status: 'finished'
                }
            }

            TripFactory.update(trip_params, vm.current_trip.id).then(
                function (trip) {
                    vm.current_trip = trip;
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

                        //console.log("a[" + index + "] = " + element);
                    });
                }
            )
        }

    }
})();