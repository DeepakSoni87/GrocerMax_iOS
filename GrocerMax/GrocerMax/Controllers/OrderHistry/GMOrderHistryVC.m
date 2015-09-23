//
//  GMOrderHistryVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderHistryVC.h"
#import "GMOrderHistoryCell.h"
#import "GMBaseOrderHistoryModal.h"

static NSString *kIdentifierOrderHistoryCell = @"orderHistoryIdentifierCell";
@interface GMOrderHistryVC ()
@property (weak, nonatomic) IBOutlet UITableView *orderHistryTableView;
@property (nonatomic, strong) GMUserModal *userModal;

@end

@implementation GMOrderHistryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userModal = [GMUserModal loggedInUser];
    self.navigationController.navigationBarHidden = NO;
    self.orderHistoryDataArray = [[NSMutableArray alloc]init];
    [self registerCellsForTableView];
    [self getOrderHistryFromServer];
}

#pragma mark - WebService Handler
- (void)getOrderHistryFromServer
{
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.userModal.email))
        [userDic setObject:self.userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(self.userModal.userId))
        [userDic setObject:self.userModal.userId forKey:kEY_userid];
    
    [self showProgress];
    
    [[GMOperationalHandler handler] orderHistory:userDic withSuccessBlock:^(NSArray *responceData) {
        [self.orderHistoryDataArray addObjectsFromArray:responceData];
        [self.orderHistryTableView reloadData];
            [self removeProgress];
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        [self removeProgress];
        
    }];
}

#pragma mark - Register Cell

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMOrderHistoryCell" bundle:[NSBundle mainBundle]];
    [self.orderHistryTableView registerNib:nib forCellReuseIdentifier:kIdentifierOrderHistoryCell];
    
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

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
        return self.orderHistoryDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMOrderHistoryCell *orderHistoryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierOrderHistoryCell];
    orderHistoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    orderHistoryCell.tag = indexPath.row;
    GMOrderHistoryModal *orderHistoryModal  = [self.orderHistoryDataArray objectAtIndex:indexPath.row];
    [orderHistoryCell configerViewWithData:orderHistoryModal];
    return orderHistoryCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 131.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMOrderHistoryModal *orderHistoryModal  = [self.orderHistoryDataArray objectAtIndex:indexPath.row];
    
    //use for detail;
    
}



@end
