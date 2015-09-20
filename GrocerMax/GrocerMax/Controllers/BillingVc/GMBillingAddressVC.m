//
//  GMBillingAddressVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMBillingAddressVC.h"
#import "GMAddressCell.h"

static NSString *kIdentifierBillingAddressCell = @"BillingAddressIdentifierCell";
@interface GMBillingAddressVC ()
@property (strong, nonatomic) IBOutlet UITableView *billingAddressTableView;

@end

@implementation GMBillingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self registerCellsForTableView];
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.billingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierBillingAddressCell];
    
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


#pragma mark TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierBillingAddressCell];
    addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
    addressCell.tag = indexPath.row;
    [addressCell configerViewWithData:nil];
    return addressCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [GMAddressCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
