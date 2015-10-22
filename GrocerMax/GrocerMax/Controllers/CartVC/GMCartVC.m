//
//  GMCartVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartVC.h"
#import "GMCartModal.h"
#import "GMCartDetailModal.h"
#import "GMCartCell.h"
#import "GMShipppingAddressVC.h"
#import "GMLoginVC.h"
#import "GMParentController.h"


@interface GMCartVC () <UITableViewDataSource, UITableViewDelegate, GMCartCellDelegate>

@property (strong, nonatomic) GMNavigationController *loginNavigationController;

@property (weak, nonatomic) IBOutlet UITableView *cartDetailTableView;

@property (weak, nonatomic) IBOutlet UIView *totalView;

@property (nonatomic, strong) GMCartDetailModal *cartDetailModal;

@property (weak, nonatomic) IBOutlet UIButton *updateOrderButton;

@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;

@property (nonatomic, strong) GMCartModal *cartModal;

@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *shippingChargeLabel;

@property (weak, nonatomic) IBOutlet UILabel *savedLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (nonatomic, strong) GMCheckOutModal *checkOutModal;

@property (weak, nonatomic) IBOutlet UILabel *totalItemInCartLbl;

@property (weak, nonatomic) IBOutlet UIImageView *dottedImageView;

@property (nonatomic, strong) NSString *messageString;
@end

static NSString * const kCartCellIdentifier    = @"cartCellIdentifier";

@implementation GMCartVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.messageString = @"Fetching your cart items from server.";
    [self.totalView setHidden:YES];
    [self.placeOrderButton setHidden:YES];
    [self registerCellsForTableView];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_TabCart withCategory:@"" label:nil value:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    self.messageString = @"Fetching your cart items from server.";
    self.cartModal = [GMCartModal loadCart];
    //    if(self.cartModal)
    [self fetchCartDetailFromServer];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Cart_Screen];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [self updateOrderButtonTapped:nil];
}

- (void)registerCellsForTableView {
    
    [self.cartDetailTableView registerNib:[UINib nibWithNibName:@"GMCartCell" bundle:nil] forCellReuseIdentifier:kCartCellIdentifier];
}

#pragma mark - GETTER/SETTER Methods

//- (void)setTotalView:(UIView *)totalView {
//    
//    _totalView = totalView;
//    _totalView.layer.cornerRadius = 5.0;
//    _totalView.layer.masksToBounds = YES;
//    _totalView.layer.borderWidth = 0.8;
//    _totalView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
//}

#pragma mark - Server handling Method
- (void)fetchCartDetailFromServer {
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    if(!NSSTRING_HAS_DATA(userModal.quoteId)) {
        self.cartDetailModal = nil;
        self.cartDetailModal = nil;
        [self.totalView setHidden:YES];
        [self.dottedImageView setHidden:YES];
        [self.placeOrderButton setHidden:YES];
        self.messageString = @"No item in your cart, Please add item.";
        [self.cartDetailTableView reloadData];
        return;
    }
    NSDictionary *requestDict = [[GMCartRequestParam sharedCartRequest] cartDetailRequestParameter];
    [self showProgress];
    [[GMOperationalHandler handler] cartDetail:requestDict withSuccessBlock:^(GMCartDetailModal *cartDetailModal) {
        
        [self removeProgress];
        if(cartDetailModal.productItemsArray.count > 0) {
            
            self.cartDetailModal = cartDetailModal;
            self.cartModal = nil;
            self.cartModal = [[GMCartModal alloc] initWithCartDetailModal:cartDetailModal];
            [self.cartModal archiveCart];
            [self.tabBarController updateBadgeValueOnCartTab];
            [self.totalView setHidden:NO];
            [self.dottedImageView setHidden:NO];
            [self.placeOrderButton setHidden:NO];
            [self.updateOrderButton setHidden:YES];
            [self configureAmountView];

            [self setTotalCount];

            [self checkIsAnyItemOutOfStock];

        } else {
            self.cartDetailModal = nil;
            [self.totalView setHidden:YES];
            [self.placeOrderButton setHidden:YES];
            [self.dottedImageView setHidden:YES];
            self.messageString = @"No item in your cart, Please add item.";
        }
        [self.cartDetailTableView reloadData];
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        self.messageString = @"Problem to fetch your cart.";
        [self.totalView setHidden:YES];
        [self.updateOrderButton setHidden:YES];
        [self.placeOrderButton setHidden:YES];
        [self.dottedImageView setHidden:YES];
        [self.cartDetailTableView reloadData];
    }];
}

- (void)configureAmountView {
    
    [self.subTotalLabel setText:[NSString stringWithFormat:@"₹%.2f", self.cartDetailModal.subTotal.doubleValue]];
    [self.shippingChargeLabel setText:[NSString stringWithFormat:@"₹%.2f", self.cartDetailModal.shippingAmount.doubleValue]];
    [self.totalLabel setText:[NSString stringWithFormat:@"₹%.2f", self.cartDetailModal.grandTotal.doubleValue]];
    double savingAmount = [self getSavedAmount];
    [self.savedLabel setText:[NSString stringWithFormat:@"₹%.2f", savingAmount]];
}

