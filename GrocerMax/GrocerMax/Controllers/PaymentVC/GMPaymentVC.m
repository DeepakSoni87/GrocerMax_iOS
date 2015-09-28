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

#pragma mark - Action Methods
- (IBAction)actionPaymentCash:(id)sender {
    
    if(selectedIndex != 0) {
        return;
    }
    
    NSDictionary *checkOutDic = [[GMCartRequestParam sharedCartRequest] finalCheckoutParameterDictionaryFromCheckoutModal:self.checkOutModal];
    [self showProgress];
    [[GMOperationalHandler handler] checkout:checkOutDic  withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        GMOrderSuccessVC *successVC = [[GMOrderSuccessVC alloc] initWithNibName:@"GMOrderSuccessVC" bundle:nil];
        [self.navigationController pushViewController:successVC animated:YES];
        
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

@end
