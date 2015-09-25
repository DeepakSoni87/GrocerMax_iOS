//
//  GMTabBarVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMTabBarVC.h"
#import "GMNavigationController.h"
#import "GMHomeVC.h"
#import "GMProfileVC.h"
#import "GMHotDealVC.h"
#import "GMCartVC.h"
#import "GMLoginVC.h"

@interface GMTabBarVC ()

@end

@implementation GMTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configure UI

-(void)configureUI {
    
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.tintColor = [UIColor yellowColor];
    self.tabBar.clipsToBounds = YES;
    [self.tabBar setTranslucent:YES];
    
    GMHomeVC *homeVC = [[GMHomeVC alloc] initWithNibName:@"GMHomeVC" bundle:nil];
    UIImage *homeVCTabImg = [[UIImage imageNamed:@"home_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *homeVCTabSelectedImg = [[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:homeVCTabImg selectedImage:homeVCTabSelectedImg];
    GMNavigationController *homeVCNavController = [[GMNavigationController alloc] initWithRootViewController:homeVC];

    
    GMProfileVC *profileVC = [[GMProfileVC alloc] initWithNibName:@"GMProfileVC" bundle:nil];
    UIImage *profileVCTabImg = [[UIImage imageNamed:@"profile_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *profileVCTabSelectedImg = [[UIImage imageNamed:@"profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:profileVCTabImg selectedImage:profileVCTabSelectedImg];
    GMNavigationController *profileVCNavController = [[GMNavigationController alloc] initWithRootViewController:profileVC];

    
    GMHotDealVC *hotDealVC = [[GMHotDealVC alloc] initWithNibName:@"GMHotDealVC" bundle:nil];
    UIImage *hotDealVCTabImg = [[UIImage imageNamed:@"offer_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *hotDealVCSelectedImg = [[UIImage imageNamed:@"offer_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    hotDealVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:hotDealVCTabImg selectedImage:hotDealVCSelectedImg];
    GMNavigationController *hotDealVCNavController = [[GMNavigationController alloc] initWithRootViewController:hotDealVC];
    
    GMCartVC *cartVC = [[GMCartVC alloc] initWithNibName:@"GMCartVC" bundle:nil];
    UIImage *cartVCTabImg = [[UIImage imageNamed:@"cart_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *cartVCTabSelectedImg = [[UIImage imageNamed:@"cart_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    cartVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:cartVCTabImg selectedImage:cartVCTabSelectedImg];
    GMNavigationController *cartVCNavController = [[GMNavigationController alloc] initWithRootViewController:cartVC];


    self.viewControllers = @[homeVCNavController,profileVCNavController,hotDealVCNavController,cartVCNavController];
}

@end
