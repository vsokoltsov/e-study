angular.module("estudy")
    .controller('AuthModalCtrl', [
        '$scope',
        '$state',
        '$modal',
        '$modalInstance',
        'Auth',
        'currentTab',
        'users',
        function($scope, $state, $modal, $modalInstance, Auth, currentTab, users){
            $scope.modalView = {};
            if(currentTab === 'reg'){
                $scope.activeTabReg = true;
            } else if(currentTab == 'auth'){
                $scope.activeTabAuth = true;
            }

            $scope.login = function(){
                var userParams = {
                    email: $scope.modalView.authForm.email,
                    password: $scope.modalView.authForm.password
                };

                Auth.login(userParams).then(function(user){
                    $modalInstance.dismiss('cancel');
                    Auth._currentUser = user;
                    $state.go('profile');
                }, function(error){
                    $scope.modalView.authForm.$submitted = true;
                    $scope.modalView.authForm.$errors = error.data.error;
                    $scope.modalView.authForm.$invalid = true;
                    $scope.modalView.authForm.$valid = false;
                    console.log($scope.modalView.authForm);
                });
            };
            $scope.register = function(){
                var userParams = {
                    email: $scope.modalView.regForm.email,
                    password: $scope.modalView.regForm.password,
                    password_confirmation: $scope.modalView.regForm.password_confirmation
                };
                $scope.modalView.regForm.$submitted = true;
                Auth.register(userParams).then(function(user){
                    $modalInstance.dismiss('cancel');
                    $state.go('edit_profile');
                }, function(error){
                    console.log(error);
                    $scope.modalView.regForm.$submitted = true;
                    $scope.modalView.regForm.$errors = error.data.errors;
                    $scope.modalView.regForm.$invalid = true;
                    $scope.modalView.regForm.$valid = false;
                })
            };

            $scope.cancel = function(){
                $modalInstance.dismiss('cancel');
            };

            $scope.setCurrentViewDetails = function(title, form){
                $scope.modalTitle = title;
                $scope.modalView.currentForm = form;
            };

            $scope.init = function(){
                console.log($scope.modalView);
            };
            $scope.defineCurrentForm = function(){
                var object = $scope.modalView;
                if(object.hasOwnProperty("currentForm")){
                    var form;
                    if($scope.activeTabAuth){
                        form = $scope.modalView.authForm;
                    } else if($scope.activeTabReg){
                        form = $scope.modalView.regForm;
                    } else {
                        form = $scope.modalView.restoreForm;
                    }
                    $scope.modalView.currentForm = form;
                }
            };
            $scope.requireEmail = function(event){
                var path = event.currentTarget.href;
                var modalInstance = $modal.open({
                    animation: true,
                    templateUrl: 'modal_windows/_add_email.html',
                    controller: 'AddEmailCtrl as emailCtrl',
                    size: 'lg',
                    resolve: {
                        url: function () {
                            return path;
                        }
                    }

                })
            };

            $scope.restorePassword = function(){
                users.resetPassword($scope.modalView.restoreForm.email).then(function(data){
                    $modalInstance.dismiss('cancel');
                });
            };
        }
    ]);