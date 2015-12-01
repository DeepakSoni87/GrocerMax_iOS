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
#import "GMHotDealVC.h"
#import "GMSearchVC.h"
#import "GMProfileVC.h"
#import "GMHomeBannerModal.h"
#import "GMOffersByDealTypeModal.h"
#import "GMDealCategoryBaseModal.h"
#import "GMRootPageViewController.h"
#import "UIGifImage.h"
#import <GoogleAnalytics/GAI.h>
#import "GMHotDealVC.h"
#import "GMStateBaseModal.h"
#import <SVProgressHUD/SVIndefiniteAnimatedView.h>

#define TAG_PROCESSING_INDECATOR 100090

static NSString *const kGaPropertyId = @"UA-64820863-1";
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 20;

@interface AppDelegate ()
{
    UIAlertView *alert;
}

//@property (nonatomic, strong) XHDrawerController *drawerController;
@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;
@property (nonatomic, strong) GMHomeBannerModal *pushModal;
@property (nonatomic, strong) SVIndefiniteAnimatedView *indefiniteAnimatedView;
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
    
    [AppsFlyerTracker sharedTracker].appleAppID = APPLE_APP_ID; // The Apple app ID. Example 34567899
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = AppsFyler_Key;
    
    
    //https://developers.google.com/identity/sign-in/ios/offline-access
    [self initializeGoogleAnalytics];
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    if (configureError != nil) {
//        NSLog(@"Error configuring the Google context: %@", configureError);
    }
    
    [GIDSignIn sharedInstance].clientID = @"522049028388-d290uain6f364tvk38ee8h82av0b7aep.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].serverClientID = @"522049028388-d290uain6f364tvk38ee8h82av0b7aep.apps.googleusercontent.com";
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    self.tabBarVC = [[GMTabBarVC alloc] init];
    
    GMLeftMenuVC *leftMenuVC = [[GMLeftMenuVC alloc] initWithNibName:@"GMLeftMenuVC" bundle:nil];
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.tabBarVC leftDrawerViewController:[[UINavigationController alloc] initWithRootViewController:leftMenuVC]];
    self.drawerController.maximumLeftDrawerWidth = 260.0;
    
    self.navController.navigationBarHidden = YES;
    self.window.rootViewController = self.drawerController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[AppsFlyerTracker sharedTracker] trackAppLaunch]; //***** THIS LINE IS MANDATORY *****
    
    [AppsFlyerTracker sharedTracker].delegate = self;
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
    if([[url absoluteString] rangeOfString:@"grocermax"].location != NSNotFound && [[url absoluteString] rangeOfString:@"grocermax"].location != NSNotFound)
    {
        
        if([GMCityModal selectedLocation] == nil) {
            return YES;
        }
    
        NSString *value = @"";
        NSString *name = @"";
        NSArray* componentsArray = [[url absoluteString] componentsSeparatedByString:@"?"];
        if([componentsArray count]>1)
        {
            NSString* paramsStr = [componentsArray objectAtIndex:1];
            NSArray* paramsArray = [paramsStr componentsSeparatedByString:@"&"];
            for(NSString* str in paramsArray)
            {
                NSArray* paramsValuesArray = [str componentsSeparatedByString:@"="];
                if([[paramsValuesArray objectAtIndex:0] isEqualToString:@"data"])
                {
                    value = [[paramsValuesArray objectAtIndex:1] stringByRemovingPercentEncoding];
                    
                } else if([[paramsValuesArray objectAtIndex:0] isEqualToString:@"name"])
                {
                    name = [[paramsValuesArray objectAtIndex:1] stringByRemovingPercentEncoding];
                    
                }
            }
        }
        
        if([[url absoluteString] rangeOfString:KEY_Banner_shopbydealtype].location != NSNotFound) {
            GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
            if (tabBarVC == nil)
                return YES;
            [tabBarVC.viewControllers objectAtIndex:2];
        } else if([[url absoluteString] rangeOfString:KEY_Banner_search].location != NSNotFound) {
            
            NSMutableDictionary *localDic = [NSMutableDictionary new];
            [localDic setObject:value forKey:kEY_keyword];
            
            [self.tabBarVC  setSelectedIndex:3];
            GMSearchVC *searchVC = [APP_DELEGATE rootSearchVCFromFourthTab];
            if (searchVC == nil)
                return YES;
            [searchVC performSearchOnServerWithParam:localDic isBanner:YES];
            

        } else if([[url absoluteString] rangeOfString:KEY_Banner_offerbydealtype].location != NSNotFound) {
            GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
            bannerCatMdl.categoryId = value;
            if(NSSTRING_HAS_DATA(self.pushModal.name)) {
                bannerCatMdl.categoryName = self.pushModal.name;
            } else {
                bannerCatMdl.categoryName = @"Result";
            }            
            [self getOffersDealFromServerWithCategoryModal:bannerCatMdl];
            
            
        } else if([[url absoluteString] rangeOfString:KEY_Banner_dealsbydealtype].location != NSNotFound) {
            
            [self fetchDealCategoriesFromServerWithDealTypeId:value];
            
        } else if([[url absoluteString] rangeOfString:KEY_Banner_productlistall].location != NSNotFound) {
            
            GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
            bannerCatMdl.categoryId = value;
            if(NSSTRING_HAS_DATA(self.pushModal.name)) {
                bannerCatMdl.categoryName = self.pushModal.name;
            } else {
                bannerCatMdl.categoryName = @"Result";
            }
            
            [self fetchProductListingDataForCategory:bannerCatMdl];
            
            
        } else if([[url absoluteString] rangeOfString:KEY_Banner_dealproductlisting].location != NSNotFound) {
            
            GMHotDealVC *hotDealVC = [self rootHotDealVCFromThirdTab];
            if (hotDealVC == nil)
                return YES;
            
            GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
            bannerCatMdl.categoryId = value;
            if(NSSTRING_HAS_DATA(name)) {
                bannerCatMdl.categoryName = name;
            } else {
                bannerCatMdl.categoryName = @"Result";
            }
            [hotDealVC fetchDealProductListingDataForOffersORDeals:bannerCatMdl];
            
            
        }
        

        return YES;
        
    }else if (isFB) {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    BOOL isFB = YES;
    if([[url absoluteString] rangeOfString:@"grocermax"].location != NSNotFound && [[url absoluteString] rangeOfString:@"grocermax"].location != NSNotFound)
    {
        
        NSString *value = @"";
        NSString *name = @"";
        NSArray* componentsArray = [[url absoluteString] componentsSeparatedByString:@"?"];
        if([componentsArray count]>1)
        {
            NSString* paramsStr = [componentsArray objectAtIndex:1];
            NSArray* paramsArray = [paramsStr componentsSeparatedByString:@"&"];
            for(NSString* str in paramsArray)
            {
                NSArray* paramsValuesArray = [str componentsSeparatedByString:@"="];
                if([[paramsValuesArray objectAtIndex:0] isEqualToString:@"data"])
                {
                    value = [[paramsValuesArray objectAtIndex:1] stringByRemovingPercentEncoding];
                    
                } else if([[paramsValuesArray objectAtIndex:0] isEqualToString:@"name"])
                {
                    name = [[paramsValuesArray objectAtIndex:1] stringByRemovingPercentEncoding];
                    
                }
            }
        }
        
        if([[url absoluteString] rangeOfString:KEY_Banner_shopbydealtype].location != NSNotFound) {
            GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
            if (tabBarVC == nil)
                return YES;
            [tabBarVC.viewControllers objectAtIndex:2];
        } else if([[url absoluteString] rangeOfString:KEY_Banner_search].location != NSNotFound) {
            
            NSMutableDictionary *localDic = [NSMutableDictionary new];
            [localDic setObject:value forKey:kEY_keyword];
            
            [self.tabBarVC  setSelectedIndex:3];
            GMSearchVC *searchVC = [APP_DELEGATE rootSearchVCFromFourthTab];
            if (searchVC == nil)
                return YES;
            [searchVC performSearchOnServerWithParam:localDic isBanner:YES];
            
            
        } else if([[url absoluteString] rangeOfString:KEY_Banner_offerbydealtype].location != NSNotFound) {
            GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
            bannerCatMdl.categoryId = value;
            if(NSSTRING_HAS_DATA(self.pushModal.name)) {
                bannerCatMdl.categoryName = self.pushModal.name;
            } else {
                bannerCatMdl.categoryName = @"Result";
            }
            [self getOffersDealFromServerWithCategoryModal:bannerCatMdl];
            
            
        } else if([[url absoluteString] rangeOfString:KEY_Banner_dealsbydealtype].location != NSNotFound) {
            
            [self fetchDealCategoriesFromServerWithDealTypeId:value];
            
        } else if([[url absoluteString] rangeOfString:KEY_Banner_productlistall].location != NSNotFound) {
            
            GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
            bannerCatMdl.categoryId = value;
            if(NSSTRING_HAS_DATA(self.pushModal.name)) {
                bannerCatMdl.categoryName = self.pushModal.name;
            } else {
                bannerCatMdl.categoryName = @"Result";
            }
            
            [self fetchProductListingDataForCategory:bannerCatMdl];
            
            
        } else if([[url absoluteString] rangeOfString:KEY_Banner_dealproductlisting].location != NSNotFound) {
            
            GMHotDealVC *hotDealVC = [self rootHotDealVCFromThirdTab];
            if (hotDealVC == nil)
                return YES;
            
            GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
            bannerCatMdl.categoryId = value;
            if(NSSTRING_HAS_DATA(name)) {
                bannerCatMdl.categoryName = name;
            } else {
                bannerCatMdl.categoryName = @"Result";
            }
            [hotDealVC fetchDealProductListingDataForOffersORDeals:bannerCatMdl];
            
            
        }
        
        
        return YES;
        
    }else if (isFB) {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:@""
                                                           annotation:options];
    }
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:@""
                                      annotation:options];
    
}

