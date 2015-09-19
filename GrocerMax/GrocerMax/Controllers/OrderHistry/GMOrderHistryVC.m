//
//  GMOrderHistryVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderHistryVC.h"
#import "GMOrderHistryModal.h"
#import "GMOrderHistoryCell.h"


static NSString *kIdentifierOrderHistoryCell = @"orderHistoryIdentifierCell";
@interface GMOrderHistryVC ()
@property (weak, nonatomic) IBOutlet UITableView *orderHistryTableView;

@end

@implementation GMOrderHistryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self registerCellsForTableView];
    [self testData];
}

-(void)testData
{
    self.orderHistoryDataArray = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        GMOrderHistryModal *orderHistryModal = [[GMOrderHistryModal alloc]init];
        orderHistryModal.orderId = [NSString stringWithFormat:@"%d",i*234 + 77];
        orderHistryModal.orderDate = @"Aug 21, 2015. 13:25 pm";
        orderHistryModal.orderAmountPaid = @"$18.98";
        orderHistryModal.orderStatus = @"Pending";
        orderHistryModal.orderItems = [NSString stringWithFormat:@"%d",i+2];
        [self.orderHistoryDataArray addObject:orderHistryModal];
    }
}

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

#pragma mark TableView DataSource and Delegate Methods
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
    GMOrderHistryModal *orderHistryModal  = [self.orderHistoryDataArray objectAtIndex:indexPath.section];
    [orderHistoryCell configerViewWithData:orderHistryModal];
    return orderHistoryCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 136.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