- (double)getSavedAmount {
    
    double saving = 0;
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
    }
    if(NSSTRING_HAS_DATA(self.cartDetailModal.discountAmount))
        saving = saving - self.cartDetailModal.discountAmount.doubleValue;
    return saving;
}

- (void)updateAmountViewWhenQuantityChanged {
    
    [self.shippingChargeLabel setText:[NSString stringWithFormat:@"₹%.2f", self.cartDetailModal.shippingAmount.doubleValue]];
    double saving = 0;
    double subtotal = 0;
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
        subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
    }
    if(NSSTRING_HAS_DATA(self.cartDetailModal.discountAmount))
        saving = saving - self.cartDetailModal.discountAmount.doubleValue;
    [self.subTotalLabel setText:[NSString stringWithFormat:@"₹%.2f", subtotal]];
    [self.savedLabel setText:[NSString stringWithFormat:@"₹%.2f", saving]];
    double grandTotal = subtotal + self.cartDetailModal.shippingAmount.doubleValue;
    [self.totalLabel setText:[NSString stringWithFormat:@"₹%.2f", grandTotal]];
}

- (void)checkIsAnyItemOutOfStock {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.Status == %@", @"0"];
    NSArray *filteredArr = [self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:pred];
    if(filteredArr.count) {
        
        [self.placeOrderButton setHidden:YES];
        [self.updateOrderButton setHidden:NO];
    }
}

#pragma mark - UITableView Delegates/Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.cartDetailModal.productItemsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProductModal *productModal = [self.cartDetailModal.productItemsArray objectAtIndex:indexPath.row];
    if(NSSTRING_HAS_DATA(productModal.promotion_level))
        return [GMCartCell cellHeightForPromotionalLabelWithText:productModal.promotion_level];
    else
        return [GMCartCell cellHeightWithNoPromotion];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.cartDetailModal.productItemsArray.count>0) {
        return 0;
    }
    else {
        return tableView.frame.size.height;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(self.cartDetailModal.productItemsArray.count>0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CGRectGetHeight(tableView.bounds))];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CGRectGetHeight(tableView.bounds))];
    [headerLabel setTextColor:[UIColor darkTextColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:headerLabel];
    [headerLabel setText:self.messageString];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProductModal *productModal = [self.cartDetailModal.productItemsArray objectAtIndex:indexPath.row];
    GMCartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:kCartCellIdentifier];
    [cartCell.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cartCell setDelegate:self];
    [cartCell configureViewWithProductModal:productModal];
    return cartCell;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CartScroller withCategory:@"" label:nil value:nil];
}
#pragma mark - GMCartCellDelegate Methods

- (void)productQuantityValueChanged {
    
    [self.placeOrderButton setHidden:YES];
    [self.updateOrderButton setHidden:NO];
    [self updateAmountViewWhenQuantityChanged];
    [self setTotalCount];
}

#pragma mark - IBAction Methods

- (void)deleteButtonTapped:(GMButton *)sender {
    
    GMProductModal *deletedProductModal = [[GMProductModal alloc] initWithProductModal:sender.produtModal];
    [self.cartDetailModal.deletedProductItemsArray addObject:deletedProductModal];
    [self.cartDetailModal.productItemsArray removeObject:sender.produtModal];
    [self productQuantityValueChanged];
    [self removeObjectFromCartArrayWithModal:sender.produtModal];
    if(self.cartDetailModal.productItemsArray.count == 0) {
        [self backButtonTapped:nil];
    }
    [self.cartDetailTableView reloadData];
}

- (void)removeObjectFromCartArrayWithModal:(GMProductModal *)productModal {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", productModal.productid];
    NSArray *filteredArr = [self.cartModal.cartItems filteredArrayUsingPredicate:pred];
    GMProductModal *deleteProductModal = filteredArr.firstObject;
    if(deleteProductModal)
        [self.cartModal.cartItems removeObject:deleteProductModal];
    [self removeFreeItemsFromCartWhenAllCartPricedItemDeleted];
    [self.cartModal archiveCart];
    [self.tabBarController updateBadgeValueOnCartTab];
}

- (void)removeFreeItemsFromCartWhenAllCartPricedItemDeleted {
    
    NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(GMProductModal *evaluatedObject, NSDictionary *bindings) {
        
        if(evaluatedObject.sale_price.integerValue == 0)
            return YES;
        else
            return NO;
    }];
    NSArray *freeItemsArray = [self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:pred];
    if(self.cartDetailModal.productItemsArray.count == freeItemsArray.count) {
        
        [self.cartDetailModal.productItemsArray removeAllObjects];
        [self.cartModal.cartItems removeAllObjects];
    }
}

