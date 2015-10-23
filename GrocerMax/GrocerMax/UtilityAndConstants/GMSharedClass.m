//
//  GMSharedClass.m
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSharedClass.h"
#import "GMUserModal.h"
#import "GMStateBaseModal.h"
#import "Reachability.h"

#import <GoogleAnalytics/GAITracker.h>
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>
#import "GMCartModal.h"


#define kAlertTitle @"GrocerMax"

@interface GMSharedClass ()

@property (nonatomic) Reachability* reachability;

@end

@implementation GMSharedClass

static GMSharedClass *sharedHandler;

static NSString *const categoryImageUrlKey = @"com.GrocerMax.categoryImageUrlKey";
static NSString *const loggedInUserKey = @"com.GrocerMax.loggedInUserKey";
static NSString *const signedInUserKey = @"com.GroxcerMax.signedInUserKey";
static NSString *const userSelectedUserLocationKey = @"com.GroxcerMax.selectedUserLocation";

CGFloat const kMATabBarHeight = 49.0f;

#pragma mark - SharedInstance Method

+ (instancetype)sharedClass {
    
    if(!sharedHandler) {
        sharedHandler  = [[[self class] alloc] init];
        [sharedHandler setupReachability];
    }
    return sharedHandler;
}

#pragma mark - Error And Alert Messages

- (void) showErrorMessage:(NSString*)message{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:key_TitleMessage message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
    
//    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
//    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelError animated:YES];
}

- (void) showSuccessMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelPositive animated:YES];
}

- (void) showWarningMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelWarning animated:YES];
}

- (void) showInfoMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelInfo animated:YES];
}

#pragma mark -

+ (BOOL)validateEmail:(NSString*)emailString {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:emailString];
    return isValid;
}

+ (BOOL)validateMobileNumberWithString:(NSString*)mobile {
    
    if (!NSSTRING_HAS_DATA(mobile))
        return NO;
    
    NSString *phoneRegex = @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phoneTest evaluateWithObject:mobile];
    return isValid;
}

#pragma mark -

- (BOOL)getUserLoggedStatus {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:loggedInUserKey] boolValue];
}

- (void)setUserLoggedStatus:(BOOL)status {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(status) forKey:loggedInUserKey];
    [defaults synchronize];
}

#pragma mark- UITabBar Animation

- (BOOL)tabBarIsVisible:(UIViewController*)controller {
    
    return controller.tabBarController.tabBar.frame.origin.y < SCREEN_SIZE.height;
}

- (void)setTabBarVisible:(BOOL)visible ForController:(UIViewController *)controller animated:(BOOL)animated {
    
    if(visible)
        controller.tabBarController.tabBar.translucent = NO;
    else
        controller.tabBarController.tabBar.translucent = YES;
    
    if ([self tabBarIsVisible:controller] == visible) return;
    
    CGRect frame = controller.tabBarController.tabBar.frame;
    CGFloat offsetY = (visible)? -kMATabBarHeight : kMATabBarHeight;
    
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        controller.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)saveLoggedInUserWithData:(NSData *)userData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:signedInUserKey];
    [defaults synchronize];
}

- (GMUserModal *)getLoggedInUser {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:signedInUserKey];
    GMUserModal *archivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return archivedUser;
}

- (GMCityModal *)getSavedLocation {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:userSelectedUserLocationKey];
    GMCityModal *archivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return archivedUser;
}

- (void)saveSelectedLocationData:(NSData *)userData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:userSelectedUserLocationKey];
    [defaults synchronize];
}

- (void)logout {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:signedInUserKey];
    GMUserModal *archivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    archivedUser = nil;
    [GMUserModal clearUserModal];
    [defaults removeObjectForKey:signedInUserKey];
    [defaults setObject:@(NO) forKey:loggedInUserKey];
    [defaults synchronize];

}

#pragma mark - Network Reachbility Test

-(void)setupReachability
{
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(reachabilityChanged:)
    //                                                 name:kReachabilityChangedNotification
    //                                               object:nil];
    
    
    // Allocate a reachability object
    self.reachability = [Reachability reachabilityForInternetConnection];
    
    
    //    [self reachabilityChanged:nil];// force full call
    //    [self.internetReachable startNotifier];
}

//-(void) reachabilityChanged:(NSNotification *)notice
//{
//    // !!!!! Important!!! called after network status changes
//    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
//    switch (internetStatus)
//    {
//        case NotReachable:
//        {
//            NSLog(@"The internet is down.");
//            self.internetActive = NO;
//
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            NSLog(@"The internet is working via WIFI.");
//            self.internetActive = YES;
//
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            NSLog(@"The internet is working via WWAN.");
//            self.internetActive = YES;
//
//            break;
//        }
//    }
//}

- (BOOL)isInternetAvailable {
    
    return [self.reachability isReachable];
}

- (void)trakScreenWithScreenName:(NSString *)scrrenName {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:scrrenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)trakeEventWithName:(NSString *)eventName withCategory:(NSString *)category label:(NSString *)label value:(NSNumber *)value{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    if(!NSSTRING_HAS_DATA(category)) {
        category = @"Action";
    }
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:category
                                            action:eventName
                                             label:label
                                             value:value] build];
    [tracker send:event];
}

- (void)clearCart {
    
    GMCartModal *cartModal = [GMCartModal loadCart];
    [cartModal.cartItems removeAllObjects];
    [cartModal.deletedProductItems removeAllObjects];
    [cartModal archiveCart];
    GMUserModal *userModal = [self getLoggedInUser];
    userModal.quoteId = @"";
    [userModal persistUser];
}

-(NSMutableURLRequest *)requestHeader:(NSMutableURLRequest *)webRequest
{
    [webRequest setValue:kAppVersion forHTTPHeaderField:keyAppVersion];
    [webRequest setValue:kEY_iOS forHTTPHeaderField:kEY_device];
    return webRequest;

}

- (NSString *)getCategoryImageBaseUrl {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:categoryImageUrlKey];
}

- (void)setCategoryImageBaseUrl:(NSString *)baseurl {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:baseurl forKey:categoryImageUrlKey];
    [defaults synchronize];
}
- (NSMutableURLRequest *)setHeaderRequest:(NSMutableURLRequest *)headerRequest {
    [headerRequest setValue:kEY_iOS forKey:kEY_device];
    [headerRequest setValue:kAppVersion forKey:keyAppVersion];
    return headerRequest;
}
@end
