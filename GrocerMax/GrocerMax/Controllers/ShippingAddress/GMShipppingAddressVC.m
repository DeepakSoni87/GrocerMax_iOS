//
//  GMShipppingAddressVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMShipppingAddressVC.h"

#import "GMAddressCell.h"
#import "GMTAddAddressCell.h"
#import "GMBillingAddressVC.h"
#import "GMDeliveryDetailVC.h"
#import "GMAddShippingAddressVC.h"

static NSString *kIdentifierShippingAddressCell = @"ShippingAddressIdentifierCell";
static NSString *kIdentifierAddAddressCell = @"AddAddressIdentifierCell";


@interface GMShipppingAddressVC ()
{
    BOOL isFirst;
    BOOL isHitOnServer;
}
@property (weak, nonatomic) IBOutlet UITableView *shippingAddressTableView;
@property (strong, nonatomic) NSMutableArray *addressArray;
@property (weak, nonatomic) IBOutlet UIView *lastAddressView;
@property (weak, nonatomic) IBOutlet UIButton *shippingAsBillingBtn;
@property (nonatomic, strong) GMUserModal *userModal;
@property (nonatomic, strong) GMAddressModalData *selectedAddressModalData;

@property (nonatomic, strong) GMTimeSlotBaseModal *timeSlotBaseModal;




@end

@implementation GMShipppingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = TRUE;
    // Do any additional setup after loading the view from its nib.
    self.userModal = [GMUserModal loggedInUser];
    self.navigationController.navigationBarHidden = NO;
    [self.shippingAddressTableView setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];
    [self.view setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];
    self.lastAddressView.layer.borderColor = [UIColor colorWithRed:216.0/256.0 green:216.0/256.0 blue:216.0/256.0 alpha:1].CGColor;
    self.lastAddressView.layer.borderWidth = 2.0;
    self.lastAddressView.layer.cornerRadius = 4.0;
//    self.checkOutModal = [[GMCheckOutModal alloc] init];
    self.checkOutModal.userModal = self.userModal;
//    self.checkOutModal.cartModal = self.cartModal;
    isHitOnServer = TRUE;
//    [self getShippingAddress];
    [self registerCellsForTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    if(isHitOnServer)
        [self getShippingAddress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.shippingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierShippingAddressCell];
    
    nib = [UINib nibWithNibName:@"GMTAddAddressCell" bundle:[NSBundle mainBundle]];
    [self.shippingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierAddAddressCell];
}

- (void) selectUnselectBtnClicked:(GMButton *)sender {
    
    GMAddressModalData *addressModalData = sender.addressModal;
    
    self.selectedAddressModalData.isSelected = FALSE;
    
    
    
    if(addressModalData.isSelected) {
        sender.selected = FALSE;
        addressModalData.isSelected = FALSE;
    }
    else {
        sender.selected = TRUE;
        addressModalData.isSelected = TRUE;
    }
    
    self.checkOutModal.shippingAddressModal = addressModalData;
    self.selectedAddressModalData = addressModalData;
    [self.shippingAddressTableView reloadData];
}