- (IBAction)placeOrderButtonTapped:(id)sender {
    
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CartPlaceOrder withCategory:@"" label:nil value:nil];
    
    if(self.cartDetailModal.productItemsArray.count) {
        if(self.checkOutModal) {
            self.checkOutModal = nil;
        }
        if([[GMSharedClass sharedClass] getUserLoggedStatus] == NO) {
            

            
            GMLoginVC *loginVC = [[GMLoginVC alloc] initWithNibName:@"GMLoginVC" bundle:nil];
            loginVC.isPresent = YES;
            
            // Do any additional setup after loading the view from its nib.
            self.loginNavigationController = [[GMNavigationController alloc]initWithRootViewController:loginVC];
            self.loginNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            self.loginNavigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.loginNavigationController.navigationBarHidden = YES;
            self.navigationController.hidesBottomBarWhenPushed = YES;
            [self.navigationController presentViewController:self.loginNavigationController  animated:YES completion:nil];
        }
        else {
            
            self.checkOutModal = [[GMCheckOutModal alloc]init];
            GMShipppingAddressVC *shipppingAddressVC = [[GMShipppingAddressVC alloc] initWithNibName:@"GMShipppingAddressVC" bundle:nil];
            self.checkOutModal.cartDetailModal = self.cartDetailModal;
            shipppingAddressVC.checkOutModal = self.checkOutModal;
            [self.navigationController pushViewController:shipppingAddressVC animated:YES];
        }
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"No any item in your cart"];
    }
    
}

- (IBAction)updateOrderButtonTapped:(id)sender {
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CartUpdate withCategory:@"" label:nil value:nil];
    if([self checkWhetherUpdateRequestNeeded]) {
        
        NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] updateDeleteRequestParameterFromCartDetailModal:self.cartDetailModal];
        [self showProgress];
        [[GMOperationalHandler handler] deleteItem:requestParam withSuccessBlock:^(GMCartDetailModal *cartDetailModal) {
            
            [self removeProgress];
            
            if(cartDetailModal.productItemsArray.count > 0) {
                
                self.cartDetailModal = cartDetailModal;
                self.cartModal = [[GMCartModal alloc] initWithCartDetailModal:cartDetailModal];
                [self.cartModal archiveCart];
                [self.tabBarController updateBadgeValueOnCartTab];
                [self.totalView setHidden:NO];
                [self.dottedImageView setHidden:NO];
                [self.placeOrderButton setHidden:NO];
                [self.updateOrderButton setHidden:YES];
                [self configureAmountView];
                [self checkIsAnyItemOutOfStock];
            } else {
                [self.totalView setHidden:NO];
                [self.placeOrderButton setHidden:NO];
                [self.dottedImageView setHidden:NO];
                [self.updateOrderButton setHidden:YES];
                self.messageString = @"No item in your cart, Please add item.";
            }
            [self setTotalCount];
            [self.cartDetailTableView reloadData];
        } failureBlock:^(NSError *error) {
            
            [self removeProgress];
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        }];
        
        if(self.cartDetailModal.productItemsArray.count == 0) {
            
            GMUserModal *userModal = [GMUserModal loggedInUser];
            [userModal setQuoteId:@""];
            [userModal persistUser];
        }
    }
    else {
        
        [self.placeOrderButton setHidden:NO];
        [self.updateOrderButton setHidden:YES];
    }
}

- (IBAction)backButtonTapped:(id)sender {
    
//    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    [self.tabBarController setSelectedIndex:0];
//    AppDelegate *appdel = APP_DELEGATE;
//    [appdel goToHomeWithAnimation:NO];
}

- (BOOL)checkWhetherUpdateRequestNeeded {
    
    BOOL updateStatus = YES;
    
    if(!self.cartDetailModal)
        return NO;
    
    if(self.cartDetailModal.deletedProductItemsArray.count)
        return updateStatus;
    
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", productModal.productid];
        NSArray *filteredArr = [self.cartModal.cartItems filteredArrayUsingPredicate:pred];
        GMProductModal *cartProductModal = [filteredArr firstObject];
        if([productModal.productQuantity isEqualToString:cartProductModal.productQuantity]) {
            
            //            [productModal setIsProductUpdated:NO];
            updateStatus = updateStatus && NO;
        }
        else {
            
            //            [productModal setIsProductUpdated:YES];
            updateStatus = YES;
            break;
        }
    }
    
    return updateStatus;
}

- (void)setTotalCount {
    
    int totalItems = 0;
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        totalItems += productModal.productQuantity.intValue;
    }
    
    if(totalItems > 0)
        self.totalItemInCartLbl.text = [NSString stringWithFormat:@"%d",totalItems];
    else
        self.totalItemInCartLbl.text = [NSString stringWithFormat:@"0"];
}
@end
