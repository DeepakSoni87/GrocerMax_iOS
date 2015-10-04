//
//  GMRootPageViewController.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMCartModal.h"

@interface GMRootPageViewController : UIViewController

@property (strong, nonatomic) NSArray *pageData;

@property (assign, nonatomic) GMRootPageViewControllerType rootControllerType;

@property (nonatomic, strong) GMCartModal *cartModal;

@property (nonatomic, strong) NSString *navigationTitleString;

@property (nonatomic, assign) BOOL isFromSearch;
@end
