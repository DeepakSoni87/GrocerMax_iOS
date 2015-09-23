//
//  GMProductListingVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductListingVC.h"
#import "GMProductListTableViewCell.h"
#import "GMProductDescriptionVC.h"

NSString *const kGMProductListTableViewCell = @"GMProductListTableViewCell";

@interface GMProductListingVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,GMRootPageAPIControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *tblFooterLoadMoreView;
@property (weak, nonatomic) IBOutlet UITableView *productListTblView;
@property (strong, nonatomic) GMProductListingBaseModal *productBaseModal;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation GMProductListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellsForTableView];
    [self configureUI];
    
    self.rootPageAPIController.delegate = self;
    self.productBaseModal = [self.rootPageAPIController.modalDic objectForKey:self.catMdl.categoryId];
    
    if (self.productBaseModal.productsListArray.count == 0) {
        [self.rootPageAPIController fetchProductListingDataForCategory:self.catMdl];
    }
    
    [self.productListTblView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configureUI

-(void) configureUI{
    
    self.productListTblView.delegate = self;
    self.productListTblView.dataSource = self;
    self.productListTblView.tableFooterView = [UIView new];
}

#pragma mark - Register Cells

- (void)registerCellsForTableView {
    
    [self.productListTblView registerNib:[UINib nibWithNibName:@"GMProductListTableViewCell" bundle:nil] forCellReuseIdentifier:kGMProductListTableViewCell];
}

#pragma mark - UITableviewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productBaseModal.productsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGMProductListTableViewCell];
    [cell configureCellWithData:self.productBaseModal.productsListArray[indexPath.row] cellIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
    vc.modal = self.productBaseModal.productsListArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - scrollView Delegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(self.isLoading)
        return; // currently executing this method
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat targetY = scrollView.contentSize.height - scrollView.bounds.size.height;
    
    if (offsetY > targetY) { // hit api for next page
        
        if (self.productBaseModal.productsListArray.count < self.productBaseModal.totalcount) {
            self.isLoading = YES;
            self.productListTblView.tableFooterView = self.tblFooterLoadMoreView;
            [self.rootPageAPIController fetchProductListingDataForCategory:self.catMdl];
        }
    }
}

#pragma mark -

-(void)rootPageAPIControllerDidFinishTask:(GMRootPageAPIController *)controller
{
    self.isLoading = NO;
    self.productListTblView.tableFooterView = nil;
    self.productBaseModal = [self.rootPageAPIController.modalDic objectForKey:self.catMdl.categoryId];
    [self.productListTblView reloadData];
}

@end
