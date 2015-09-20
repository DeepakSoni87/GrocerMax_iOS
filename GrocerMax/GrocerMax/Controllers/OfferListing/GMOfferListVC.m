//
//  GMOfferListVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOfferListVC.h"
#import "GMTOfferListCell.h"


static NSString *kIdentifierOfferListCell = @"offerListIdentifierCell";
@interface GMOfferListVC ()
@property (strong, nonatomic) IBOutlet UITableView *offerListTableView;

@end

@implementation GMOfferListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"BEBEBE"]];
    [self registerCellsForTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMTOfferListCell" bundle:[NSBundle mainBundle]];
    [self.offerListTableView registerNib:nib forCellReuseIdentifier:kIdentifierOfferListCell];
    
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
    
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMTOfferListCell *offerListCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierOfferListCell];
    offerListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    offerListCell.tag = indexPath.row;
    [offerListCell configerViewWithData:nil];
    return offerListCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
