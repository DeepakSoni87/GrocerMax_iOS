//
//  GMHomeVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHomeVC.h"
#import "GMLoginVC.h"
#import "GMSubCategoryVC.h"
#import "GMOfferListVC.H"
#import "GMOrderHistryVC.h"
#import "GMOfferListVC.h"

@interface GMHomeVC ()
@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;
@end

@implementation GMHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self fetchAllCategories];
    [self addLeftMenuButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTapped:(id)sender {
    
//    GMOfferListVC *subCategoryVC = [GMOfferListVC new];
//    [self.navigationController pushViewController:subCategoryVC animated:YES];
//    
//    return;
    GMLoginVC *loginVC = [[GMLoginVC alloc] initWithNibName:@"GMLoginVC" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)fetchAllCategories {
    
    [[GMOperationalHandler handler] fetchCategoriesFromServerWithSuccessBlock:^(GMCategoryModal *rootCategoryModal) {
        
        self.rootCategoryModal = rootCategoryModal;
        [self categoryLevelCategorization];
        [self.rootCategoryModal archiveRootCategory];
        GMCategoryModal *mdl = [GMCategoryModal loadRootCategory];
        NSLog(@"%@", mdl);
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)categoryLevelCategorization {
    
    GMCategoryModal *defaultCategory = self.rootCategoryModal.subCategories.firstObject;
    [self createCategoryLevelArchitecturForDisplay:defaultCategory.subCategories];
}

- (void)createCategoryLevelArchitecturForDisplay:(NSArray *)menuArray {
    
    for (GMCategoryModal *categoryModal in menuArray) {
        
        [self updateExpandPropertyOfSubCategory:categoryModal];
    }
}

- (void)updateExpandPropertyOfSubCategory:(GMCategoryModal *)categoryModal {
    
    if(categoryModal.subCategories.count) {
        
        BOOL expandStatus = [self checkIsCategoryExpanded:categoryModal.subCategories];
        [categoryModal setIsExpand:expandStatus];
        [self createCategoryLevelArchitecturForDisplay:categoryModal.subCategories]; // recursion for sub categories
    }
    else {
        
        [categoryModal setIsExpand:NO];
        return;
    }
}

// checking the two level categories count

- (BOOL)checkIsCategoryExpanded:(NSArray *)subCategoryArray {
    
    GMCategoryModal *subCatModal = subCategoryArray.firstObject;
    if(subCatModal.subCategories.count)
        return YES;
    else
        return NO;
}
@end
