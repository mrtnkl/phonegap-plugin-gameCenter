(function(window) {
  var GameCenter = function() {
    if(!localStorage.getItem('GameCenterLoggedin')) {
      cordova.exec("GameCenterPlugin.authenticateLocalPlayer");
    }
  };

  GameCenter.prototype = {
    authenticate: function() {
      cordova.exec("GameCenterPlugin.authenticateLocalPlayer");
    },

    showLeaderboard: function(category) {
      cordova.exec("GameCenterPlugin.showLeaderboard", category);
    },

    reportScore: function(category, score) {
      cordova.exec("GameCenterPlugin.reportScore", category, score);
    },

    showAchievements: function() {
      cordova.exec("GameCenterPlugin.showAchievements");
    },

    getAchievement: function(category) {
      cordova.exec("GameCenterPlugin.reportAchievementIdentifier", category, 100);
    },
  };

  GameCenter._userDidLogin = function() {
    localStorage.setItem('GameCenterLoggedin', 'true');
  };

  GameCenter._userDidSubmitScore = function() {
    alert('score submitted');
  };

  GameCenter._userDidFailSubmitScore = function() {
    alert('score error');
  };

  if(!window.plugins) window.plugins = {};
  window.plugins.gamecenter = new GameCenter();
})(window);