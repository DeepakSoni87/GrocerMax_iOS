//
//  GMPaymentVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentVC.h"
#import "GMStateBaseModal.h"
#import "GMOrderDetailHeaderView.h"
#import "GMPaymentCell.h"
#import "GMPaymentOrderSummryCell.h"
#import "GMCartDetailModal.h"

static NSString *kIdentifierPaymentCell = @"paymentIdentifierCell";
static NSString *kIdentifierPaymentSummuryCell = @"paymentSummeryIdentifierCell";
static NSString *kIdentifierPaymentHeader = @"paymentIdentifierHeader";

@interface GMPaymentVC ()
{
    NSInteger selectedIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *couponCodeTextField;
@property (strong, nonatomic) NSMutableArray *paymentOptionArray;
@property (strong, nonatomic) GMButton *checkedBtn;

@end

@implementation GMPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.paymentOptionArray = [[NSMutableArray alloc]initWithObjects:@"Cash on delivery",@"Credit / Debit card",@"Sodexho coupons",@"payU",@"mobikwik", nil];
    [self registerCellsForTableView];
    selectedIndex = -1;
    [self configerView];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Payment Method";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Register Cells
- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMPaymentCell" bundle:[NSBundle mainBundle]];
    [self.paymentTableView registerNib:nib forCellReuseIdentifier:kIdentifierPaymentCell];
    nib = [UINib nibWithNibName:@"GMPaymentOrderSummryCell" bundle:[NSBundle mainBundle]];
    [self.paymentTableView registerNib:nib forCellReuseIdentifier:kIdentifierPaymentSummuryCell];
    
    
    nib = [UINib nibWithNibName:@"GMOrderDetailHeaderView" bundle:[NSBundle mainBundle]];
    [self.paymentTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierPaymentHeader];
    
    
    
    //
}
-(void) configerView {
    if(self.checkOutModal.cartDetailModal.couponCode) {
        self.couponCodeTextField.text = self.checkOutModal.cartDetailModal.couponCode;
    }
    self.bottomView.layer.borderWidth = 1.0;
    self.bottomView.layer.borderColor = [UIColor colorWithRGBValue:236 green:236 blue:236].CGColor;
    self.bottomView.layer.cornerRadius = 2.0;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Action Methods
- (IBAction)actionPaymentCash:(id)sender {
    
    if(selectedIndex != 0) {
        return;
    }
    
    NSMutableDictionary *checkOutDic = [[NSMutableDictionary alloc]init];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    GMTimeSloteModal *timeSloteModal = self.checkOutModal.timeSloteModal;
    GMAddressModalData *shippingAddressModal = self.checkOutModal.shippingAddressModal;
    GMAddressModalData *billingAddressModal = self.checkOutModal.billingAddressModal;
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [checkOutDic setObject:userModal.userId forKey:kEY_userid];
    }
    if(NSSTRING_HAS_DATA(userModal.quoteId)) {
        [checkOutDic setObject:userModal.quoteId forKey:kEY_quote_id];
    }
    
    if(NSSTRING_HAS_DATA(timeSloteModal.firstTimeSlote)) {
        [checkOutDic setObject:timeSloteModal.firstTimeSlote forKey:kEY_timeslot];
    }
    if(NSSTRING_HAS_DATA(timeSloteModal.deliveryDate)) {
        [checkOutDic setObject:timeSloteModal.deliveryDate forKey:kEY_date];
    }
    if(NSSTRING_HAS_DATA(timeSloteModal.deliveryDate)) {
        [checkOutDic setObject:timeSloteModal.deliveryDate forKey:kEY_date];
    }
    
    [checkOutDic setObject:@"cashondelivery" forKey:kEY_payment_method];
    [checkOutDic setObject:@"tablerate_bestway" forKey:kEY_shipping_method];
    
    NSMutableDictionary *shippingAddress = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(shippingAddressModal.customer_address_id)) {
        [shippingAddress setObject:shippingAddressModal.customer_address_id forKey:kEY_addressid];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.firstName)) {
        [shippingAddress setObject:shippingAddressModal.firstName forKey:kEY_fname];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.lastName)) {
        [shippingAddress setObject:shippingAddressModal.lastName forKey:kEY_lname];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.firstName)) {
        [shippingAddress setObject:shippingAddressModal.firstName forKey:kEY_fname];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.houseNo)) {
        [shippingAddress setObject:shippingAddressModal.houseNo forKey:kEY_addressline1];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.locality)) {
        [shippingAddress setObject:shippingAddressModal.locality forKey:kEY_addressline2];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.closestLandmark)) {
        [shippingAddress setObject:shippingAddressModal.closestLandmark forKey:kEY_addressline3];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.city)) {
        [shippingAddress setObject:shippingAddressModal.city forKey:kEY_city];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.region)) {
        [shippingAddress setObject:shippingAddressModal.region forKey:kEY_state];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.pincode)) {
        [shippingAddress setObject:shippingAddressModal.pincode forKey:kEY_postcode];
    }
    if(NSSTRING_HAS_DATA(cityModal.cityId)) {
        [shippingAddress setObject:cityModal.cityId forKey:kEY_cityId];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.telephone)) {
        [shippingAddress setObject:shippingAddressModal.telephone forKey:kEY_telephone];
    }
    if([shippingAddressModal.is_default_billing intValue]== 1) {
        [shippingAddress setObject:@"1" forKey:kEY_default_billing];
    }else {
        [shippingAddress setObject:@"0" forKey:kEY_default_billing];
    }
    if([shippingAddressModal.is_default_shipping intValue] == 1) {
        [shippingAddress setObject:@"1" forKey:kEY_default_shipping];
    } else {
        [shippingAddress setObject:@"0" forKey:kEY_default_shipping];
    }
    
    
    NSMutableDictionary *billingAddress = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(billingAddressModal.customer_address_id)) {
        [billingAddress setObject:billingAddressModal.customer_address_id forKey:kEY_addressid];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.firstName)) {
        [billingAddress setObject:billingAddressModal.firstName forKey:kEY_fname];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.lastName)) {
        [billingAddress setObject:billingAddressModal.lastName forKey:kEY_lname];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.firstName)) {
        [billingAddress setObject:billingAddressModal.firstName forKey:kEY_fname];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.houseNo)) {
        [billingAddress setObject:billingAddressModal.houseNo forKey:kEY_addressline1];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.locality)) {
        [billingAddress setObject:billingAddressModal.locality forKey:kEY_addressline2];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.closestLandmark)) {
        [billingAddress setObject:billingAddressModal.closestLandmark forKey:kEY_addressline3];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.city)) {
        [billingAddress setObject:billingAddressModal.city forKey:kEY_city];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.region)) {
        [billingAddress setObject:billingAddressModal.region forKey:kEY_state];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.pincode)) {
        [billingAddress setObject:billingAddressModal.pincode forKey:kEY_postcode];
    }
    if(NSSTRING_HAS_DATA(cityModal.cityId)) {
        [billingAddress setObject:cityModal.cityId forKey:kEY_cityId];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.telephone)) {
        [billingAddress setObject:billingAddressModal.telephone forKey:kEY_telephone];
    }
    if([billingAddressModal.is_default_billing intValue]== 1) {
        [billingAddress setObject:@"1" forKey:kEY_default_billing];
    }else {
        [billingAddress setObject:@"0" forKey:kEY_default_billing];
    }
    if([billingAddressModal.is_default_shipping intValue] == 1) {
        [billingAddress setObject:@"1" forKey:kEY_default_shipping];
    } else {
        [billingAddress setObject:@"0" forKey:kEY_default_shipping];
    }
   