#pragma mark - PushNotification Delgate

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSLog(@"My Device token is: %@", deviceToken);
    
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:kEY_notification_token];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self sendDeviceToken:deviceTokenString];
    
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    if([application applicationState] == UIApplicationStateActive)
    {
        if(alert)
        {
            [alert dismissWithClickedButtonIndex:-1 animated:YES];
            alert = nil;
        }
        self.pushModal = nil;
        [self makePushModal:userInfo];
        NSString *alertMsg = @"Notification";
        if( [[userInfo objectForKey:Keyaps] objectForKey:Keyalert] != NULL && [[[userInfo objectForKey:Keyaps] objectForKey:Keyalert] isKindOfClass:[NSString class]])
            alertMsg = [[userInfo objectForKey:Keyaps] objectForKey:Keyalert];
        
        alert = [[UIAlertView alloc]initWithTitle:key_TitleMessage  message:alertMsg delegate:self cancelButtonTitle:Cancel_Text otherButtonTitles:@"GO",nil, nil];
        [alert show];
        
    }
    else if([application applicationState] == UIApplicationStateBackground)
    {
        self.pushModal = nil;
        [self makePushModal:userInfo];
        [self goFromNotifiedScreen];
    }
    else
    {
        self.pushModal = nil;
        [self makePushModal:userInfo];
        [self goFromNotifiedScreen];
    }
}
#pragma mark - Push Modal maker Method

