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
#import "GMOrderSuccessVC.h"
#import "GMCartRequestParam.h"
#import "GMCoupanCodeCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "GMGenralModal.h"
#import "GMCoupanCartDetail.h"
#import "GMApiPathGenerator.h"
#import "GMOrderFailVC.h"
#import "PayU_iOS_SDK.h"

//#define PayU_Cridentail   @"yPnUG6:test"
//
//#define PayU_Key   @"yPnUG6"
//#define PayU_Salt   @"jJ0mWFKl"
//
//
//#define PayU_Product_Info @"GrocerMax Product Info"




static NSString *kIdentifierPaymentCell = @"paymentIdentifierCell";
static NSString *kIdentifierPaymentSummuryCell = @"paymentSummeryIdentifierCell";
static NSString *kIdentifierCoupanCodeCell = @"coupanCodeIdentifierCell";
static NSString *kIdentifierPaymentHeader = @"paymentIdentifierHeader";

@interface GMPaymentVC ()<UITextFieldDelegate>
{
    NSInteger selectedIndex;
    float totalAmount;
    NSString *coupanCode;
    NSString *orderID;
    BOOL isPaymentFail;
}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *paymentTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *couponCodeTextField;
@property (strong, nonatomic) NSMutableArray *paymentOptionArray;
@property (strong, nonatomic) GMButton *checkedBtn;
@property (strong, nonatomic) GMGenralModal *genralModal;
@property (strong, nonatomic) GMCoupanCartDetail *coupanCartDetail;

///
@property (nonatomic, strong) NSString *txnID;
@property (nonatomic, strong) NSDictionary *hashDict;
@property(nonatomic,strong) NSString *myKey;
@property(nonatomic,strong) NSString *offerKey;
typedef void (^urlRequestCompletionBlock)(NSURLResponse *response, NSData *data, NSError *connectionError);
///

@end

@implementation GMPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.paymentOptionArray = [[NSMutableArray alloc]initWithObjects:@"Cash on delivery",@"Credit / Debit card",@"Sodexho coupons",@"payU",@"mobikwik", nil];
    self.paymentOptionArray = [[NSMutableArray alloc]initWithObjects:@"Cash on delivery",@"Online Payment (Credit/Debit card, Net Banking)", nil];
    coupanCode = @"";
    [self registerCellsForTableView];
    selectedIndex = -1;
    [self configerView];
    [self initilizedpayUdata];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Payment Method";
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_CartPaymentMethod_Screen];
    
    if(isPaymentFail) {
        [self goToFailOrderScreen];
    }
    
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
////    self.title = @"Payment Method";
//    self.navigationController.navigationBarHidden = NO;
//    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
//}

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
    
    nib = [UINib nibWithNibName:@"GMCoupanCodeCell" bundle:[NSBundle mainBundle]];
    [self.paymentTableView registerNib:nib forCellReuseIdentifier:kIdentifierCoupanCodeCell];
    
    
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

#pragma mark - Action Methods
- (IBAction)actionPaymentCash:(id)sender {
    
//    self.txnID = [self randomStringWithLength:17];
//    [self createHeashKey];
//    return ;
    if(selectedIndex == -1) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please select mode of payment."];
        return;
    }
//
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PlaceOrder withCategory:@"" label:nil value:nil];
    
    NSDictionary *checkOutDic = [[GMCartRequestParam sharedCartRequest] finalCheckoutParameterDictionaryFromCheckoutModal:self.checkOutModal];
    if(selectedIndex == 1) {
        [checkOutDic setValue:@"payucheckout_shared" forKey:kEY_payment_method];
        if(self.genralModal) {
            [self createHeashKey];
            return;
        }
    } else if(selectedIndex == 0) {
        [checkOutDic setValue:@"cashondelivery" forKey:kEY_payment_method];
    }
    [self showProgress];
    [[GMOperationalHandler handler] checkout:checkOutDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        self.genralModal = responceData;
        [self removeProgress];
        if(responceData.flag == 1) {
            [[GMSharedClass sharedClass] clearCart];
            [self.tabBarController updateBadgeValueOnCartTab];
            if(selectedIndex == 0) {
                GMOrderSuccessVC *successVC = [[GMOrderSuccessVC alloc] initWithNibName:@"GMOrderSuccessVC" bundle:nil];
                successVC.orderId = responceData.orderID;
                [self.navigationController pushViewController:successVC animated:YES];
            } else if(selectedIndex == 1) {
                //[self initilizedpayUdata];
                if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
                   self.txnID = self.genralModal.orderID;
                } else {
                self.txnID = [self randomStringWithLength:17];
                }
                [self createHeashKey];
            }
        } else {
            [[GMSharedClass sharedClass] showErrorMessage:responceData.result];
        }
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        
        [self removeProgress];
    }];
    
    
}

