# Cordova iOS Game Center Plugin #

## DESCRIPTION ##

* A plugin to integrate Game Center in a Phonegap iOS app/game.
* Please read [Game Center Programming Guide](http://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/GameKit_Guide/GameCenterOverview/GameCenterOverview.html) and the [iTunes Connect Developer Guide](https://itunesconnect.apple.com/docs/iTunesConnect_DeveloperGuide.pdf).

## SETUP ##

Using this plugin requires [Cordova iOS](https://github.com/apache/incubator-cordova-ios).

0. git clone git://this GameCenter
1. Make sure your Xcode project has been [updated for Cordova](https://github.com/apache/incubator-cordova-ios/blob/master/guides/Cordova%20Upgrade%20Guide.md)
2. Drag and drop the `GameCenter` folder from Finder to your Plugins folder in XCode, using "Create groups for any added folders"
3. Add the .js files to your `www` folder on disk, and add reference(s) to the .js files using <script> tags in your html file(s)

    <script type="text/javascript" src="/js/plugins/GameCenterPlugin.js"></script>

4. Add new entry with key `GameCenterPlugin` and value `GameCenterPlugin` to `Plugins` in `Cordova.plist/Cordova.plist`
5. Add new entry value `service.gc.apple.com` and `service-sandbox.gc.apple.com` to `ExternalHosts` in `Cordova.plist/Cordova.plist`

## JAVASCRIPT INTERFACE ##

    // After device ready, create a local alias
    var gamecenter = window.plugins.gamcenter
    
    // Use Leaderboard ID added to iTunes Connect.
    var LEADERBOARD_ID = "1"
    
    // Report integer score to Leaderboard
    var score = 100
    gamecenter.reportScore(LEADERBOARD_ID, score);

    // Show leaderboard by modal view
    gamecenter.showLeaderboard(LEADERBOARD_ID);

    // Unlock achivement
    var ACHIEVEMENT_ID = 'star'
    gamecenter.getAchievement(ACHIEVEMENT_ID);

    // Show achievements by modal view 
    gamecenter.showAchievements();

