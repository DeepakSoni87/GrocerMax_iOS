//
//  GMProductListingVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductListingVC.h"
#import "GMProductListTableViewCell.h"
#import "GMProductDescriptionVC.h"

NSString *const kGMProductListTableViewCell = @"GMProductListTableViewCell";

@interface GMProductListingVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,GMRootPageAPIControllerDelegate, GMProductListCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *tblFooterLoadMoreView;
@property (weak, nonatomic) IBOutlet UITableView *productListTblView;
@property (strong, nonatomic) GMProductListingBaseModal *productBaseModal;
@property (assign, nonatomic) BOOL isLoading;

@property (strong, nonatomic) NSString *productRequestID;

@end

@implementation GMProductListingVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self registerCellsForTableView];
    [self configureUI];
    
    self.rootPageAPIController.delegate = self;
    self.productRequestID = self.catMdl.categoryId;
    
    self.productBaseModal = [self.rootPageAPIController.modalDic objectForKey:self.productRequestID];
    
    if (self.productBaseModal.productsListArray.count == 0) {
        self.productBaseModal = [[GMProductListingBaseModal alloc] init];
        self.productBaseModal.productsListArray = self.catMdl.productListArray;
        self.productBaseModal.totalcount = self.catMdl.totalCount;//14/10/2015
        [self.rootPageAPIController.modalDic setObject:self.productBaseModal forKey:self.productRequestID];
    }
    
    if (self.productBaseModal.productsListArray.count == 0) {
        [self getProducListFromServer];
    }
    
    [self.productListTblView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_ProducList_Screen];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:self.gaTrackingEventText];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configureUI

- (void) configureUI {
    
    self.navigationItem.title = @"Product List";
    self.productListTblView.delegate = self;
    self.productListTblView.dataSource = self;
    self.productListTblView.tableFooterView = [UIView new];
}

#pragma mark - Register Cells

- (void)registerCellsForTableView {
    
    [self.productListTblView registerNib:[UINib nibWithNibName:@"GMProductListTableViewCell" bundle:nil] forCellReuseIdentifier:kGMProductListTableViewCell];
}

#pragma mark - UITableviewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.productBaseModal.productsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProductModal *productModal = [self.productBaseModal.productsListArray objectAtIndex:indexPath.row];
    GMProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGMProductListTableViewCell];
    cell.delegate = self;
    [cell configureCellWithProductModal:productModal andCartModal:self.parentVC.cartModal];
    [cell.imgBtn addTarget:self action:@selector(imgbtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProductModal *productModal = [self.productBaseModal.productsListArray objectAtIndex:indexPath.row];
    
    if (productModal.promotion_level.length > 1 ){
        return [GMProductListTableViewCell cellHeightForPromotionalLabelWithText:productModal.promotion_level];
    }
    
    return [GMProductListTableViewCell cellHeightForNonPromotionalLabel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
//    vc.modal = self.productBaseModal.productsListArray[indexPath.row];
//    vc.parentVC = self.parentVC;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - scrollView Delegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ProductListScrolling withCategory:@"" label:self.catMdl.categoryName value:nil];

    if(self.isLoading)
        return; // currently executing this method
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat targetY = scrollView.contentSize.height - scrollView.bounds.size.height;
    
    if (offsetY > targetY) { // hit api for next page
        
        if (self.productBaseModal.productsListArray.count < self.productBaseModal.totalcount) {
            self.isLoading = YES;
            self.productListTblView.tableFooterView = self.tblFooterLoadMoreView;
            [self getProducListFromServer];
        }
    }
    
}

#pragma mark -

- (void)rootPageAPIControllerDidFinishTask:(GMRootPageAPIController *)controller {
    
    self.isLoading = NO;
    self.productListTblView.tableFooterView = nil;
    self.productBaseModal = [self.rootPageAPIController.modalDic objectForKey:self.productRequestID];
    [self.productListTblView reloadData];
    
    [self removeProgress];
}

#pragma mark - API Hit

- (void)getProducListFromServer {
    
    switch (self.productListingType) {
            
        case GMProductListingFromTypeCategory:
        {
            [self.rootPageAPIController fetchProductListingDataForCategory:self.productRequestID];
        }
            break;
        case GMProductListingFromTypeOffer_OR_Deal:
        {
//            [self showProgress];
            [self.rootPageAPIController fetchDealProductListingDataForOffersORDeals:self.productRequestID];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - IBAction methods

- (void)imgbtnPressed:(GMButton*)sender {
    
    GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
    vc.modal = sender.produtModal;
    vc.parentVC = self.parentVC;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addProductModalInCart:(GMProductModal *)productModal {
    
    if (![[GMSharedClass sharedClass] isInternetAvailable]) {
        
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"no_internet_connection")];
        return;
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_AddCartitems withCategory:@"" label:productModal.productid value:nil];

    NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] addToCartParameterDictionaryFromProductModal:productModal];
    [[GMOperationalHandler handler] addTocartGust:requestParam withSuccessBlock:nil failureBlock:nil];
    self.parentVC.cartModal = [GMCartModal loadCart];
    [self.tabBarController updateBadgeValueOnCartTab];
}

@end
