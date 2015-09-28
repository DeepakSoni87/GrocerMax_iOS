//
//  GMMyAddressesVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMMyAddressesVC.h"
#import "GMAddressCell.h"
#import "GMTAddAddressCell.h"
#import "GMAddShippingAddressVC.h"
#import "GMStateBaseModal.h"

static NSString *kIdentifierMyAddressCell = @"MyAddressIdentifierCell";

@interface GMMyAddressesVC ()

@property (weak, nonatomic) IBOutlet UITableView *myAddressTableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;


@property (strong, nonatomic) NSMutableArray *addressArray;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) GMAddShippingAddressVC *addressShippingVC;
@end

@implementation GMMyAddressesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self getMyAddress];
    [self registerCellsForTableView];
    [self.myAddressTableView setTableFooterView:self.footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.myAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierMyAddressCell];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.title = @"Shipping Addresses";
    [self getMyAddress];
}

#pragma mark - GETTER/SETTER Methods

- (GMUserModal *)userModal {
    
    if(!_userModal) _userModal = [GMUserModal loggedInUser];
    return _userModal;
}

- (GMAddShippingAddressVC *)addressShippingVC {
    
    if(!_addressShippingVC) {
        
        _addressShippingVC = [[GMAddShippingAddressVC alloc] initWithNibName:@"GMAddShippingAddressVC" bundle:nil];
        [_addressShippingVC.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    }
    return _addressShippingVC;
}

#pragma mark - Request Methods

- (void)getMyAddress {
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    GMCityModal *cityModal =[GMCityModal selectedLocation];
    if(cityModal == nil) {
        [userDic setObject:@"1" forKey:kEY_cityId];
    } else {
        if(NSSTRING_HAS_DATA(cityModal.cityId))  {
            [userDic setObject:cityModal.cityId forKey:kEY_cityId];
        } else {
            [userDic setObject:@"1" forKey:kEY_cityId];
        }
        
    }
    if(NSSTRING_HAS_DATA(self.userModal.userId))
    [userDic setObject:self.userModal.userId forKey:kEY_userid];
    
    [self showProgress];
    [[GMOperationalHandler handler] getAddress:userDic  withSuccessBlock:^(GMAddressModal *responceData) {
        
        [self removeProgress];
        self.addressArray = (NSMutableArray *)responceData.shippingAddressArray;
        if(!self.addressArray.count) {
            
//            [self addNewAddressButtonTapped:nil];
//            self.title = @"Shipping Address";
//            [self.view addSubview:self.addressShippingVC.view];
//            return;
        }
        [self.myAddressTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        [self removeProgress];
    }];
}


#pragma mark - TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.addressArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMAddressCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierMyAddressCell];
    
    GMAddressModalData *addressModalData = [self.addressArray objectAtIndex:indexPath.row];
    addressCell.tag = indexPath.row;
    [addressCell configerViewWithData:addressModalData];
    [addressCell.selectUnSelectBtn setHidden:YES];
    [addressCell.editAddressBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return addressCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Button Action Methods

- (void) editBtnClicked:(GMButton *)sender {
    
    GMAddressModalData *addressModalData = sender.addressModal;
    GMAddShippingAddressVC *shippingAddressVC = [[GMAddShippingAddressVC alloc] initWithNibName:@"GMAddShippingAddressVC" bundle:nil];
    shippingAddressVC.editAddressModal = addressModalData;
    [self.navigationController pushViewController:shippingAddressVC animated:YES];
}

- (IBAction)addNewAddressButtonTapped:(id)sender {
    
    GMAddShippingAddressVC *shippingAddressVC = [[GMAddShippingAddressVC alloc] initWithNibName:@"GMAddShippingAddressVC" bundle:nil];
    [self.navigationController pushViewController:shippingAddressVC animated:YES];
}


@end