- (void)actionApplyCoponCode:(id)sender {
    
    if(self.coupanCartDetail) {
        
        [self removeCouponCode];
        return;
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CodeApplied withCategory:@"" label:coupanCode value:nil];
    
    [self.view endEditing:YES];
//    self.txnID = [self randomStringWithLength:17];
//    [self createHeashKey];
//    return;
    if(!NSSTRING_HAS_DATA(coupanCode)) {
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
    if(NSSTRING_HAS_DATA(coupanCode)) {
        [userDic setObject:coupanCode forKey:kEY_couponcode];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] addCoupon:userDic  withSuccessBlock:^(GMCoupanCartDetail *responceData) {
        self.coupanCartDetail = responceData;
//        [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is appyed."];
        [self.paymentTableView reloadData];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is not valid."];
        [self removeProgress];
    }];
    
}

- (void)removeCouponCode {
    
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [userDic setObject:userModal.userId forKey:kEY_userid];
    }
    if(NSSTRING_HAS_DATA(userModal.quoteId)) {
        [userDic setObject:userModal.quoteId forKey:kEY_quote_id];
    }
    if(NSSTRING_HAS_DATA(coupanCode)) {
        [userDic setObject:coupanCode forKey:kEY_couponcode];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] removeCoupon:userDic  withSuccessBlock:^(NSDictionary *responceData) {
        
        
        NSString *message = @"";
        if([responceData objectForKey:@"Result"]) {
            message = [responceData objectForKey:@"Result"];
        }
        if([[responceData objectForKey:@"flag"] intValue] == 1) {
            if(!NSSTRING_HAS_DATA(message)) {
                message = @"Coupon remove sucessfully.";
            }
            [[GMSharedClass sharedClass] showErrorMessage:message];
            self.coupanCartDetail = nil;
            [self.paymentTableView reloadData];
        }else {
            if(!NSSTRING_HAS_DATA(message)) {
                message = @"Coupon is not valid.";
            }
            [[GMSharedClass sharedClass] showErrorMessage:message];
        }
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is not valid."];
        [self removeProgress];
    }];
}

- (void)actionCheckedBtnClicked:(GMButton *)sender {
    
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
        if(selectedIndex == 0) {
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PaymentModeSelect withCategory:@"" label:kEY_GA_Event_CashOnDelivery value:nil];
        } else {
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PaymentModeSelect withCategory:@"" label:kEY_GA_Event_PayU value:nil];
        }
    }
    self.checkedBtn = sender;
    
}

