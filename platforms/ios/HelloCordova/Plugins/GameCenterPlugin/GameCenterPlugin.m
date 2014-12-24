//
//  GameCenterPlugin.m
//  Detonate
//
//  Created by Marco Piccardo on 04/02/11.
//  Copyright 2011 Eurotraining Engineering. All rights reserved.
//
/*
 *  Modified and Updated
 *
 *  Copyright 2014 Wizcorp Inc. http://www.wizcorp.jp
 *  Author Ally Ogilvie
 */

#import "GameCenterPlugin.h"
#import <Cordova/CDVViewController.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface GameCenterPlugin ()
@property (nonatomic, retain) GKLeaderboardViewController *leaderboardController;
@property (nonatomic, retain) GKAchievementViewController *achievementsController;
@end

@implementation GameCenterPlugin

- (void)dealloc {
    self.leaderboardController = nil;
    self.achievementsController = nil;
    
    [super dealloc];
}

- (void)authenticateLocalPlayer:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
                if (error == nil) {
                    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                } else {
                    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }];
        } else {
            [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewcontroller, NSError *error) {
                CDVPluginResult *pluginResult;
            
                if ([GKLocalPlayer localPlayer].authenticated) {
                    // Already authenticated
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                } else if (viewcontroller) {
                    // Present the login view
                    
                    CDVViewController *cont = (CDVViewController *)[super viewController];
                    [cont presentViewController:viewcontroller animated:YES completion:^{
                        [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
                    }];
                    
                } else {
                    // Called the second time with result
                    if (error == nil) {
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                    } else {
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
                    }
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

                }

            }];
        }
    }];
}

- (void)reportScore:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        NSString *category = (NSString *) [command.arguments objectAtIndex:0];
        int64_t score = [[command.arguments objectAtIndex:1] integerValue];

        GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
        scoreReporter.value = score;

        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            CDVPluginResult *pluginResult;
            if (!error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (void)showLeaderboard:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        if ( self.leaderboardController == nil ) {
            self.leaderboardController = [[GKLeaderboardViewController alloc] init];
            self.leaderboardController.leaderboardDelegate = self;
        }

        self.leaderboardController.category = (NSString *) [command.arguments objectAtIndex:0];
        CDVViewController *cont = (CDVViewController *)[super viewController];
        [cont presentViewController:self.leaderboardController animated:YES completion:^{
            [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
        }];
    }];
}

- (void)showAchievements:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        if ( self.achievementsController == nil ) {
            self.achievementsController = [[GKAchievementViewController alloc] init];
            self.achievementsController.achievementDelegate = self;
        }

        CDVViewController *cont = (CDVViewController *)[super viewController];
        [cont presentViewController:self.achievementsController animated:YES completion:^{
            [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidShow()"];
        }];
    }];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    CDVViewController *cont = (CDVViewController *)[super viewController];
    [cont dismissViewControllerAnimated:YES completion:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidHide()"];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
    CDVViewController* cont = (CDVViewController *)[super viewController];
    [cont dismissViewControllerAnimated:YES completion:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.gameCenter._viewDidHide()"];
}

- (void)reportAchievementIdentifier:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSString *identifier = (NSString *) [command.arguments objectAtIndex:0];
        float percent = [[command.arguments objectAtIndex:1] floatValue];

        GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
        if (achievement) {
            achievement.percentComplete = percent;
            [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
                CDVPluginResult *pluginResult;
                if (!error) {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
                }
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
        } else {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to alloc GKAchievement"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

@end