- (void)makePushModal:(NSDictionary *)dataResultDec {
    
    if([dataResultDec objectForKey:@"data"] && [[dataResultDec objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resultDec = [dataResultDec objectForKey:@"data"];
        self.pushModal = [[GMHomeBannerModal alloc] initWithDictionary:resultDec];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex == 1)
        {
                [self performSelector:@selector(goFromNotifiedScreen) withObject:nil afterDelay:0];
        }
}

#pragma mark - Notification Handle Method

- (void)sendDeviceToken:(NSString*)deviceToken {
    
    NSMutableDictionary *deviceDic = [NSMutableDictionary new];
    [deviceDic setObject:deviceToken forKey:@"deviceToken"];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    if(userModal != nil && NSSTRING_HAS_DATA(userModal.userId)) {
        [deviceDic setObject:userModal.userId forKey:kEY_userid];
    }
    
    [[GMOperationalHandler handler] deviceToken:deviceDic withSuccessBlock:^(id responceData) {
        
        
    } failureBlock:^(NSError *error) {

    }];
}

- (void) goFromNotifiedScreen {
    
    if (!NSSTRING_HAS_DATA(self.pushModal.linkUrl)) {
        return;
    }
    
    NSArray *typeStringArr = [self.pushModal.linkUrl componentsSeparatedByString:@"?"];
    NSString *typeStr = typeStringArr.firstObject;
    NSArray *valueStringArr = [self.pushModal.linkUrl componentsSeparatedByString:@"="];
    NSString *value = valueStringArr.lastObject;
    
    if ([self.pushModal.linkUrl isEqualToString:KEY_Banner_shopbydealtype]) {
            GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return;
            [tabBarVC.viewControllers objectAtIndex:2];
        return;
    }
    
    if (!(NSSTRING_HAS_DATA(typeStr) && NSSTRING_HAS_DATA(value))) {
        return;
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_BannerSelection withCategory:self.pushModal.linkUrl label:value value:nil];
    
    if ([typeStr isEqualToString:KEY_Banner_search]) {
        
        NSMutableDictionary *localDic = [NSMutableDictionary new];
        [localDic setObject:value forKey:kEY_keyword];
        
        [self.tabBarVC  setSelectedIndex:3];
        GMSearchVC *searchVC = [APP_DELEGATE rootSearchVCFromFourthTab];
        if (searchVC == nil)
            return;
        [searchVC performSearchOnServerWithParam:localDic isBanner:YES];
        
    }else if ([typeStr isEqualToString:KEY_Banner_offerbydealtype]) {
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(self.pushModal.name)) {
            bannerCatMdl.categoryName = self.pushModal.name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
//        bannerCatMdl.categoryName = @"Banner Result";
        
        [self getOffersDealFromServerWithCategoryModal:bannerCatMdl];
        
    }else if ([typeStr isEqualToString:KEY_Banner_dealsbydealtype]) {
        
        [self fetchDealCategoriesFromServerWithDealTypeId:value];
        
    }else if ([typeStr isEqualToString:KEY_Banner_productlistall]) {
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(self.pushModal.name)) {
            bannerCatMdl.categoryName = self.pushModal.name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
//        bannerCatMdl.categoryName = @"Banner Result";
        
        [self fetchProductListingDataForCategory:bannerCatMdl];
    } else if ([typeStr isEqualToString:KEY_Banner_dealproductlisting]) {
        
        GMHotDealVC *hotDealVC = [self rootHotDealVCFromThirdTab];
        if (hotDealVC == nil)
            return;
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
//        bannerCatMdl.categoryName = @"Banner Result";
        if(NSSTRING_HAS_DATA(self.pushModal.name)) {
            bannerCatMdl.categoryName = self.pushModal.name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
        
        [hotDealVC fetchDealProductListingDataForOffersORDeals:bannerCatMdl];
    }

    
}

#pragma mark - offersByDeal

- (void)getOffersDealFromServerWithCategoryModal:(GMCategoryModal*)categoryModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:categoryModal.categoryId forKey:kEY_cat_id];
    [localDic setObject:kEY_iOS forKey:kEY_device];
    
    [self ShowProcessingView];
    [[GMOperationalHandler handler] getOfferByDeal:localDic withSuccessBlock:^(id offersByDealTypeBaseModal) {
        
        [self HideProcessingView];
        
        GMOffersByDealTypeBaseModal *baseMdl = offersByDealTypeBaseModal;
        
        if (baseMdl.allArray.count == 0 || baseMdl.deal_categoryArray == 0) {
            return ;
        }
        
        NSMutableArray *offersByDealTypeArray = [self createOffersByDealTypeModalFrom:baseMdl];
        
        if (offersByDealTypeArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            return ;
        }
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = offersByDealTypeArray;
        rootVC.navigationTitleString = categoryModal.categoryName;
        rootVC.rootControllerType = GMRootPageViewControllerTypeOffersByDealTypeListing;
       GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:rootVC animated:YES];
        
        
    } failureBlock:^(NSError *error) {
        [self HideProcessingView];
    }];
}