#pragma mark - keyword hide

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField {
    coupanCode = textField.text;
}
#pragma mark - TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return self.paymentOptionArray.count;
    }
    else if(section == 1) {
        return 1;
    } else if(section == 2) {
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
        [paymentOrderSummryCell configerViewData:self.checkOutModal.cartDetailModal coupanCartDetail:self.coupanCartDetail];
        return paymentOrderSummryCell;
    }
    else if(indexPath.section == 2) {
        GMCoupanCodeCell *coupanCodeCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierCoupanCodeCell];
        coupanCodeCell.tag = indexPath.row;
        coupanCodeCell.coupanCodeTextField.delegate = self;
        [coupanCodeCell.applyCodeBtn addTarget:self action:@selector(actionApplyCoponCode:) forControlEvents:UIControlEventTouchUpInside];
        [coupanCodeCell.applyCodeBtn setExclusiveTouch:YES];
        [coupanCodeCell configerView:self.coupanCartDetail];
        return coupanCodeCell;
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
    else if(indexPath.section == 2) {
//        [GMCoupanCodeCell cellHeight];
        return 48;
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
            [header congigerHeaderData:@"ORDER SUMMARY"];
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

- (void) goToFailOrderScreen {
    [self removeNotification];
    if(isPaymentFail) {
        isPaymentFail = FALSE;
    GMOrderFailVC *orderFailVC = [GMOrderFailVC new];
    orderFailVC.orderId = self.genralModal.orderID;
    orderFailVC.totalAmount = totalAmount;
    [self.navigationController pushViewController:orderFailVC animated:NO];
    }
}

/**
 PayU Implementation
 **/

- (void)initilizedpayUdata {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.myKey=[dict valueForKey:@"key"];
    self.offerKey = @"test123@6622";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success:) name:@"payment_success_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failure:) name:@"payment_failure_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel:) name:@"payu_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReceived:) name:@"passData" object:nil];
//    [self.activity setHidesWhenStopped:YES];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payment_success_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payment_failure_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payu_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passData" object:nil];
}

-(void)dataReceived:(NSNotification *)noti
{
    NSLog(@"dataReceived from surl/furl:%@", noti.object);
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popToViewController:self animated:YES];
    
   
}

- (void) success:(NSDictionary *)info{
    
    isPaymentFail = FALSE;
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
        [orderDic setObject:self.genralModal.orderID forKey:kEY_orderid];
    }
    [self showProgress];
    [[GMOperationalHandler handler] success:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        GMOrderSuccessVC *successVC = [[GMOrderSuccessVC alloc] initWithNibName:@"GMOrderSuccessVC" bundle:nil];
        successVC.orderId = self.genralModal.orderID;
        [self.navigationController pushViewController:successVC animated:YES];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        GMOrderSuccessVC *successVC = [[GMOrderSuccessVC alloc] initWithNibName:@"GMOrderSuccessVC" bundle:nil];
        successVC.orderId = self.genralModal.orderID;
        [self.navigationController pushViewController:successVC animated:YES];

        [self removeProgress];
    }];
    
}
- (void) failure:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
//    isPaymentFail = TRUE;
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
        [orderDic setObject:self.genralModal.orderID forKey:kEY_orderid];
    }
    [self showProgress];
    [[GMOperationalHandler handler] fail:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        
        [self removeProgress];
        
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
    }];
    [self goToFailOrderScreen];
    
}
- (void) cancel:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
//    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [self goToFailOrderScreen];
    
}
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength:(int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}

- (void) createHeashKey{
    
    [self showProgress];
    [self generateHashFromServer:nil withCompletionBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(connectionError == nil && data != nil) {
                [self withoutUserDefinedModeBtnClick];
            } else {
                [[GMSharedClass sharedClass] showErrorMessage:@"Problem to genrate hash for payU."];
            }
            [self removeProgress];
        });
