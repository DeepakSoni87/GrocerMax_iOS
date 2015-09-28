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
        [self getProducListFromServer];
    }
    
    [self.productListTblView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configureUI

- (void) configureUI {
    
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
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProductModal *productModal = [self.productBaseModal.productsListArray objectAtIndex:indexPath.row];
    
    if (productModal.promotion_level.length > 1 )
        return [GMProductListTableViewCell cellHeightForPromotionalLabel];
    
    return [GMProductListTableViewCell cellHeightForNonPromotionalLabel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
    vc.modal = self.productBaseModal.productsListArray[indexPath.row];
    vc.parentVC = self.parentVC;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - scrollView Delegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
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
            [self showProgress];
            [self.rootPageAPIController fetchDealProductListingDataForOffersORDeals:self.productRequestID];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - IBAction methods

- (void)addProductModalInCart:(GMProductModal *)productModal {
    
    if (![[GMSharedClass sharedClass] isInternetAvailable]) {
        
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"no_internet_connection")];
        return;
    }
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:productModal];
    GMProductModal *productCartModal = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    [self.parentVC.cartModal.cartItems addObject:productCartModal];
    [self.parentVC.cartModal archiveCart];
    
    NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] addToCartParameterDictionaryFromProductModal:productCartModal];
    [[GMOperationalHandler handler] addTocartGust:requestParam withSuccessBlock:nil failureBlock:nil];
    
    // first save the modal with there updated quantity then reset the quantity value to 1
    [productModal setProductQuantity:@"1"];
    [self.productListTblView reloadData];
    [self.tabBarController updateBadgeValueOnCartTab];
}

@end