- (NSMutableArray *)createOffersByDealTypeModalFrom:(GMOffersByDealTypeBaseModal *)baseModal {
    
    NSMutableArray *offersByDealTypeArray = [NSMutableArray array];
    GMOffersByDealTypeModal *allModal = [[GMOffersByDealTypeModal alloc] initWithDealType:@"All" dealId:@"" dealImageUrl:@"" andDealsArray:baseModal.allArray];
    [offersByDealTypeArray addObject:allModal];
    [offersByDealTypeArray addObjectsFromArray:baseModal.deal_categoryArray];
    return offersByDealTypeArray;
}

#pragma nark - Fetching Hot Deals Methods

- (void)fetchDealCategoriesFromServerWithDealTypeId:(NSString *)dealTypeId {
    
    [self ShowProcessingView];
    [[GMOperationalHandler handler] dealsByDealType:@{kEY_deal_type_id :dealTypeId, kEY_device : kEY_iOS} withSuccessBlock:^(GMDealCategoryBaseModal *dealCategoryBaseModal) {
        
        [self HideProcessingView];
        NSMutableArray *dealCategoryArray = [self createCategoryDealsArrayWith:dealCategoryBaseModal];

        if (dealCategoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            return ;
        }
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = dealCategoryArray;
        rootVC.navigationTitleString = [dealCategoryBaseModal.dealNameArray firstObject];
        rootVC.rootControllerType = GMRootPageViewControllerTypeDealCategoryTypeListing;
        [APP_DELEGATE setTopVCOnHotDealsController:rootVC];
        
    } failureBlock:^(NSError *error) {
        
        [self HideProcessingView];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

- (NSMutableArray *)createCategoryDealsArrayWith:(GMDealCategoryBaseModal *)dealCategoryBaseModal {
    
    NSMutableArray *dealCategoryArray = [NSMutableArray arrayWithArray:dealCategoryBaseModal.dealCategories];
    GMDealCategoryModal *allModal = [[GMDealCategoryModal alloc] initWithCategoryId:@"" images:@"" categoryName:@"All" isActive:@"1" andDeals:dealCategoryBaseModal.allDealCategory];
    [dealCategoryArray insertObject:allModal atIndex:0];
    return dealCategoryArray;
}

#pragma mark - fetchProductListingDataForCategory

- (void)fetchProductListingDataForCategory:(GMCategoryModal*)categoryModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:categoryModal.categoryId forKey:kEY_cat_id];
    
    [self ShowProcessingView];
    [[GMOperationalHandler handler] productListAll:localDic withSuccessBlock:^(id productListingBaseModal) {
        [self HideProcessingView];
        
        GMProductListingBaseModal *productListingBaseMdl = productListingBaseModal;
        
        // All Cat list side by ALL Tab
        NSMutableArray *categoryArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.hotProductListArray) {
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // All products, for ALL Tab category
        NSMutableArray *allCatProductListArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.productsListArray) {
            [allCatProductListArray addObjectsFromArray:catMdl.productListArray];
            
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // set all product list in ALL tab category mdl
        categoryModal.productListArray = allCatProductListArray;
        
        // set this cat modal as ALL tab
        [categoryArray insertObject:categoryModal atIndex:0];
        
        if (categoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            return ;
        }
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.navigationTitleString = categoryModal.categoryName;
        GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:rootVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self HideProcessingView];
    }];
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

-(GMHotDealVC*) rootHotDealVCFromThirdTab {
    
    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *hotdealNavVC = [tabBarVC.viewControllers objectAtIndex:2];
        
        GMHotDealVC *hotDealVC = [hotdealNavVC viewControllers][0];
        return hotDealVC;
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

-(GMProfileVC*) rootProfileVCFromFourthTab {
    
    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *profileNavVC = [tabBarVC.viewControllers objectAtIndex:1];
        
        GMProfileVC *profileVC = [profileNavVC viewControllers][0];
        return profileVC;
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    
    return nil;
}

-(GMHomeVC*) rootHomeVCFromFourthTab {
    
    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *homeNavVC = [tabBarVC.viewControllers objectAtIndex:0];
        
        GMHomeVC *homeVC = [homeNavVC viewControllers][0];
        return homeVC;
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    
    return nil;
}

#pragma mark activity indicator
-(void)ShowProcessingView
{
    if([self.window viewWithTag:TAG_PROCESSING_INDECATOR])
        [[self.window viewWithTag:TAG_PROCESSING_INDECATOR] removeFromSuperview];
    
    UIView *processingAlertView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    [processingAlertView setTag:TAG_PROCESSING_INDECATOR];
    [processingAlertView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    self.indefiniteAnimatedView.center = processingAlertView.center;
    [processingAlertView addSubview:self.indefiniteAnimatedView];
    [self.window addSubview:processingAlertView];
    
    // NSLog(@"Show------>");
    
}

-(void)HideProcessingView
{
    UIView *processsingView = [self.window viewWithTag:TAG_PROCESSING_INDECATOR];
    [processsingView removeFromSuperview];
    
    // NSLog(@"Hide------>");
    
}

- (SVIndefiniteAnimatedView *)indefiniteAnimatedView {
    if (_indefiniteAnimatedView == nil) {
        _indefiniteAnimatedView = [[SVIndefiniteAnimatedView alloc] initWithFrame:CGRectZero];
        _indefiniteAnimatedView.strokeThickness = 2.0;
        _indefiniteAnimatedView.strokeColor = [UIColor gmOrangeColor];
        _indefiniteAnimatedView.radius = 24;
        [_indefiniteAnimatedView sizeToFit];
    }
    return _indefiniteAnimatedView;
}

#pragma AppsFlyerTrackerDelegate methods
- (void) onConversionDataReceived:(NSDictionary*) installData{
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a none organic install.");
        NSLog(@"Media source: %@",sourceID);
        NSLog(@"Campaign: %@",campaign);
    } else if([status isEqualToString:@"Organic"]) {
//        NSLog(@"This is an organic install.");
    }
}

- (void) onConversionDataRequestFailure:(NSError *)error{
    NSLog(@"Failed to get data from AppsFlyer's server: %@",[error localizedDescription]);
}
@end
