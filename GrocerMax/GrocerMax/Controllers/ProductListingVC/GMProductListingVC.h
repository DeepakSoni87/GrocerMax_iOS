//
//  GMProductListingVC.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRootPageAPIController.h"
#import "GMProductModal.h"
#import "GMCategoryModal.h"


@interface GMProductListingVC : UIViewController

@property (strong, nonatomic) GMCategoryModal *catMdl;
@property (strong, nonatomic) GMRootPageAPIController *rootPageAPIController;

@end
