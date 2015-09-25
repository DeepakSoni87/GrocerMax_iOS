//
//  GMOrderDetailVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderDetailVC.h"
#import "GMOrderDetailCell.h"
#import "GMOrderDetailHeaderView.h"
#import "GMOrderDeatilBaseModal.h"
#import "GMOrderItemCell.h"

static NSString *kIdentifierOrderDetailCell = @"OrderDetailIdentifierCell";
static NSString *kIdentifierOrderItemCell = @"OrderItemIdentifierCell";
static NSString *kIdentifierOrderDetailHeader = @"OrderDetailIdentifierHeader";


@interface GMOrderDetailVC () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *orderDetailTableView;

@property (strong, nonatomic) NSMutableArray *detailArray;
@property (strong, nonatomic) GMOrderDeatilBaseModal *orderDeatilBaseModal;

@end

@implementation GMOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    [self configerData];
    [self getorderDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Register Cells
- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMOrderDetailCell" bundle:[NSBundle mainBundle]];
    [self.orderDetailTableView registerNib:nib forCellReuseIdentifier:kIdentifierOrderDetailCell];
    
    nib = [UINib nibWithNibName:@"GMOrderDetailHeaderView" bundle:[NSBundle mainBundle]];
    [self.orderDetailTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierOrderDetailHeader];
    
    nib = [UINib nibWithNibName:@"GMOrderItemCell" bundle:[NSBundle mainBundle]];
    [self.orderDetailTableView registerNib:nib forCellReuseIdentifier:kIdentifierOrderItemCell];
    
    
//
}

- (void) configerData {
    self.detailArray = [[NSMutableArray alloc]initWithObjects:@"Order date:",@"Shipping Charge:",@"Payment method:",@"Delivery Date:",@"Delivery Time:",@"Shipping Address:", nil] ;
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.orderDeatilBaseModal)
    {
        if(section == 0)
        {
            return 6;
        }
        else if(section == 1)
        {
            return 2;
        }
        return 0;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        GMOrderDetailCell *oderDetailCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierOrderDetailCell];
        
        oderDetailCell.tag = indexPath.row;
        NSString *value = @"";
        switch (indexPath.row) {
            case 0:
                value = self.orderDeatilBaseModal.orderDate;
                break;
            case 1:
                value = self.orderDeatilBaseModal.shippingCharge;
                break;
            case 2:
                value = self.orderDeatilBaseModal.paymentMethod;
                break;
            case 3:
                value = self.orderDeatilBaseModal.deliveryDate;
                break;
            case 4:
                value = self.orderDeatilBaseModal.deliveryTime;
                break;
            case 5:
                value = self.orderDeatilBaseModal.shippingAddress;
                break;
                
            default:
                value = @"";
                break;
        }
        [oderDetailCell configerViewData:[self.detailArray objectAtIndex:indexPath.row] value:value];
        
        return oderDetailCell;
    } else if(indexPath.section == 1){
        GMOrderItemCell *orderItemCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierOrderItemCell];
        
        orderItemCell.tag = indexPath.row;
        return orderItemCell;
    }
    
    
        return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if([self isDataAtIndex:indexPath.row]) {
            return UITableViewAutomaticDimension;
        } else {
            return 0;
        }
    } else if(indexPath.section == 1){
        return [GMOrderItemCell cellHeight];
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if([self isDataAtIndex:indexPath.row]) {
            return UITableViewAutomaticDimension;
        }  else {
            return 0;
        }
    
    } else if(indexPath.section == 1){
        return [GMOrderItemCell cellHeight];
    } else {
        return 1.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 42.0f;
    } else if(section == 1) {
        return 42.0f;
    } else {
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0 || section == 1) {
        UIView *headerView;
        GMOrderDetailHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierOrderDetailHeader];
        if (!header) {
            header = [[GMOrderDetailHeaderView alloc] initWithReuseIdentifier:kIdentifierOrderDetailHeader];
        }
        if(section == 0) {
            [header congigerHeaderData:self.orderDeatilBaseModal.orderId];
        } else {
             [header congigerHeaderData:@"YOUE ORDER"];
        }
        headerView = header;
        return headerView;
    }
    else {
        return nil;
    }
}
#pragma mark - Request Methods

#pragma mark - Request Methods

- (void)getorderDetail {
    
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    [dataDic setObject:@"5407" forKey:kEY_orderid];
    [dataDic setObject:self.orderHistoryModal.orderId forKey:kEY_orderid];
    
    
    [self showProgress];
    [[GMOperationalHandler handler] getOrderDetail:dataDic  withSuccessBlock:^(GMOrderDeatilBaseModal *responceData) {
        self.orderDeatilBaseModal = responceData;
        [self.orderDetailTableView reloadData];
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        [self removeProgress];
    }];
}


- (BOOL) isDataAtIndex:(NSInteger )index {
    if(!self.orderDeatilBaseModal) {
        return FALSE;
    }
    
    BOOL returnValue = YES;
    switch (index) {
        case 0:
            if(!NSSTRING_HAS_DATA(self.orderDeatilBaseModal.orderDate)) {
                returnValue = FALSE;
            }
            break;
        case 1:
            if(!NSSTRING_HAS_DATA(self.orderDeatilBaseModal.shippingCharge)) {
                returnValue = FALSE;
            }
            break;
        case 2:
            if(!NSSTRING_HAS_DATA(self.orderDeatilBaseModal.paymentMethod)) {
                returnValue = FALSE;
            }
            break;
        case 3:
            if(!NSSTRING_HAS_DATA(self.orderDeatilBaseModal.deliveryDate)) {
                returnValue = FALSE;
            }
            break;
        case 4:
            if(!NSSTRING_HAS_DATA(self.orderDeatilBaseModal.deliveryTime)) {
                returnValue = FALSE;
            }
            break;
        case 5:
            if(!NSSTRING_HAS_DATA(self.orderDeatilBaseModal.shippingAddress)) {
                returnValue = FALSE;
            }
            break;
            
        default:
            returnValue = FALSE;
            break;
    }
    
    return returnValue;
}
@end
