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

static NSString *kIdentifierBillingAddressCell = @"BillingAddressIdentifierCell";
static NSString *kIdentifierAddAddressCell = @"AddAddressIdentifierCell";
@interface GMBillingAddressVC ()
@property (strong, nonatomic) NSMutableArray *billingAddressArray;
@property (strong, nonatomic) IBOutlet UITableView *billingAddressTableView;

@end

@implementation GMBillingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self.billingAddressTableView setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];

    [self getBillingAddress];
    [self registerCellsForTableView];
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
   
    
    if(addressModalData.isSelected) {
        sender.selected = FALSE;
        addressModalData.isSelected = FALSE;
    }
    else {
        sender.selected = TRUE;
        addressModalData.isSelected = TRUE;
    }
}

- (void) editBtnClicked:(UIButton *)sender {
    
}
- (void) addAddressBtnClicked:(UIButton *)sender {
    
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
    
}


#pragma mark Request Methods

- (void)getBillingAddress {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    [dataDic setObject:@"321" forKey:kEY_userid];
    [self showProgress];
    [[GMOperationalHandler handler] getAddress:dataDic  withSuccessBlock:^(id responceData) {
        self.billingAddressArray = (NSMutableArray *)responceData;
        [self removeProgress];
        [self.billingAddressTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        [self removeProgress];
    }];
}


@end
