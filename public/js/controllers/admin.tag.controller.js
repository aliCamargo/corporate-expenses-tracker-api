/**
 * @author ctola
 */
(function() {
    angular
        .module('app')
        .controller('AdminTagController', AdminTagController);
	
	AdminTagController.$inject = [ 'TagFactory' ];
    function AdminTagController( TagFactory ) {

        var vm = this;
            vm.tags = [];

        TagFactory.get().then(
            function (r) {
                vm.tags = r.tags;
            }
        );

    }
})();