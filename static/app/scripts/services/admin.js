// Generated by CoffeeScript 1.6.3
(function() {
  'use strict';
  var Admin;

  Admin = (function() {
    function Admin(Pubsub) {
      var query,
        _this = this;
      this.Pubsub = Pubsub;
      this.events = {
        UPDATED: 'Users updated'
      };
      this.Pubsub.engage(this, this.events);
      query = new Parse.Query(Parse.Role);
      query.equalTo("name", "Administrator");
      query.first({
        success: function(adminRole) {
          _this.adminRole = adminRole;
          return _this.updateUsers();
        }
      });
    }

    Admin.prototype.updateUsers = function() {
      var usersQuery,
        _this = this;
      this.users = this.adminRole.getUsers();
      usersQuery = this.users.query();
      return usersQuery.find({
        success: function(roleUsers) {
          _this.roleUsers = roleUsers;
          return _this.notify(_this.events.UPDATE, _this.roleUsers);
        }
      });
    };

    Admin.prototype.isAdmin = function(user) {
      if (this.roleUsers) {
        return _.find(this.roleUsers, function(roleUser) {
          return roleUser.id === user.id;
        });
      }
    };

    Admin.prototype.switchAdmin = function(user, cb, errCB) {
      var index, isAdmin, roleACL,
        _this = this;
      isAdmin = this.isAdmin(user);
      roleACL = this.adminRole.getACL();
      roleACL.setReadAccess(user, !isAdmin);
      roleACL.setWriteAccess(user, !isAdmin);
      if (!isAdmin) {
        this.adminRole.getUsers().add(user);
      } else {
        this.adminRole.getUsers().remove(user);
        index = _.findIndex(this.roleUsers, function(roleUser) {
          return roleUser.id === user.id;
        });
      }
      return this.adminRole.save({
        success: function(obj) {
          _this.updateUsers();
          return typeof cb === "function" ? cb(obj) : void 0;
        },
        error: function(obj, err) {
          return typeof errCB === "function" ? errCB(obj, err) : void 0;
        }
      });
    };

    return Admin;

  })();

  angular.module('wordsApp').service('Admin', ['Pubsub', Admin]);

}).call(this);

/*
//@ sourceMappingURL=admin.map
*/