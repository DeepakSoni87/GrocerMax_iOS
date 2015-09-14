//
//  AppDelegate.h
//  GrocerMax
//
//  Created by Deepak Soni on 08/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) RZMessagingWindow *errorWindow;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GMNavigationController *navController;


@end

