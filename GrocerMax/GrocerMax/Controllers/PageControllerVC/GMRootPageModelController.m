//
//  GMRootPageModelController.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRootPageModelController.h"
#import "GMCategoryModal.h"
#import "GMRootPageAPIController.h"
#import "GMProductListingVC.h"

@interface GMRootPageModelController ()

@property (strong, nonatomic) GMRootPageAPIController *rootPageAPIController;

@end

@implementation GMRootPageModelController


- (instancetype)init {
    self = [super init];
    if (self) {
        self.rootPageAPIController = [[GMRootPageAPIController alloc] init];
    }
    return self;
}

#pragma mark - methods

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    // Return the data view controller for the given index.
    if (([self.modelPageData count] == 0) || (index >= [self.modelPageData count])) {
        return nil;
    }
    
    switch (self.rootControllerType) {
        case  GMRootPageViewControllerTypeProductlisting:
        {
            GMProductListingVC *proListVC = [[GMProductListingVC alloc] initWithNibName:@"GMProductListingVC" bundle:nil];
            proListVC.catMdl = self.modelPageData[index];
            proListVC.rootPageAPIController = self.rootPageAPIController;

            return proListVC;
        }
            break;
        case GMRootPageViewControllerTypeOffersListing:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController{

    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    
    switch (self.rootControllerType) {
        case  GMRootPageViewControllerTypeProductlisting:
        {
            GMProductListingVC *proListVC = (GMProductListingVC*)viewController;
            return [self.modelPageData indexOfObject:proListVC.catMdl];
        }
            break;
        case GMRootPageViewControllerTypeOffersListing:
        {

        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (NSString*)titleNameFormModal:(id)mdl{
    
    switch (self.rootControllerType) {
        case  GMRootPageViewControllerTypeProductlisting:
        {
            GMCategoryModal *catMdl = mdl;
            return catMdl.categoryName;
        }
            break;
        case GMRootPageViewControllerTypeOffersListing:
        {

        }
            break;
            
        default:
            break;
    }
    
    return @"";
}


@end