//    [checkOutDic setObject:shippingAddress forKey:kEY_shipping];
//    [checkOutDic setObject:billingAddress forKey:kEY_billing];
    
    [checkOutDic setObject:[NSString getJsonStringFromObject:shippingAddress] forKey:kEY_shipping];
    [checkOutDic setObject:[NSString getJsonStringFromObject:billingAddress] forKey:kEY_billing];
    
    
    [self showProgress];
    [[GMOperationalHandler handler] checkout:checkOutDic  withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        
        [self removeProgress];
    }];

    
}

- (IBAction)actionApplyCoponCode:(id)sender {
    
    if(!NSSTRING_HAS_DATA(self.couponCodeTextField.text)) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please enter coupon code."];
        return;
    }
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [userDic setObject:userModal.userId forKey:kEY_userid];
    }
    if(NSSTRING_HAS_DATA(userModal.quoteId)) {
        [userDic setObject:userModal.quoteId forKey:kEY_quote_id];
    }
    if(NSSTRING_HAS_DATA(self.couponCodeTextField.text)) {
        [userDic setObject:self.couponCodeTextField.text forKey:kEY_couponcode];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] addCoupon:userDic  withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        
        [self removeProgress];
    }];
    
}

- (void) actionCheckedBtnClicked:(GMButton *)sender {
    
    if(sender.selected) {
        sender.selected = FALSE;
        selectedIndex = -1;
    }
    else {
        if(self.checkedBtn) {
            self.checkedBtn.selected = NO;
        }
        sender.selected = YES;
        selectedIndex = sender.tag;
    }
    self.checkedBtn = sender;
    
}

#pragma mark - keyword hide

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if(section == 0){
        return self.paymentOptionArray.count;
    }
    else if(section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        GMPaymentCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierPaymentCell];
        
        paymentCell.checkBoxBtn.tag = indexPath.row;
        [paymentCell configerViewData:[self.paymentOptionArray objectAtIndex:indexPath.row]];
        if(self.paymentOptionArray.count== indexPath.row+1) {
            paymentCell.bottomHorizentalSepretorLbl.hidden = FALSE;
        }
        [paymentCell.checkBoxBtn addTarget:self action:@selector(actionCheckedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return paymentCell;
    }
    else if(indexPath.section == 1) {
        GMPaymentOrderSummryCell *paymentOrderSummryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierPaymentSummuryCell];
        
        paymentOrderSummryCell.tag = indexPath.row;
        [paymentOrderSummryCell configerViewData:self.checkOutModal.cartDetailModal];
        return paymentOrderSummryCell;
    }
    return nil;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 45.0;
//        [GMPaymentCell cellHeight];
    } else if(indexPath.section == 1) {
//        [GMPaymentOrderSummryCell cellHeight];
        return 161;
    }
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 42.0f;
    } else if(section == 1) {
        return 42.0f;
    } else  {
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
        if(section == 0 || section == 1) {
            UIView *headerView;
            GMOrderDetailHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierPaymentHeader];
            if (!header) {
                header = [[GMOrderDetailHeaderView alloc] initWithReuseIdentifier:kIdentifierPaymentHeader];
            }
            [header.headerBgView setBackgroundColor:[UIColor clearColor]];
            if(section == 0 ) {
                [header congigerHeaderData:@"SELECT MODE OF PAYMENT"];
            } else if(section == 1 ) {
                [header congigerHeaderData:@"ORDER SUMMERY"];
            } else {
                [header congigerHeaderData:@""];
            }
            headerView = header;
            
            return headerView;
        }
        else {
            
            return nil;
        }
    
}

@end
