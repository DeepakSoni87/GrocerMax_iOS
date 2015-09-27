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


@interface GMCartVC () <UITableViewDataSource, UITableViewDelegate, GMCartCellDelegate>
{
    NSString *messageString;
}

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

@end

static NSString * const kCartCellIdentifier    = @"cartCellIdentifier";

@implementation GMCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.checkOutModal = [[GMCheckOutModal alloc]init];
    messageString = @"Fetching your cart items from server.";
    [self.totalView setHidden:YES];
    [self.placeOrderButton setHidden:YES];
    [self registerCellsForTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    messageString = @"Fetching your cart items from server.";
    self.cartModal = [GMCartModal loadCart];
//    if(self.cartModal)
        [self fetchCartDetailFromServer];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [self updateOrderButtonTapped:nil];
}

- (void)registerCellsForTableView {
    
    [self.cartDetailTableView registerNib:[UINib nibWithNibName:@"GMCartCell" bundle:nil] forCellReuseIdentifier:kCartCellIdentifier];
}

- (void)fetchCartDetailFromServer {
    
    NSDictionary *requestDict = [[GMCartRequestParam sharedCartRequest] cartDetailRequestParameter];
    [self showProgress];
    [[GMOperationalHandler handler] cartDetail:requestDict withSuccessBlock:^(GMCartDetailModal *cartDetailModal) {
        
        [self removeProgress];
        if(cartDetailModal.productItemsArray.count>0) {
            self.cartDetailModal = cartDetailModal;
            self.cartModal = [[GMCartModal alloc] initWithCartDetailModal:cartDetailModal];
            [self.cartModal archiveCart];
            [self.totalView setHidden:NO];
            [self.placeOrderButton setHidden:NO];
            [self.updateOrderButton setHidden:YES];
            [self configureAmountView];
        } else {
            [self.totalView setHidden:YES];
            [self.placeOrderButton setHidden:YES];
            messageString = @"No item in your cart, Please add item.";
        }
        [self.cartDetailTableView reloadData];
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
    }];
}

- (void)configureAmountView {
    
    [self.subTotalLabel setText:[NSString stringWithFormat:@"%.2f", self.cartDetailModal.subTotal.doubleValue]];
    [self.shippingChargeLabel setText:[NSString stringWithFormat:@"%.2f", self.cartDetailModal.shippingAmount.doubleValue]];
    [self.totalLabel setText:[NSString stringWithFormat:@"%.2f", self.cartDetailModal.grandTotal.doubleValue]];
    double savingAmount = [self getSavedAmount];
    [self.savedLabel setText:[NSString stringWithFormat:@"%.2f", savingAmount]];
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
    
    [self.shippingChargeLabel setText:[NSString stringWithFormat:@"%.2f", self.cartDetailModal.shippingAmount.doubleValue]];
    double saving = 0;
    double subtotal = 0;
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
        subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
    }
    if(NSSTRING_HAS_DATA(self.cartDetailModal.discountAmount))
        saving = saving - self.cartDetailModal.discountAmount.doubleValue;
    [self.subTotalLabel setText:[NSString stringWithFormat:@"%.2f", subtotal]];
    [self.savedLabel setText:[NSString stringWithFormat:@"%.2f", saving]];
    double grandTotal = subtotal + self.cartDetailModal.shippingAmount.doubleValue;
    [self.totalLabel setText:[NSString stringWithFormat:@"%.2f", grandTotal]];
}

#pragma mark - UITableView Delegates/Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.cartDetailModal.productItemsArray count];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.cartDetailTableView.frame), 7.0)];
//    [headerView setBackgroundColor:[UIColor clearColor]];
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProductModal *productModal = [self.cartDetailModal.productItemsArray objectAtIndex:indexPath.row];
    GMCartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:kCartCellIdentifier];
    [cartCell.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cartCell setDelegate:self];
    [cartCell configureViewWithProductModal:productModal];
    return cartCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMCartCell getCellHeight];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, CGRectGetHeight(tableView.frame))];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 300, CGRectGetHeight(tableView.frame))];
    [headerLabel setTextColor:[UIColor darkTextColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:headerLabel];
    [headerLabel setText:messageString];
    
    return headerView;
}
#pragma mark - GMCartCellDelegate Methods

- (void)productQuantityValueChanged {
    
    [self.placeOrderButton setHidden:YES];
    [self.updateOrderButton setHidden:NO];
    [self updateAmountViewWhenQuantityChanged];
}

#pragma mark - IBAction Methods

- (void)deleteButtonTapped:(GMButton *)sender {
    
    GMProductModal *deletedProductModal = [[GMProductModal alloc] initWithProductModal:sender.produtModal];
    [self.cartDetailModal.deletedProductItemsArray addObject:deletedProductModal];
    [self.cartDetailModal.productItemsArray removeObject:sender.produtModal];
    [self.cartDetailTableView reloadData];
    [self updateAmountViewWhenQuantityChanged];
}

- (IBAction)placeOrderButtonTapped:(id)sender {
    if(self.cartModal && self.cartModal.cartItems.count>0) {
        GMShipppingAddressVC *shipppingAddressVC = [GMShipppingAddressVC new];
        self.checkOutModal.cartDetailModal = self.cartDetailModal;
        self.checkOutModal.cartModal = self.cartModal;
        shipppingAddressVC.checkOutModal = self.checkOutModal;
        [self.navigationController pushViewController:shipppingAddressVC animated:YES];
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"No any item in your cart"];
    }
    
}

- (IBAction)updateOrderButtonTapped:(id)sender {
    
    if([self checkWhetherUpdateRequestNeeded]) {
        
        NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] updateDeleteRequestParameterFromCartDetailModal:self.cartDetailModal];
        [self showProgress];
        [[GMOperationalHandler handler] deleteItem:requestParam withSuccessBlock:^(GMCartDetailModal *cartDetailModal) {
            
            [self removeProgress];
            self.cartDetailModal = cartDetailModal;
            [self.cartDetailTableView reloadData];
            [self.placeOrderButton setHidden:NO];
            [self.updateOrderButton setHidden:YES];
            [self configureAmountView];
        } failureBlock:^(NSError *error) {
            
            [self removeProgress];
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        }];
    }
}

- (IBAction)backButtonTapped:(id)sender {
    
    [self.tabBarController setSelectedIndex:0];
}

- (BOOL)checkWhetherUpdateRequestNeeded {
    
    BOOL updateStatus = YES;
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
            updateStatus = updateStatus && YES;
            break;
        }
    }
    
    return updateStatus;
}
@end
