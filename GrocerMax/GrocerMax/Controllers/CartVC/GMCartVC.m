//
//  GMCartVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartVC.h"
#import "GMCartModal.h"
#import "GMCartDetailModal.h"
#import "GMCartCell.h"

@interface GMCartVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cartDetailTableView;

@property (weak, nonatomic) IBOutlet UIView *totalView;

@property (nonatomic, strong) NSMutableArray *cartItemsArray;
@end

static NSString * const kCartCellIdentifier           = @"cartCellIdentifier";

@implementation GMCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    GMCartModal *cartModal = [GMCartModal loadCart];
    if(cartModal)
        [self fetchCartDetailFromServer];
}

- (void)registerCellsForTableView {
    
    [self.cartDetailTableView registerNib:[UINib nibWithNibName:@"GMCartCell" bundle:nil] forCellReuseIdentifier:kCartCellIdentifier];
}

- (void)fetchCartDetailFromServer {
    
    GMCartModal *cartModal = [GMCartModal loadCart];
    NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] updateDeleteRequestParameterFromCartModal:cartModal];
    [self showProgress];
    [[GMOperationalHandler handler] deleteItem:requestParam withSuccessBlock:^(GMCartDetailModal *cartDetailModal) {
        
        [self removeProgress];
        self.cartItemsArray = cartDetailModal.productItemsArray;
        [self.cartDetailTableView reloadData];
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

#pragma mark - UITableView Delegates/Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.cartItemsArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.cartDetailTableView.frame), 7.0)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GMProductModal *productModal = [self.cartItemsArray objectAtIndex:indexPath.row];
    GMCartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:kCartCellIdentifier];
    [cartCell.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cartCell configureViewWithProductModal:productModal];
    return cartCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMCartCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - IBAction Methods

- (void)deleteButtonTapped:(GMButton *)sender {
    
    
}

- (IBAction)placeOrderButtonTapped:(id)sender {
    
    
}

- (IBAction)updateOrderButtonTapped:(id)sender {
    
    
}
@end