//        NSLog(@"-->>Hash has been created = %@",_hashDict);
    }];
}
- (void) generateHashFromServer:(NSDictionary *) paramDict withCompletionBlock:(urlRequestCompletionBlock)completionBlock{
    void(^serverResponseForHashGenerationCallback)(NSURLResponse *response, NSData *data, NSError *error) = completionBlock;
    _hashDict=nil;

//    PayUPaymentOptionsViewController *paymentOptionsVC = nil;
    
    
    [[GMOperationalHandler handler] getMobileHash:[self getPayUHashParameterDictionary] withSuccessBlock:^(id responceData) {
        if(responceData != nil) {
            
//                paymentOptionsVC.allHashDict = responceData;
            _hashDict = responceData;
            serverResponseForHashGenerationCallback(responceData, responceData,nil);
            
        } else {
             serverResponseForHashGenerationCallback(nil, nil,nil);
        }
        
    } failureBlock:^(NSError *error) {
         serverResponseForHashGenerationCallback(nil, nil,error);
    }];
    /*
    NSURL *restURL = [NSURL URLWithString:@"https://payu.herokuapp.com/get_hash"];
    // create the request
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:restURL
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    if(self.coupanCartDetail) {
        totalAmount = [self.coupanCartDetail.grand_total doubleValue];
    } else {
        double subtotal = 0;
        GMCartDetailModal *cartDetailModal = self.checkOutModal.cartDetailModal;
        for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        
        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        totalAmount =  grandTotal;
    }
    // Specify that it will be a POST request
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"8585990093";
    NSString *name = @"deepaksoni";
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        name = userModal.firstName;
    }
    
    
    theRequest.HTTPMethod = @"POST";

    NSString *postData = [NSString stringWithFormat:@"offer_key=%@&key=%@&hash=%@&email=%@&amount=%@&firstname=%@&txnid=%@&user_credentials=%@&udf1=u1&udf2=u2&udf3=u3&udf4=u4&udf5=u5&productinfo=%@&phone=%@",self.offerKey,self.myKey,@"hash",emailId,@"2",name,self.txnID,PayU_Cridentail,PayU_Product_Info,mobileNo];

    NSLog(@"-->>Hash generation Post Param = %@",postData);
    //set request content type we MUST set this value.
    [theRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //set post data of request
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:theRequest queue:networkQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError == nil) {
            NSError *errorJson = nil;
            _hashDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
            if(_hashDict)
            {
                paymentOptionsVC.allHashDict = _hashDict;
            }
            
        } else {
            
        }
        serverResponseForHashGenerationCallback(response, data,connectionError);
    }]; */
    
}


-(void) withoutUserDefinedModeBtnClick{
    
    PayUPaymentOptionsViewController *paymentOptionsVC = [[PayUPaymentOptionsViewController alloc] initWithNibName:@"PayUPaymentOptionsViewController" bundle:nil];
    
    if(self.coupanCartDetail) {
        totalAmount = [self.coupanCartDetail.grand_total doubleValue];
    } else {
        double subtotal = 0;
        GMCartDetailModal *cartDetailModal = self.checkOutModal.cartDetailModal;
        for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        
        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        totalAmount =  grandTotal;
    }
//    [self.totalPriceLbl setText:[NSString stringWithFormat:@"$%.2f", grandTotal]];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"test";
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"9999999999";
    NSString *name = @"deepaksoni";
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        userId = userModal.userId;
    }
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        name = userModal.firstName;
    }
    NSString *sucessString = [NSString stringWithFormat:@"%@.php?orderid=%@",[GMApiPathGenerator successPath],self.txnID];
    NSString *failString = [NSString stringWithFormat:@"%@.php?orderid=%@",[GMApiPathGenerator failPath],self.txnID];
    

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: PayU_Product_Info,@"productinfo",
                                      emailId,@"firstname",
                                      [NSString stringWithFormat:@"%.2f",totalAmount],@"amount",
                                      emailId,@"email",
                                      mobileNo, @"phone",
                                      sucessString,@"surl",
                                      failString,@"furl",
                                      self.txnID,@"txnid",PayU_Cridentail
                                    ,@"user_credentials",
//                                      @"u1",@"udf1",
//                                      @"u2",@"udf2",
//                                      @"u3",@"udf3",
//                                      @"u4",@"udf4",
//                                      @"u5",@"udf5",
                                      PayU_Key,kEY_PayU_Key,
                                      nil];
    
//    yPnUG6:test
    paymentOptionsVC.parameterDict = paramDict;
    paymentOptionsVC.callBackDelegate = self;
    paymentOptionsVC.totalAmount  = totalAmount;//[totalAmount floatValue];
    paymentOptionsVC.appTitle     = @"GrocerMax Payment";
    if(_hashDict)
        paymentOptionsVC.allHashDict = _hashDict;
    [self.navigationController pushViewController:paymentOptionsVC animated:YES];
    isPaymentFail = TRUE;
}


