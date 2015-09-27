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
#import "GMBillingAddressVC.h"
#import "GMShipppingAddressVC.h"
#import "GMEditProfileVC.h"
#import "GMCityVC.h"
#import "GMStateBaseModal.h"
#import "Sequencer.h"
#import "GMHotDealBaseModal.h"

#import "GMOffersByDealTypeModal.h"

#import "GMOrderDetailVC.h"
#import "GMSearchResultModal.h"


NSString *const pageControllCell = @"GMPageControllCell";
NSString *const shopByCategoryCell = @"GMShopByCategoryCell";
NSString *const shopByDealCell = @"GMShopByDealCell";

@interface GMHomeVC ()<UITableViewDataSource,UITableViewDelegate,GMPageControllCellDelegate,GMShopByCategoryCellDelegate,GMShopByDealCellDelegate,GMSearchBarViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tblView;
@property (nonatomic,strong) NSArray *categoriesArray;
@property (nonatomic,strong) NSArray *hotDealsArray;
@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;

@end

@implementation GMHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addLeftMenuButton];
    [self showSearchIconOnRightNavBarWithNavTitle:@"Home"];
    [self fetchAllCategoriesAndDeals];
    
    [self registerCellsForTableView];
    [self configureUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass]setTabBarVisible:YES ForController:self animated:YES];
    [self userSelectLocation];
    
    // if categoies exist in memory
    GMCategoryModal *mdl = [GMCategoryModal loadRootCategory];
    if (mdl != nil) {
        [self getShopByCategoriesFromServer];
    }
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
- (void)userSelectLocation {
    if([GMCityModal selectedLocation] == nil) {
        GMCityVC * cityVC  = [GMCityVC new];
        [self.navigationController pushViewController:cityVC animated:NO];
    }
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
            return 180;
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
    [cell configureCellWithData:self.hotDealsArray cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

#pragma mark - paggin cell Delegate

-(void)didSelectItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    NSLog(@"tbl Index = %li & Collection index = %li",(long)tblIndexPath.row,(long)collectionIndexpath.item);
}

#pragma mark - Categories cell Delegate

-(void)didSelectCategoryItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    

//    
//    GMShipppingAddressVC * billingAddressVC  = [GMShipppingAddressVC new];
//    [self.navigationController pushViewController:billingAddressVC animated:YES];
//    return;

    //
    //    GMCityVC * billingAddressVC  = [GMCityVC new];
    //    [self.navigationController pushViewController:billingAddressVC animated:YES];
    //    return;

    GMCategoryModal *catModal = [self.categoriesArray objectAtIndex:collectionIndexpath.row];
    
    GMSubCategoryVC * categoryVC  = [GMSubCategoryVC new];
    categoryVC.rootCategoryModal = catModal;
    [self.navigationController pushViewController:categoryVC animated:YES];
    
    NSLog(@"tbl Index = %li & Collection index = %li",(long)tblIndexPath.row,(long)collectionIndexpath.item);
}

-(void)offerBtnPressedAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    NSLog(@"offer tbl Index = %li & Collection index = %li",(long)tblIndexPath.row,(long)collectionIndexpath.item);
    GMCategoryModal *catModal = [self.categoriesArray objectAtIndex:collectionIndexpath.row];

    [self getOffersDealFromServerWithCatID:catModal.categoryId];
}

#pragma mark - Deal cell Delegate


-(void)didSelectDealItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    NSLog(@"tbl Index = %li & Collection index = %li",(long)tblIndexPath.row,(long)collectionIndexpath.item);
}

- (void)fetchAllCategoriesAndDeals {
    
    Sequencer *sequencer = [Sequencer new];
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        
        [self showProgress];
        [[GMOperationalHandler handler] fetchCategoriesFromServerWithSuccessBlock:^(GMCategoryModal *rootCategoryModal) {
            
            self.rootCategoryModal = rootCategoryModal;
            [self categoryLevelCategorization];
            [self.rootCategoryModal archiveRootCategory];
            GMCategoryModal *mdl = [GMCategoryModal loadRootCategory];
            NSLog(@"%@", mdl);
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
            GMCategoryModal *defaultCategory = mdl.subCategories.firstObject;
            self.categoriesArray = defaultCategory.subCategories;
            self.categoriesArray = [self.categoriesArray filteredArrayUsingPredicate:pred];
            
            [self.tblView reloadData];
            
            completion (nil);
        } failureBlock:^(NSError *error) {
            completion (nil);
        }];
    }];
    
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        
        [[GMOperationalHandler handler] shopByDealType:nil withSuccessBlock:^(GMHotDealBaseModal *hotDealBaseModal) {
            
            [hotDealBaseModal archiveHotDeals];
            self.hotDealsArray = [GMHotDealBaseModal loadHotDeals].hotDealArray;
            [self.tblView reloadData];

        } failureBlock:^(NSError *error) {
            
        }];
        completion (nil);
    }];
    
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        // get shop by categories
        [self getShopByCategoriesFromServer];
        
        completion (nil);
    }];

    [sequencer run];
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

#pragma mark - Get categories from server

-(void)getShopByCategoriesFromServer {
    
    [self showProgress];
    [[GMOperationalHandler handler] shopbyCategory:nil withSuccessBlock:^(id catArray) {
        
        NSArray *arr = catArray;
        
        for (NSDictionary *dic in arr) {
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.categoryId == %@", dic[kEY_category_id]];
            
            GMCategoryModal *defaultCategory = [[self.categoriesArray filteredArrayUsingPredicate:pred] firstObject];
            defaultCategory.offercount = dic[kEY_offercount];
        }
        [self.tblView reloadData];
        
        [self removeProgress];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

#pragma mark - offersByDeal

-(void)getOffersDealFromServerWithCatID:(NSString*)catID {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:catID forKey:kEY_cat_id];

    [self showProgress];
    [[GMOperationalHandler handler] getOfferByDeal:localDic withSuccessBlock:^(id offersByDealTypeBaseModal) {
        
        [self removeProgress];
        
        GMOffersByDealTypeBaseModal *baseMdl = offersByDealTypeBaseModal;
        
        if (baseMdl.allArray.count == 0 || baseMdl.deal_categoryArray == 0) {
            return ;
        }
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = @[@{@"All" : baseMdl.allArray}, @{@"Deal Category" : baseMdl.deal_categoryArray}];
        rootVC.rootControllerType = GMRootPageViewControllerTypeOffersByDealTypeListing;
        [self.navigationController pushViewController:rootVC animated:YES];

        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

#pragma mark - Search Bar Search Delegate

- (void)searchBarDidCancelSearching:(GMSearchBarView*)searchView{
    // set old title OR title view
    [self showSearchIconOnRightNavBarWithNavTitle:@"Home"];
}
- (void)searchBarDidFinishSearching:(GMSearchBarView*)searchView withSearchResult:(id)data{
    
    GMSearchResultModal *searchResultModal = data;

    if (searchResultModal.categorysListArray.count == 0) {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"noResultFound")];
        return;
    }
    // set old title OR title view
    [self showSearchIconOnRightNavBarWithNavTitle:@"Home"];

    GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
    rootVC.pageData = searchResultModal.categorysListArray;
    rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
    [self.navigationController pushViewController:rootVC animated:YES];
}

- (void)searchBarDidFailSearching:(GMSearchBarView*)searchView{
    // set old title OR title view
    [self showSearchIconOnRightNavBarWithNavTitle:@"Home"];
}


@end
