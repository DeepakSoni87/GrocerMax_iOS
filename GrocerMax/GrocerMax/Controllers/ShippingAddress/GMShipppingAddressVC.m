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


@interface GMShipppingAddressVC () <AddAShippingddressDelegate>

@property (weak, nonatomic) IBOutlet UITableView *shippingAddressTableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *footerBgView;

@property (weak, nonatomic) IBOutlet UIButton *addNewAddressBtn;

@property (weak, nonatomic) IBOutlet UIView *addAddressView;

@property (strong, nonatomic) NSMutableArray *addressArray;

@property (weak, nonatomic) IBOutlet UIView *lastAddressView;

@property (weak, nonatomic) IBOutlet UIButton *shippingAsBillingBtn;

@property (nonatomic, strong) GMAddressModalData *selectedAddressModalData;

@property (nonatomic, strong) GMTimeSlotBaseModal *timeSlotBaseModal;

@property (nonatomic, strong) GMAddShippingAddressVC *addAddressVC;

@end

@implementation GMShipppingAddressVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self getShippingAddress];
    [self registerCellsForTableView];
    [self.shippingAddressTableView setTableFooterView:self.footerView];
    self.addNewAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth - 30 - 7 - 7, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    self.title = @"Shipping Address";
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Shipping_Screen];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.shippingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierShippingAddressCell];
}

#pragma mark - GETTER/SETTER Methods

- (void)setLastAddressView:(UIView *)lastAddressView {
    
    _lastAddressView = lastAddressView;
    _lastAddressView.layer.borderColor = BORDER_COLOR;
    _lastAddressView.layer.borderWidth = BORDER_WIDTH;
    _lastAddressView.layer.cornerRadius = CORNER_RADIUS;
    
}

- (void)setFooterBgView:(UIView *)footerBgView {
    
    _footerBgView = footerBgView;
    _footerBgView.layer.borderColor = BORDER_COLOR;
    _footerBgView.layer.borderWidth = BORDER_WIDTH;
    _footerBgView.layer.cornerRadius = CORNER_RADIUS;
}
#pragma mark - IBAction Methods

- (void)selectUnselectBtnClicked:(GMButton *)sender {
    
    GMAddressModalData *addressModalData = sender.addressModal;
    
    self.selectedAddressModalData.isShippingSelected = FALSE;
    if(addressModalData.isShippingSelected) {
        sender.selected = FALSE;
        addressModalData.isShippingSelected = FALSE;
    }
    else {
        sender.selected = TRUE;
        addressModalData.isShippingSelected = TRUE;
    }
    
    self.checkOutModal.shippingAddressModal = [addressModalData copy];
    self.selectedAddressModalData = addressModalData;
    [self.shippingAddressTableView reloadData];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ExistingShippingSelect withCategory:@"" label:addressModalData.street value:nil];
}

- (void)editBtnClicked:(GMButton *)sender {
    
    GMAddShippingAddressVC *addShippingAddressVC = [GMAddShippingAddressVC new];
    addShippingAddressVC.editAddressModal = sender.addressModal;
    addShippingAddressVC.newAddressHandler = ^(GMAddressModalData *addressModal, BOOL edited) {
        
        [self getShippingAddress];
    };
    [self.navigationController pushViewController:addShippingAddressVC animated:YES];
}

- (IBAction)addAddressBtnClicked:(UIButton *)sender {
    
    GMAddShippingAddressVC *addShippingAddressVC = [GMAddShippingAddressVC new];
    if(sender == nil) {
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_NewShippingSelect withCategory:@"" label:nil value:nil];
        addShippingAddressVC.isComeFromShipping = TRUE;
        [self.navigationController pushViewController:addShippingAddressVC animated:NO];
    } else {
        
        addShippingAddressVC.newAddressHandler = ^(GMAddressModalData *addressModal, BOOL edited) {
            
            [self getShippingAddress];
        };
        [self.navigationController pushViewController:addShippingAddressVC animated:YES];
    }
}

- (IBAction)actionProcess:(id)sender {
    
    if(self.checkOutModal.shippingAddressModal) {
        
        if(self.shippingAsBillingBtn.selected) {
            
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ProceedShippingBilling withCategory:@"" label:nil value:nil];
            GMDeliveryDetailVC *deliveryDetailVC = [GMDeliveryDetailVC new];
            self.checkOutModal.billingAddressModal = [self.selectedAddressModalData copy];
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
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ProceedShipping withCategory:@"" label:nil value:nil];
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
    self.checkOutModal.billingAddressModal = nil;
}

#pragma mark - TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.addressArray count];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 7.0)];
//    [headerView setBackgroundColor:[UIColor grayBackgroundColor]];
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierShippingAddressCell];
    
    GMAddressModalData *addressModalData = [self.addressArray objectAtIndex:indexPath.row];
    [addressCell configerViewWithData:addressModalData];
    if(addressModalData.isShippingSelected)
        addressCell.selectUnSelectBtn.selected = YES;
    else
        addressCell.selectUnSelectBtn.selected = NO;
    [addressCell.selectUnSelectBtn addTarget:self action:@selector(selectUnselectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addressCell.editAddressBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return addressCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMAddressCell cellHeight];
}

#pragma mark Request Methods

- (void)getShippingAddress {
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.email))
        [dataDic setObject:userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(userModal.userId))
        [dataDic setObject:userModal.userId forKey:kEY_userid];
    [self showProgress];
    [[GMOperationalHandler handler] getAddressWithTimeSlot:dataDic withSuccessBlock:^(GMTimeSlotBaseModal *responceData) {
        self.timeSlotBaseModal = responceData;
        if(responceData.addressesArray.count > 0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMAddressModalData *evaluatedObject, NSDictionary *bindings) {
                
                int isShippingValue = evaluatedObject.is_default_shipping.intValue;
                int isBillingValue = evaluatedObject.is_default_billing.intValue;
                
                if((isShippingValue == 1) || ((isShippingValue == 0) && (isBillingValue == 0))) {
                    return YES;
                }
                else
                    return NO;
            }];
            
            NSArray *shippingAddressArray = [responceData.addressesArray filteredArrayUsingPredicate:predicate];
            if(shippingAddressArray.count > 0) {
                
                self.addressArray = [NSMutableArray arrayWithArray:shippingAddressArray];
                [self.shippingAddressTableView reloadData];
            } else
                [self addSubviewAddressView];
        } else {
            [self addSubviewAddressView];
        }
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        [self removeProgress];
        
    }];
}

- (void)addSubviewAddressView {
    
    self.addAddressVC = [GMAddShippingAddressVC new];
    self.addAddressVC.isComeFromShipping = TRUE;
    self.addAddressVC.delegate = self;
    self.addAddressVC.view.frame = self.addAddressView.bounds;
    [self.addAddressView addSubview:self.addAddressVC.view];
    self.addAddressView.hidden = FALSE;
}

#pragma mark - AddShippingVC Delegate method

- (void)removeFromSupperView {
    
    [self.addAddressVC.view removeFromSuperview];
    self.addAddressVC = nil;
    self.addAddressView.hidden = TRUE;
    [self getShippingAddress];
}
@end
