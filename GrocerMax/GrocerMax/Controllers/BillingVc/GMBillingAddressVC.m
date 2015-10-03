//
//  GMBillingAddressVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMBillingAddressVC.h"
#import "GMAddressCell.h"
#import "GMTAddAddressCell.h"
#import "GMDeliveryDetailVC.h"
#import "GMAddBillingAddressVC.h"

static NSString *kIdentifierBillingAddressCell = @"BillingAddressIdentifierCell";
static NSString *kIdentifierAddAddressCell = @"AddAddressIdentifierCell";

@interface GMBillingAddressVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isHitOnServer;
}
//@property (strong, nonatomic) NSMutableArray *billingAddressArray;
@property (strong, nonatomic) IBOutlet UITableView *billingAddressTableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *addNewAddressBtn;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) GMAddressModalData *selectedAddressModalData;

@end

@implementation GMBillingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    
    self.userModal = [GMUserModal loggedInUser];
    [self registerCellsForTableView];
    self.addNewAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth - 30 - 7 - 7, 0, 0);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(isHitOnServer)
        [self getBillingAddress];
    self.title = @"Billing Address";
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.billingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierBillingAddressCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods

- (void)selectUnselectBtnClicked:(GMButton *)sender {
    
    GMAddressModalData *addressModalData = sender.addressModal;
    
    self.selectedAddressModalData.isBillingSelected = FALSE;
    
    self.selectedAddressModalData = addressModalData;
    
    if(addressModalData.isBillingSelected) {
        sender.selected = FALSE;
        addressModalData.isBillingSelected = FALSE;
    }
    else {
        sender.selected = TRUE;
        addressModalData.isBillingSelected = TRUE;
    }
    self.checkOutModal.billingAddressModal = addressModalData;
    [self.billingAddressTableView reloadData];
    
}

- (void) editBtnClicked:(GMButton *)sender {
    
    isHitOnServer = TRUE;
    GMAddBillingAddressVC *addShippingAddressVC = [GMAddBillingAddressVC new];
    addShippingAddressVC.editAddressModal = sender.addressModal;
    [self.navigationController pushViewController:addShippingAddressVC animated:YES];
}

- (IBAction)addAddressBtnClicked:(UIButton *)sender {
    
    isHitOnServer = TRUE;
    GMAddBillingAddressVC *addShippingAddressVC = [GMAddBillingAddressVC new];
    [self.navigationController pushViewController:addShippingAddressVC animated:YES];
}

- (IBAction)actionProcess:(id)sender {
    
    isHitOnServer = FALSE;
    if(self.checkOutModal.billingAddressModal) {
        GMDeliveryDetailVC *deliveryDetailVC = [GMDeliveryDetailVC new];
        deliveryDetailVC.checkOutModal = self.checkOutModal;
        deliveryDetailVC.timeSlotBaseModal = self.timeSlotBaseModal;
        [self.navigationController pushViewController:deliveryDetailVC animated:YES];
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please select billing address."];
    }
}

#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.billingAddressArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMAddressCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 7.0)];
    [headerView setBackgroundColor:[UIColor grayBackgroundColor]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierBillingAddressCell];
    GMAddressModalData *addressModalData = [self.billingAddressArray objectAtIndex:indexPath.row];
    [addressCell configerViewWithData:addressModalData];
    if(addressModalData.isBillingSelected)
        addressCell.selectUnSelectBtn.selected = YES;
    else
        addressCell.selectUnSelectBtn.selected = NO;
    [addressCell.selectUnSelectBtn addTarget:self action:@selector(selectUnselectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addressCell.editAddressBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return addressCell;
}

#pragma mark Request Methods

- (void)getBillingAddress {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.userModal.email))
        [dataDic setObject:self.userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(self.userModal.userId))
        [dataDic setObject:self.userModal.userId forKey:kEY_userid];
    [self showProgress];
    [[GMOperationalHandler handler] getAddressWithTimeSlot:dataDic withSuccessBlock:^(GMTimeSlotBaseModal *responceData) {
        isHitOnServer = FALSE;
        self.timeSlotBaseModal = responceData;
        if(responceData.addressesArray.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMAddressModalData *evaluatedObject, NSDictionary *bindings) {
                int isBillingValue = evaluatedObject.is_default_billing.intValue;
                
                if(isBillingValue == 1) {
                    return YES;
                }
                else
                    return NO;
            }];
            
            NSArray *arry = [responceData.addressesArray filteredArrayUsingPredicate:predicate];
            if(arry.count>0)
            {
                self.billingAddressArray = (NSMutableArray *)arry;
                self.checkOutModal.billingAddressModal = nil;
                [self.billingAddressTableView reloadData];
            }
        }
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        isHitOnServer = FALSE;
        [self removeProgress];
        
    }];
}


@end
