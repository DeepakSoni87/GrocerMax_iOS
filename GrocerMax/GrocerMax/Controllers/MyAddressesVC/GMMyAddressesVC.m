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

static NSString *kIdentifierMyAddressCell = @"MyAddressIdentifierCell";

@interface GMMyAddressesVC ()

@property (weak, nonatomic) IBOutlet UITableView *myAddressTableView;

@property (strong, nonatomic) NSMutableArray *addressArray;

@property (nonatomic, strong) GMUserModal *userModal;

@end

@implementation GMMyAddressesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userModal = [GMUserModal loggedInUser];
    self.navigationController.navigationBarHidden = NO;
    [self.myAddressTableView setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];
    [self.view setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];
    
    [self getMyAddress];
    [self registerCellsForTableView];
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

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.myAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierMyAddressCell];
}
#pragma mark Button Action Methods
- (void) selectUnselectBtnClicked:(GMButton *)sender {
    
    GMAddressModalData *addressModalData = sender.addressModal;
    
    
    if(addressModalData.isSelected) {
        sender.selected = FALSE;
        addressModalData.isSelected = FALSE;
    }
    else {
        sender.selected = TRUE;
        addressModalData.isSelected = TRUE;
    }
}

- (void) editBtnClicked:(GMButton *)sender {
    
}
- (void) addAddressBtnClicked:(UIButton *)sender {
    
}
- (IBAction)actionAddAddressBtnClicked:(id)sender {
    
}
#pragma mark Request Methods

- (void)getMyAddress {
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    
    if(NSSTRING_HAS_DATA(self.userModal.email))
        [userDic setObject:self.userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(self.userModal.userId))
//        [userDic setObject:@"321"forKey:kEY_userid];
    [self showProgress];
    [[GMOperationalHandler handler] getAddress:userDic  withSuccessBlock:^(GMAddressModal *responceData) {
        
        self.addressArray = (NSMutableArray *)responceData.addressArray;
        [self.myAddressTableView reloadData];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        [self removeProgress];
    }];
}


#pragma mark TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [self.addressArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierMyAddressCell];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return [GMAddressCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
