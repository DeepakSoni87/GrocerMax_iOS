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

#import "GMTabBarVC.h"

#import "GMHomeVC.h"
#import "GMLeftMenuVC.h"


@interface AppDelegate ()

//@property (nonatomic, strong) XHDrawerController *drawerController;
@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self fetchAllCategories];
    
    //https://developers.google.com/identity/sign-in/ios/offline-access
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    if (configureError != nil) {
        NSLog(@"Error configuring the Google context: %@", configureError);
    }
    
    [GIDSignIn sharedInstance].clientID = @"38746701051-1bi2gqs9obckcf9b6a7fffdmlvfmpr1a.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].serverClientID = @"38746701051-30a0ch5eogued2mq4hjq8uj25kr75mss.apps.googleusercontent.com";
        
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
//    GMLeftMenuVC *leftMenuVC = [[GMLeftMenuVC alloc] initWithNibName:@"GMLeftMenuVC" bundle:nil];
//    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:[[GMNavigationController alloc] initWithRootViewController:[GMTabBarVC new]] leftDrawerViewController:[[UINavigationController alloc] initWithRootViewController:leftMenuVC]];
//    self.drawerController.maximumLeftDrawerWidth = 260.0;
//    
//    self.navController.navigationBarHidden = YES;
//    self.window.rootViewController = self.drawerController;
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
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

#pragma mark - Drawer Handling Methods

- (void)setTopVCOnCenterOfDrawerController:(UIViewController*)topVC {
    
    UINavigationController *centerNavVC = (UINavigationController*)(self.drawerController.centerViewController);
    
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

- (void)fetchAllCategories {
    
    [[GMOperationalHandler handler] fetchCategoriesFromServerWithSuccessBlock:^(GMCategoryModal *rootCategoryModal) {
        
        self.rootCategoryModal = rootCategoryModal;
        [self categoryLevelCategorization];
        [self.rootCategoryModal archiveRootCategory];
        
        GMLeftMenuVC *leftMenuVC = [[GMLeftMenuVC alloc] initWithNibName:@"GMLeftMenuVC" bundle:nil];
        self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:[GMTabBarVC new] leftDrawerViewController:[[UINavigationController alloc] initWithRootViewController:leftMenuVC]];
        self.drawerController.maximumLeftDrawerWidth = 260.0;
        
        self.navController.navigationBarHidden = YES;
        self.window.rootViewController = self.drawerController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)categoryLevelCategorization {
    
    GMCategoryModal *defaultCategory = self.rootCategoryModal.subCategories.firstObject;
    [self createCategoryLevelArchitecturForDisplay:defaultCategory.subCategories];
}

- (void)createCategoryLevelArchitecturForDisplay:(NSArray *)menuArray {
    
    for (GMCategoryModal *categoryModal in menuArray) {
        
        [self updateExpandPropertyOfSubCategory:categoryModal];
    }
}

- (void)updateExpandPropertyOfSubCategory:(GMCategoryModal *)categoryModal {
    
    if(categoryModal.subCategories.count) {
        
        BOOL expandStatus = [self checkIsCategoryExpanded:categoryModal.subCategories];
        [categoryModal setIsExpand:expandStatus];
        [self createCategoryLevelArchitecturForDisplay:categoryModal.subCategories]; // recursion for sub categories
    }
    else {
        
        [categoryModal setIsExpand:NO];
        return;
    }
}

// checking the two level categories count

- (BOOL)checkIsCategoryExpanded:(NSArray *)subCategoryArray {
    
    GMCategoryModal *subCatModal = subCategoryArray.firstObject;
    if(subCatModal.subCategories.count)
        return YES;
    else
        return NO;
}


@end
