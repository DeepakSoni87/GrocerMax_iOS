//
//  GMHotDealVC.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHotDealVC.h"
#import "GMHotDealCollectionViewCell.h"
#import "GMHotDealBaseModal.h"
#import "GMDealCategoryBaseModal.h"
#import "GMRootPageViewController.h"

static NSString *kIdentifierHotDealCollectionCell = @"hotDealIdentifierCollectionCell";

@interface GMHotDealVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *dealCollectionView;

@property (strong, nonatomic) NSMutableArray *hotdealArray;

@end

@implementation GMHotDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForCollectionView];
    [self fetchHotDealsDataFronDB];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage backBtnImage]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(homeButtonPressed:)];
}

- (void)registerCellsForCollectionView {
    
    UINib *nib = [UINib nibWithNibName:@"GMHotDealCollectionViewCell" bundle:[NSBundle mainBundle]];
    
    [self.dealCollectionView registerNib:nib forCellWithReuseIdentifier:kIdentifierHotDealCollectionCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Hot Offers";
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_HotDeal_Screen];
}

#pragma mark - Button action

- (void)homeButtonPressed:(UIBarButtonItem*)sender {
    
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - WebService Handler

- (void)fetchHotDealsDataFronDB {
    
    GMHotDealBaseModal *hotDealBaseModal = [GMHotDealBaseModal loadHotDeals];
    self.hotdealArray = [NSMutableArray arrayWithArray:hotDealBaseModal.hotDealArray];
    [self.dealCollectionView reloadData];
}

#pragma mark - UICollectionView DataSource and Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.hotdealArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    GMHotDealModal *hotDealModal = [self.hotdealArray objectAtIndex:indexPath.row];
    GMHotDealCollectionViewCell *hotDealCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierHotDealCollectionCell forIndexPath:indexPath];
    [hotDealCollectionViewCell configureCellWithData:hotDealModal];
    return hotDealCollectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval =  CGSizeMake(160 + 160 *(SCREEN_SIZE.width-320)/320, 160);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GMHotDealModal *hotDealModal = [self.hotdealArray objectAtIndex:indexPath.row];
    [self fetchDealCategoriesFromServerWithDealTypeId:hotDealModal.dealTypeId];
}

#pragma mark - Server handling Methods

- (void)fetchDealCategoriesFromServerWithDealTypeId:(NSString *)dealTypeId {
    
    [self showProgress];
    [[GMOperationalHandler handler] dealsByDealType:@{kEY_deal_type_id :dealTypeId, kEY_device : kEY_iOS} withSuccessBlock:^(GMDealCategoryBaseModal *dealCategoryBaseModal) {
        
        [self removeProgress];
        NSMutableArray *dealCategoryArray = [self createCategoryDealsArrayWith:dealCategoryBaseModal];
        if (dealCategoryArray.count == 0) {
            return ;
        }

        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = dealCategoryArray;
        rootVC.navigationTitleString = [dealCategoryBaseModal.dealNameArray firstObject];
        rootVC.rootControllerType = GMRootPageViewControllerTypeDealCategoryTypeListing;
        [self.navigationController pushViewController:rootVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

- (NSMutableArray *)createCategoryDealsArrayWith:(GMDealCategoryBaseModal *)dealCategoryBaseModal {
    
    NSMutableArray *dealCategoryArray = [NSMutableArray arrayWithArray:dealCategoryBaseModal.dealCategories];
    GMDealCategoryModal *allModal = [[GMDealCategoryModal alloc] initWithCategoryId:@"" images:@"" categoryName:@"All" isActive:@"1" andDeals:dealCategoryBaseModal.allDealCategory];
    [dealCategoryArray insertObject:allModal atIndex:0];
    return dealCategoryArray;
}
@end
