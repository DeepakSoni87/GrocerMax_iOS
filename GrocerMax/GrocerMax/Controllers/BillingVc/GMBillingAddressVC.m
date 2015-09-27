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
@interface GMBillingAddressVC ()
{
    BOOL isHitOnServer;
}
//@property (strong, nonatomic) NSMutableArray *billingAddressArray;
@property (strong, nonatomic) IBOutlet UITableView *billingAddressTableView;
@property (nonatomic, strong) GMUserModal *userModal;
@property (nonatomic, strong) GMAddressModalData *selectedAddressModalData;

@end

@implementation GMBillingAddressVC
@synthesize checkOutModal;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self.billingAddressTableView setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];
    self.userModal = [GMUserModal loggedInUser];
//    [self getBillingAddress];
    [self registerCellsForTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(isHitOnServer)
        [self getBillingAddress];
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.billingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierBillingAddressCell];
    
    nib = [UINib nibWithNibName:@"GMTAddAddressCell" bundle:[NSBundle mainBundle]];
    [self.billingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierAddAddressCell];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) selectUnselectBtnClicked:(GMButton *)sender {
    
    GMAddressModalData *addressModalData = sender.addressModal;
   
    self.selectedAddressModalData.isSelected = FALSE;
    
    self.selectedAddressModalData = addressModalData;
    
    if(addressModalData.isSelected) {
        sender.selected = FALSE;
        addressModalData.isSelected = FALSE;
    }
    else {
        sender.selected = TRUE;
        addressModalData.isSelected = TRUE;
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
- (void) addAddressBtnClicked:(UIButton *)sender {
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
    
    
    return [self.billingAddressArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.billingAddressArray == nil || [self.billingAddressArray count]==indexPath.row)
    {
        GMTAddAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierAddAddressCell];
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        addressCell.tag = indexPath.row;
        
        [addressCell.addAddressBtn addTarget:self action:@selector(addAddressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [addressCell.addAddressBtn setExclusiveTouch:YES];
        
        
        return addressCell;
    }
    else
    {
        GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierBillingAddressCell];
        
       GMAddressModalData *addressModalData = [self.billingAddressArray objectAtIndex:indexPath.row];
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        addressCell.tag = indexPath.row;
        [addressCell configerViewWithData:addressModalData];
        
        [addressCell.selectUnSelectBtn addTarget:self action:@selector(selectUnselectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [addressCell.selectUnSelectBtn setExclusiveTouch:YES];
        [addressCell.editAddressBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [addressCell.editAddressBtn setExclusiveTouch:YES];
        
        return addressCell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.billingAddressArray == nil || [self.billingAddressArray count]==indexPath.row)
    {
        return 55.0f;
    }
    else
    {
        return [GMAddressCell cellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(self.billingAddressArray != nil && [self.billingAddressArray count]>indexPath.row)
//    {
//        GMAddressModalData *addressModalData = [self.billingAddressArray objectAtIndex:indexPath.row];
//        self.checkOutModal.billingAddressModal = addressModalData;
//    }
}


#pragma mark Request Methods

- (void)getBillingAddress {
    
    
//    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
//    
//    if(NSSTRING_HAS_DATA(self.userModal.email))
//        [userDic setObject:self.userModal.email forKey:kEY_email];
//    if(NSSTRING_HAS_DATA(self.userModal.userId))
//    
//    [self showProgress];
//    [[GMOperationalHandler handler] getAddress:userDic  withSuccessBlock:^(GMAddressModal *responceData) {
//        self.billingAddressArray = (NSMutableArray *)responceData.billingAddressArray;
//        [self removeProgress];
//        [self.billingAddressTableView reloadData];
//        
//    } failureBlock:^(NSError *error) {
//        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
//        [self removeProgress];
//    }];
    
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
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        isHitOnServer = FALSE;
        [self removeProgress];
        
    }];
}


@end
