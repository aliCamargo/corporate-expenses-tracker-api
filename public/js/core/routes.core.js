angular
    .module('app.core')
    .config(appRoutes);

appRoutes.$inject =['$stateProvider', '$urlRouterProvider'];

function appRoutes($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise("/login");

    $stateProvider
        .state('login', {
            url: '/login',
            templateUrl: "views/session/login.html",
            controller: "SessionController as vm",
            session: {
                role: 'all',
                login: false
            }
        })

        .state('admin', {
            url: '/admin',
            templateUrl: "views/admin/home.html",
            controller: "AdminHomeController as vm",
            session: {
                role: 'admin', 
                login: true
            },
            resolve: {
                resolveCurrentUser: resolveCurrentUser
            }
        })

            .state('admin.trips', {
                url: '/trips',
                templateUrl: "views/admin/trips.html",
                controller: "AdminTripController as vm",
                session: {
                    role: 'admin',
                    login: true
                }
            })

            .state('admin.tags', {
                url: '/tags',
                templateUrl: "views/admin/tags.html",
                controller: "AdminTagController as vm",
                session: {
                    role: 'admin',
                    login: true
                }
            })

        .state('employee', {
            url: '/employee',
            templateUrl: "views/employee/home.html",
            controller: "EmployeeHomeController as vm",
            session: {
                role: 'employee', 
                login: true
            },
            resolve: {
                resolveCurrentUser: resolveCurrentUser
            }
        })

            .state('employee.expenses', {
                url: '/expenses/{trip_id:int}',
                templateUrl: "views/employee/expenses.html",
                controller: "EmployeeExpenseController as vm",
                session: {
                    role: 'employee',
                    login: true
                }
            });


    function resolveCurrentUser($rootScope, localStorage){
        $rootScope.current_user = localStorage.getObject('user');
    }
}