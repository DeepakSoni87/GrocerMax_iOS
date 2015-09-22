//
//  GMLeftMenuDetailVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLeftMenuDetailVC.h"
#import "GMLeftMenuCell.h"
#import "GMRootPageViewController.h"

@interface GMLeftMenuDetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *categoryDetailTableView;

/** This property stores hierarichal structure of categories */
@property (nonatomic, strong) NSMutableArray *menuCategorizationArray;
@end

static NSString * const kLeftMenuCellIdentifier                     = @"leftMenuCellIdentifier";

@implementation GMLeftMenuDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
    [self registerCellsForTableView];
    self.categoryDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI {
    
    [self.categoryNameLabel setText:self.subCategoryModal.categoryName];
    
}

- (void)registerCellsForTableView {
    
    [self.categoryDetailTableView registerNib:[UINib nibWithNibName:@"GMLeftMenuCell" bundle:nil] forCellReuseIdentifier:kLeftMenuCellIdentifier];
}

#pragma mark - Handler Methods

- (void)updateLevelsInMenuArray:(NSArray *)menuArray {
    
    for (GMCategoryModal *categoryModal in menuArray) {
        
        NSUInteger level = 0;
        [categoryModal setIndentationLevel:level];
        [self updateSubCategories:categoryModal withLevel:level + 1];
    }
}

- (void)updateSubCategories:(GMCategoryModal *)modal withLevel:(NSUInteger)level {
    
    [modal setIsSelected:NO];
    if(modal.subCategories.count) {
        
        for (GMCategoryModal *subCat in modal.subCategories) {
            
            [subCat setIndentationLevel:level];
            [self updateSubCategories:subCat withLevel:level + 1];
        }
    }
}

#pragma mark - GETTER/SETTER methods

- (NSMutableArray *)menuCategorizationArray {
    
    if(!_menuCategorizationArray) {
        
        [self updateLevelsInMenuArray:self.subCategoryModal.subCategories];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
        NSMutableArray *activeCategoriesArr = [NSMutableArray arrayWithArray:[self.subCategoryModal.subCategories filteredArrayUsingPredicate:pred]];
        
        _menuCategorizationArray = [NSMutableArray arrayWithArray:activeCategoriesArr];
    }
    return _menuCategorizationArray;
}

#pragma mark - UITableView Delegates/Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.menuCategorizationArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMLeftMenuCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMLeftMenuCell *filterCell = (GMLeftMenuCell*)[tableView dequeueReusableCellWithIdentifier:kLeftMenuCellIdentifier];
    GMCategoryModal *categoryModal = [self.menuCategorizationArray objectAtIndex:indexPath.row];
    [filterCell configureCellWith:categoryModal];
    return filterCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GMCategoryModal *categoryModal = (GMCategoryModal *)[self.menuCategorizationArray objectAtIndex:indexPath.row];
    GMLeftMenuCell *filterCell = (GMLeftMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(categoryModal.isExpand) {
        
        BOOL isAlreadyInserted = NO;
        
        for (GMCategoryModal *subCategoryModal in categoryModal.subCategories) {
            
            NSInteger index = [self.menuCategorizationArray indexOfObjectIdenticalTo:subCategoryModal];
            isAlreadyInserted = (index > 0 && index != NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        
        if(isAlreadyInserted) {
            
            [categoryModal setIsSelected:NO];
            [self miniMizeThisRows:categoryModal.subCategories];
        } else {
            
            [categoryModal setIsSelected:YES];
            NSUInteger count = indexPath.row + 1;
            NSMutableArray *arCells = [NSMutableArray array];
            for(GMCategoryModal *subCategoryModal in categoryModal.subCategories ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.menuCategorizationArray insertObject:subCategoryModal atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else {
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:categoryModal.subCategories];
        [arr insertObject:categoryModal atIndex:0];
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = arr;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [APP_DELEGATE setTopVCOnCenterOfDrawerController:rootVC];
    }
    //    [filterCell.expandButton setSelected:categoryModal.isSelected];
}


- (void)miniMizeThisRows:(NSArray*)subCategoriesArray {
    
    for(GMCategoryModal *subCategoryModal in subCategoriesArray ) {
        
        [subCategoryModal setIsSelected:NO];
        NSUInteger indexToRemove = [self.menuCategorizationArray indexOfObjectIdenticalTo:subCategoryModal];
        NSArray *arInner = subCategoryModal.subCategories;
        if(arInner && [arInner count] > 0){
            [self miniMizeThisRows:arInner];
        }
        if([self.menuCategorizationArray indexOfObjectIdenticalTo:subCategoryModal]!=NSNotFound) {
            [self.menuCategorizationArray removeObjectIdenticalTo:subCategoryModal];
            [self.categoryDetailTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                                  [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                                  ]
                                                withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - IBAction Methods

- (IBAction)backButtonTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
