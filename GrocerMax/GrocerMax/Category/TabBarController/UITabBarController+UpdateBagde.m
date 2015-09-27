//
//  UITabBarController+UpdateBagde.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 28/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "UITabBarController+UpdateBagde.h"
#import "GMCartModal.h"

@implementation UITabBarController (UpdateBagde)

- (void)updateBadgeValueOnCartTab{
    
    GMCartModal *cartModal = [GMCartModal loadCart];
    
    if (cartModal.cartItems.count)
        [[[self viewControllers][3] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",cartModal.cartItems.count]];
    else
        [[[self viewControllers][3] tabBarItem] setBadgeValue:nil];
}

@end
