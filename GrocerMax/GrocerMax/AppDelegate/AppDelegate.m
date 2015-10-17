//
//  AppDelegate.m
//  GrocerMax
//
//  Created by Deepak Soni on 08/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "AppDelegate.h"
#import "GMLoginVC.h"
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <HockeySDK/HockeySDK.h>
#import "GMTabBarVC.h"
#import "GMHomeVC.h"
#import "GMLeftMenuVC.h"
#import "GMHotDealVC.h"
#import "GMSearchVC.h"
#import <GoogleAnalytics/GAI.h>

static NSString *const kGaPropertyId = @"UA-64820863-1";
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = YES;
static int const kGaDispatchPeriod = 20;

@interface AppDelegate ()

//@property (nonatomic, strong) XHDrawerController *drawerController;
@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [self fetchAllCategories];
    
    // for ios 8 and above
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        // for iOS 8 below
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    //https://developers.google.com/identity/sign-in/ios/offline-access
    [self initializeGoogleAnalytics];
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    if (configureError != nil) {
//        NSLog(@"Error configuring the Google context: %@", configureError);
    }
    
    [GIDSignIn sharedInstance].clientID = @"38746701051-1bi2gqs9obckcf9b6a7fffdmlvfmpr1a.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].serverClientID = @"38746701051-30a0ch5eogued2mq4hjq8uj25kr75mss.apps.googleusercontent.com";
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"d19e792d766ac6a0dc3b7e754145c00f"];
    // Configure the SDK in here only!
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
        
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarVC = [[GMTabBarVC alloc] init];
    
    GMLeftMenuVC *leftMenuVC = [[GMLeftMenuVC alloc] initWithNibName:@"GMLeftMenuVC" bundle:nil];
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.tabBarVC leftDrawerViewController:[[UINavigationController alloc] initWithRootViewController:leftMenuVC]];
    self.drawerController.maximumLeftDrawerWidth = 260.0;
    
    self.navController.navigationBarHidden = YES;
    self.window.rootViewController = self.drawerController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self.window makeKeyAndVisible];
    if ( self.errorWindow == nil ) {
        self.errorWindow = [RZMessagingWindow defaultMessagingWindow];
        [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    }
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL isFB = YES;
    
    if (isFB) {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

#pragma mark - PushNotification Delgate

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSLog(@"My Device token is: %@", deviceToken);
    
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:kEY_notification_token];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    
}


#pragma mark - Drawer Handling Methods

- (void)setTopVCOnCenterOfDrawerController:(UIViewController*)topVC {
    
    GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
    UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
    for (UIViewController *vc in [centerNavVC viewControllers]) {// pop to dashboard
        
        if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMHomeVC class])]) {
            [centerNavVC popToViewController:vc animated:NO];
            break;
        }
    }
    if ([NSStringFromClass([topVC class]) isEqualToString:NSStringFromClass([GMHomeVC class])]) {
        // for dashboard
        
    }
    else {
        //other
        [centerNavVC pushViewController:topVC animated:NO];
    }
    [self.drawerController closeDrawerAnimated:YES completion:nil];
}

- (void)popToCenterViewController {
    
    UINavigationController *centerNavVC = (UINavigationController*)(self.drawerController.centerViewController);
    for (UIViewController *vc in [centerNavVC viewControllers]) {// pop to dashboard
        
        if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMHomeVC class])]) {
            [centerNavVC popToViewController:vc animated:NO];
            break;
        }
    }
}

- (void)setTopVCOnHotDealsController:(UIViewController*)topVC {
    
    GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
    [tabBarVC setSelectedIndex:2];
    UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
    for (UIViewController *vc in [centerNavVC viewControllers]) {// pop to dashboard
        
        if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMHotDealVC class])]) {
            [centerNavVC popToViewController:vc animated:NO];
            break;
        }
    }
    if ([NSStringFromClass([topVC class]) isEqualToString:NSStringFromClass([GMHotDealVC class])]) {
        // for dashboard
        
    }
    else {
        //other
        [centerNavVC pushViewController:topVC animated:NO];
    }
    [self.drawerController closeDrawerAnimated:YES completion:nil];
}

-(GMSearchVC*) rootSearchVCFromFourthTab {
    
    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *searchNavVC = [tabBarVC.viewControllers objectAtIndex:3];
        
        GMSearchVC *searchVC = [searchNavVC viewControllers][0];
        return searchVC;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return nil;
}

- (void)goToHomeWithAnimation:(BOOL)animation {
    
    [self.window.layer removeAllAnimations];
    UINavigationController *navController = [self.tabBarVC.viewControllers firstObject];
    [self.tabBarVC setSelectedIndex:0];
    [navController popToRootViewControllerAnimated:animation];
}

- (void) initializeGoogleAnalytics {
    
    
    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    [[GAI sharedInstance] setDryRun:kGaDryRun];
    [[GAI sharedInstance] trackerWithTrackingId:kGaPropertyId];
    
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
//    gai.logger.logLevel = kGAILogLevelVerbose;//Remove in release
    
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Splash_Screen];
}
@end
