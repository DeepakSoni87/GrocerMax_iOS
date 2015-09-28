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

#import "PayU_iOS_SDK.h"


static NSString *kIdentifierPaymentCell = @"paymentIdentifierCell";
static NSString *kIdentifierPaymentSummuryCell = @"paymentSummeryIdentifierCell";
static NSString *kIdentifierPaymentHeader = @"paymentIdentifierHeader";

@interface GMPaymentVC ()
{
    NSInteger selectedIndex;
    float totalAmount;
}
@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *couponCodeTextField;
@property (strong, nonatomic) NSMutableArray *paymentOptionArray;
@property (strong, nonatomic) GMButton *checkedBtn;

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
    self.paymentOptionArray = [[NSMutableArray alloc]initWithObjects:@"Cash on delivery",@"payU", nil];
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
        [[GMSharedClass sharedClass] showErrorMessage:@"Please select payment type."];
        return;
    }
//
    NSDictionary *checkOutDic = [[GMCartRequestParam sharedCartRequest] finalCheckoutParameterDictionaryFromCheckoutModal:self.checkOutModal];
    if(selectedIndex == 1)
        [checkOutDic setValue:@"payucheckout_shared" forKey:kEY_payment_method];
    [self showProgress];
    [[GMOperationalHandler handler] checkout:checkOutDic  withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        if(selectedIndex == 0) {
            GMOrderSuccessVC *successVC = [[GMOrderSuccessVC alloc] initWithNibName:@"GMOrderSuccessVC" bundle:nil];
            [self.navigationController pushViewController:successVC animated:YES];
        } else if(selectedIndex == 1) {
            //[self initilizedpayUdata];
            self.txnID = [self randomStringWithLength:17];
            [self createHeashKey];
        }
        
        
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

-(void)dataReceived:(NSNotification *)noti
{
    NSLog(@"dataReceived from surl/furl:%@", noti.object);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) success:(NSDictionary *)info{
    NSLog(@"Sucess Dict: %@",info);
    
    #warning hit here to sucess payment
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void) failure:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
    
#warning hit here to fail
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popToViewController:self animated:NO];
    
}
- (void) cancel:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
            [self withoutUserDefinedModeBtnClick];
            [self removeProgress];
        });
        NSLog(@"-->>Hash has been created = %@",_hashDict);
    }];
}

- (void) generateHashFromServer:(NSDictionary *) paramDict withCompletionBlock:(urlRequestCompletionBlock)completionBlock{
    void(^serverResponseForHashGenerationCallback)(NSURLResponse *response, NSData *data, NSError *error) = completionBlock;
    _hashDict=nil;
    PayUPaymentOptionsViewController *paymentOptionsVC = nil;
    NSURL *restURL = [NSURL URLWithString:@"https://payu.herokuapp.com/get_hash"];
    // create the request
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:restURL
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    if(totalAmount<0.2) {
        double subtotal = 0;
        GMCartDetailModal *cartDetailModal = self.checkOutModal.cartDetailModal;
        for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        
        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        totalAmount =  grandTotal;
    }
    // Specify that it will be a POST request
    theRequest.HTTPMethod = @"POST";
    NSString *postData = [NSString stringWithFormat:@"offer_key=%@&key=%@&hash=%@&email=%@&amount=%@&firstname=%@&txnid=%@&user_credentials=%@&udf1=u1&udf2=u2&udf3=u3&udf4=u4&udf5=u5&productinfo=%@&phone=%@",self.offerKey,self.myKey,@"hash",@"email@testsdk1.com",[NSString stringWithFormat:@"%.5f", totalAmount],@"Ram",self.txnID,@"ra:ra",@"Nokia",@"1111111111"];
    NSLog(@"-->>Hash generation Post Param = %@",postData);
    //set request content type we MUST set this value.
    [theRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //set post data of request
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:theRequest queue:networkQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *errorJson = nil;
        _hashDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        if(_hashDict)
        {
            paymentOptionsVC.allHashDict = _hashDict;
        }
        serverResponseForHashGenerationCallback(response, data,connectionError);
    }];
}

-(void) withoutUserDefinedModeBtnClick{
    
    PayUPaymentOptionsViewController *paymentOptionsVC = nil;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            paymentOptionsVC = [[PayUPaymentOptionsViewController alloc] initWithNibName:@"AllPaymentOprionsView" bundle:nil];
        }
        else
        {
            paymentOptionsVC = [[PayUPaymentOptionsViewController alloc] initWithNibName:@"PayUPaymentOptionsViewController" bundle:nil];
        }
    }
    
    if(totalAmount<0.2) {
        double subtotal = 0;
        GMCartDetailModal *cartDetailModal = self.checkOutModal.cartDetailModal;
        for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        
        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        totalAmount =  grandTotal;
    }
//    [self.totalPriceLbl setText:[NSString stringWithFormat:@"$%.2f", grandTotal]];
    
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"Nokia",@"productinfo",
                                      @"Ram",@"firstname",
                                      [NSString stringWithFormat:@"%.5f", totalAmount],@"amount",
                                      @"email@testsdk1.com",@"email",
                                      @"1111111111", @"phone",
                                      @"https://payu.herokuapp.com/ios_success",@"surl",
                                      @"https://payu.herokuapp.com/ios_failure",@"furl",
                                      self.txnID,@"txnid",
                                      @"ra:ra",@"user_credentials",
                                      self.offerKey,@"offer_key",
                                      @"u1",@"udf1",
                                      @"u2",@"udf2",
                                      @"u3",@"udf3",
                                      @"u4",@"udf4",
                                      @"u5",@"udf5"
                                      ,nil];
    paymentOptionsVC.parameterDict = paramDict;
    paymentOptionsVC.callBackDelegate = self;
    paymentOptionsVC.totalAmount  = totalAmount;//[totalAmount floatValue];
    paymentOptionsVC.appTitle     = @"CrocerMax Payment";
    if(_hashDict)
        paymentOptionsVC.allHashDict = _hashDict;
    [self.navigationController pushViewController:paymentOptionsVC animated:YES];
}



@end
