//
//  GMMyWalletVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 06/12/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import "GMMyWalletVC.h"

@interface GMMyWalletVC ()

@end

@implementation GMMyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getWalletDataFromServer];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"My Wallet";    
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Wallet_Screen];
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

-(void)getWalletDataFromServer {
    [self showProgress];
    
    //staging.grocermax.com/api/getwalletbalance?CustId=
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.email))
        [userDic setObject:userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [userDic setObject:userModal.userId forKey:kEY_userid];
        [userDic setObject:userModal.userId forKey:@"CustId"];
    }
    
    [[GMOperationalHandler handler] getUserWalletItem:userDic withSuccessBlock:^(id responceData) {
        [self removeProgress];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

@end