#pragma mark - PayU Hash Paramter

- (NSDictionary *)payUHashParameterDictionary{
    
    NSMutableDictionary *payUParameterDic = [[NSMutableDictionary alloc]init];
    
    if(self.coupanCartDetail) {
        totalAmount = [self.coupanCartDetail.grand_total doubleValue];
    } else {
        double subtotal = 0;
        GMCartDetailModal *cartDetailModal = self.checkOutModal.cartDetailModal;
        for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        
        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        totalAmount =  grandTotal;
    }
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"test";
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"9999999999";
    NSString *name = @"deepaksoni";
    
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        userId = userModal.userId;
    }
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        name = userModal.firstName;
    }
    NSString *sucessString = [NSString stringWithFormat:@"%@.php?orderid=%@",[GMApiPathGenerator successPath],self.txnID];
    NSString *failString = [NSString stringWithFormat:@"%@.php?orderid=%@",[GMApiPathGenerator failPath],self.txnID];
    
    [payUParameterDic setObject:PayU_Key forKey:kEY_PayU_Key];
    [payUParameterDic setObject:emailId forKey:kEY_PayU_Email];
    [payUParameterDic setObject:name forKey:kEY_PayU_Fname];
    [payUParameterDic setObject:mobileNo forKey:kEY_PayU_Phone];
    [payUParameterDic setObject:self.txnID forKey:kEY_PayU_Txnid];
    [payUParameterDic setObject:PayU_Product_Info forKey:kEY_PayU_Productinfo];
    [payUParameterDic setObject:PayU_Cridentail forKey:kEY_PayU_User_Credentials];
    [payUParameterDic setObject:failString forKey:kEY_PayU_Furl];
    [payUParameterDic setObject:sucessString forKey:kEY_PayU_Surl];
    [payUParameterDic setObject:[NSString stringWithFormat:@"%.2f",totalAmount] forKey:kEY_PayU_Amount];
    
    
    return payUParameterDic;
}

- (NSDictionary *)getPayUHashParameterDictionary{
    
    NSMutableDictionary *payUParameterDic = [[NSMutableDictionary alloc]init];
    
    if(self.coupanCartDetail) {
        totalAmount = [self.coupanCartDetail.grand_total doubleValue];
    } else {
        double subtotal = 0;
        GMCartDetailModal *cartDetailModal = self.checkOutModal.cartDetailModal;
        for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        
        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        totalAmount =  grandTotal;
    }
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"test";
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"8585990093";
    NSString *name = @"deepaksoni";
    
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        userId = userModal.userId;
    }
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        name = userModal.firstName;
    }
//    NSString *sucessString = [NSString stringWithFormat:@"%@?orderid=%@",[GMApiPathGenerator successPath],self.txnID];
//    NSString *failString = [NSString stringWithFormat:@"%@?orderid=%@",[GMApiPathGenerator failPath],self.txnID];
    
//    [payUParameterDic setObject:PayU_Key forKey:kEY_PayU_Key];
    [payUParameterDic setObject:emailId forKey:kEY_PayU_Email];
    [payUParameterDic setObject:emailId forKey:kEY_PayU_Fname];
//    [payUParameterDic setObject:mobileNo forKey:kEY_PayU_Phone];
    [payUParameterDic setObject:self.txnID forKey:kEY_PayU_Txnid];
//    [payUParameterDic setObject:PayU_Product_Info forKey:kEY_PayU_Productinfo];
//    [payUParameterDic setObject:PayU_Cridentail forKey:kEY_PayU_User_Credentials];
//    [payUParameterDic setObject:failString forKey:kEY_PayU_Furl];
//    [payUParameterDic setObject:sucessString forKey:kEY_PayU_Surl];
    [payUParameterDic setObject:[NSString stringWithFormat:@"%.2f",totalAmount] forKey:kEY_PayU_Amount];
//    [payUParameterDic setObject:PayU_Salt forKey:@"salt"];
    
    
    return payUParameterDic;
}

@end
