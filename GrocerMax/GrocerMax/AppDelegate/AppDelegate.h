//
//  AppDelegate.h
//  GrocerMax
//
//  Created by Deepak Soni on 08/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMNavigationController.h"

@class GMTabBarVC;
@class GMSearchVC;
@class GMProfileVC;
@class GMHomeVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) RZMessagingWindow *errorWindow;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GMNavigationController *navController;

@property (nonatomic, strong) MMDrawerController *drawerController;

@property (nonatomic, strong) GMTabBarVC *tabBarVC;

- (void)setTopVCOnCenterOfDrawerController:(UIViewController*)topVC;

- (void)setTopVCOnHotDealsController:(UIViewController*)topVC;

- (void)popToCenterViewController;

-(GMSearchVC*) rootSearchVCFromFourthTab;

-(GMHomeVC*) rootHomeVCFromFourthTab;

- (void)goToHomeWithAnimation:(BOOL)animation;

-(GMProfileVC*) rootProfileVCFromFourthTab;

-(void)ShowProcessingView;

-(void)HideProcessingView;
@end