- (void) editBtnClicked:(GMButton *)sender {
    isHitOnServer = TRUE;
    GMAddShippingAddressVC *addShippingAddressVC = [GMAddShippingAddressVC new];
    addShippingAddressVC.editAddressModal = sender.addressModal;
    [self.navigationController pushViewController:addShippingAddressVC animated:YES];
    
}
- (void) addAddressBtnClicked:(UIButton *)sender {
    
    isHitOnServer = TRUE;
    GMAddShippingAddressVC *addShippingAddressVC = [GMAddShippingAddressVC new];
    if(sender == nil) {
        addShippingAddressVC.isProgress = TRUE;
        [self.navigationController pushViewController:addShippingAddressVC animated:NO];
    } else {
        [self.navigationController pushViewController:addShippingAddressVC animated:YES];
    }
    
    
}
- (IBAction)actionProcess:(id)sender {
    
    isHitOnServer = FALSE;
    if(self.checkOutModal.shippingAddressModal) {
        if(self.shippingAsBillingBtn.selected) {
            GMDeliveryDetailVC *deliveryDetailVC = [GMDeliveryDetailVC new];
            self.checkOutModal.billingAddressModal = self.selectedAddressModalData;
            deliveryDetailVC.checkOutModal = self.checkOutModal;
            deliveryDetailVC.timeSlotBaseModal = self.timeSlotBaseModal;
            [self.navigationController pushViewController:deliveryDetailVC animated:YES];
            
            return ;
        }
        
        GMBillingAddressVC *billingAddressVC = [GMBillingAddressVC new];
        billingAddressVC.checkOutModal = self.checkOutModal;
        billingAddressVC.timeSlotBaseModal = self.timeSlotBaseModal;
        
        if(self.timeSlotBaseModal.addressesArray.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMAddressModalData *evaluatedObject, NSDictionary *bindings) {
                
                int isBillingValue = evaluatedObject.is_default_billing.intValue;
                
                if(isBillingValue == 1) {
                    return YES;
                }
                else
                    return NO;
            }];
            
            NSArray *arry = [self.timeSlotBaseModal.addressesArray filteredArrayUsingPredicate:predicate];
            if(arry.count>0)
            {
                NSMutableArray *billingAddressArray = [[NSMutableArray alloc]init];
                [billingAddressArray addObjectsFromArray:arry];
                billingAddressVC.billingAddressArray = billingAddressArray;
            }
        }
        [self.navigationController pushViewController:billingAddressVC animated:YES];
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please select shipping address."];
    }
    
}

- (IBAction)actionShippingAsBilling:(UIButton *)sender {
    
   if(self.shippingAsBillingBtn.selected) {
        self.shippingAsBillingBtn.selected = FALSE;
    }
    else {
        self.shippingAsBillingBtn.selected = TRUE;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [self.addressArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.addressArray == nil || [self.addressArray count]==indexPath.row)
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
        GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierShippingAddressCell];
        
        GMAddressModalData *addressModalData = [self.addressArray objectAtIndex:indexPath.row];
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
    
    if(self.addressArray == nil || [self.addressArray count]==indexPath.row)
    {
        return 55.0f;
    }
    else
    {
        return [GMAddressCell cellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark Request Methods

- (void)getShippingAddress {
//    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
//    
//    if(NSSTRING_HAS_DATA(self.userModal.email))
//        [userDic setObject:self.userModal.email forKey:kEY_email];
//    if(NSSTRING_HAS_DATA(self.userModal.userId))
//        [userDic setObject:self.userModal.userId forKey:kEY_userid];
//    [self showProgress];
//    [[GMOperationalHandler handler] getAddress:userDic  withSuccessBlock:^(GMAddressModal *responceData) {
//        
//        self.addressArray = (NSMutableArray *)responceData.shippingAddressArray;
//        [self.shippingAddressTableView reloadData];
//        [self removeProgress];
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
//    [dataDic setObject:@"13807" forKey:kEY_userid];
    [self showProgress];
    [[GMOperationalHandler handler] getAddressWithTimeSlot:dataDic withSuccessBlock:^(GMTimeSlotBaseModal *responceData) {
        isHitOnServer = FALSE;
        self.timeSlotBaseModal = responceData;
        if(responceData.addressesArray.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMAddressModalData *evaluatedObject, NSDictionary *bindings) {
                
                int isShippingValue = evaluatedObject.is_default_shipping.intValue;
                int isBillingValue = evaluatedObject.is_default_billing.intValue;
                
                if((isShippingValue == 1) || ((isShippingValue == 0) && (isBillingValue == 0))) {
                    return YES;
                }
                else
                    return NO;
            }];
            
            NSArray *arry = [responceData.addressesArray filteredArrayUsingPredicate:predicate];
            if(arry.count>0)
            {
                self.addressArray = (NSMutableArray *)arry;
                [self.shippingAddressTableView reloadData];
            } else {
                if(isFirst) {
                    isFirst = FALSE ;
                    [self addAddressBtnClicked:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }
        } else {
            if(isFirst) {
                isFirst = FALSE ;
                [self addAddressBtnClicked:nil];
            } else {
                [self.navigationController popViewControllerAnimated:NO];
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
