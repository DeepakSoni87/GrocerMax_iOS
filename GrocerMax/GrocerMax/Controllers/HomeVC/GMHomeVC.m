//
//  GMHomeVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHomeVC.h"
#import "GMPageControllCell.h"
#import "GMShopByCategoryCell.h"
#import "GMShopByDealCell.h"
#import "GMRootPageViewController.h"
#import "GMSubCategoryVC.h"
#import "GMOfferListVC.H"
#import "GMOrderHistryVC.h"
#import "GMOfferListVC.h"
#import "GMHotDealVC.h"
#import "GMDeliveryDetailVC.h"

NSString *const pageControllCell = @"GMPageControllCell";
NSString *const shopByCategoryCell = @"GMShopByCategoryCell";
NSString *const shopByDealCell = @"GMShopByDealCell";

@interface GMHomeVC ()<UITableViewDataSource,UITableViewDelegate,GMPageControllCellDelegate,GMShopByCategoryCellDelegate,GMShopByDealCellDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tblView;
@property (nonatomic,strong) NSArray *categoriesArray;
@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;


@end

@implementation GMHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addLeftMenuButton];
    [self fetchAllCategories];
    
    [self registerCellsForTableView];
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configureUI

-(void) configureUI{
    
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    self.tblView.tableFooterView = [UIView new];
    
    
}

#pragma mark - Register Cells

- (void)registerCellsForTableView {
    
    [self.tblView registerNib:[UINib nibWithNibName:@"GMPageControllCell" bundle:nil] forCellReuseIdentifier:pageControllCell];
    [self.tblView registerNib:[UINib nibWithNibName:@"GMShopByCategoryCell" bundle:nil] forCellReuseIdentifier:shopByCategoryCell];
    [self.tblView registerNib:[UINib nibWithNibName:@"GMShopByDealCell" bundle:nil] forCellReuseIdentifier:shopByDealCell];
}

#pragma mark - UITableviewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return [self pageControllCellForTableView:tableView indexPath:indexPath];
        }
            break;
        case 1:
            return [self shopByCategoryCellForTableView:tableView indexPath:indexPath];
            break;
        case 2:
            return [self shopByDealCellForTableView:tableView indexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    // rare conditon
    static NSString *cellidentifire = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifire];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Section:%ld",(long)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return 160;
        }
            break;
        case 1:
            return 180;
            break;
            
        default:
            return 110;
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - cells

-(GMPageControllCell*)pageControllCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMPageControllCell *cell = [tableView dequeueReusableCellWithIdentifier:pageControllCell];
    [cell configureCellWithData:nil cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

-(GMShopByCategoryCell*)shopByCategoryCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMShopByCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:shopByCategoryCell];
    [cell configureCellWithData:self.categoriesArray cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

-(GMShopByDealCell*)shopByDealCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMShopByDealCell *cell = [tableView dequeueReusableCellWithIdentifier:shopByDealCell];
    [cell configureCellWithData:nil cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

#pragma mark - paggin cell Delegate

-(void)didSelectItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    NSLog(@"tbl Index = %li & Collection index = %li",(long)tblIndexPath.row,(long)collectionIndexpath.item);
}

#pragma mark - Categories cell Delegate

-(void)didSelectCategoryItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    GMCategoryModal *catModal = [self.categoriesArray objectAtIndex:collectionIndexpath.row];
    
    GMSubCategoryVC * categoryVC  = [GMSubCategoryVC new];
    categoryVC.rootCategoryModal = catModal;
    [self.navigationController pushViewController:categoryVC animated:YES];
    
    NSLog(@"tbl Index = %li & Collection index = %li",(long)tblIndexPath.row,(long)collectionIndexpath.item);
}

-(void)offerBtnPressedAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    NSLog(@"offer tbl Index = %li & Collection index = %li",(long)tblIndexPath.row,(long)collectionIndexpath.item);
}

#pragma mark - Deal cell Delegate


-(void)didSelectDealItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    NSLog(@"tbl Index = %li & Collection index = %li",(long)tblIndexPath.row,(long)collectionIndexpath.item);
}

- (void)fetchAllCategories {
    
    GMCategoryModal *mdl = [GMCategoryModal loadRootCategory];
    NSLog(@"%@", mdl);
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
    GMCategoryModal *defaultCategory = mdl.subCategories.firstObject;
    self.categoriesArray = defaultCategory.subCategories;
    self.categoriesArray = [self.categoriesArray filteredArrayUsingPredicate:pred];
    [self.tblView reloadData];
}
@end
