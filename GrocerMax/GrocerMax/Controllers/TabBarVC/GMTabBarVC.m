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
#import "GMSearchVC.h"

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
    [self.tabBar setTranslucent:NO];
    
    GMHomeVC *homeVC = [[GMHomeVC alloc] initWithNibName:@"GMHomeVC" bundle:nil];
    UIImage *homeVCTabImg = [[UIImage home_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *homeVCTabSelectedImg = [[UIImage home_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:homeVCTabImg selectedImage:homeVCTabSelectedImg];
    GMNavigationController *homeVCNavController = [[GMNavigationController alloc] initWithRootViewController:homeVC];

    UIViewController *viewController;
    
    if([[GMSharedClass sharedClass] getUserLoggedStatus]) {
        viewController = [[GMProfileVC alloc] initWithNibName:@"GMProfileVC" bundle:nil];
    }
    else {
        viewController = [[GMLoginVC alloc] initWithNibName:@"GMLoginVC" bundle:nil];
    }
    
    UIImage *profileVCTabImg = [[UIImage profile_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *profileVCTabSelectedImg = [[UIImage profile_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:profileVCTabImg selectedImage:profileVCTabSelectedImg];
    GMNavigationController *profileVCNavController = [[GMNavigationController alloc] initWithRootViewController:viewController];

    GMHotDealVC *hotDealVC = [[GMHotDealVC alloc] initWithNibName:@"GMHotDealVC" bundle:nil];
    UIImage *hotDealVCTabImg = [[UIImage offer_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *hotDealVCSelectedImg = [[UIImage offer_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    hotDealVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:hotDealVCTabImg selectedImage:hotDealVCSelectedImg];
    GMNavigationController *hotDealVCNavController = [[GMNavigationController alloc] initWithRootViewController:hotDealVC];
    
    GMSearchVC *searchVC = [[GMSearchVC alloc] initWithNibName:@"GMSearchVC" bundle:nil];
    UIImage *searchVCTabImg = [[UIImage search_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *searchVCTabSelectedImg = [[UIImage search_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:searchVCTabImg selectedImage:searchVCTabSelectedImg];
    GMNavigationController *searchVCNavController = [[GMNavigationController alloc] initWithRootViewController:searchVC];
    
    GMCartVC *cartVC = [[GMCartVC alloc] initWithNibName:@"GMCartVC" bundle:nil];
    UIImage *cartVCTabImg = [[UIImage cart_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *cartVCTabSelectedImg = [[UIImage cart_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    cartVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:cartVCTabImg selectedImage:cartVCTabSelectedImg];
    GMNavigationController *cartVCNavController = [[GMNavigationController alloc] initWithRootViewController:cartVC];

    
    self.viewControllers = @[homeVCNavController,profileVCNavController,hotDealVCNavController,searchVCNavController,cartVCNavController];
    
    // update Tab bar bagdge
    [self updateBadgeValueOnCartTab];
}

@end
