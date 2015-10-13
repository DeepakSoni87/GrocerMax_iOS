//
//  GMOffersVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOffersVC.h"
#import "GMOffersCollectionViewCell.h"
#import "GMDealCategoryBaseModal.h"
#import "GMOffersByDealTypeModal.h"
#import "GMProductListingVC.h"

NSString *const offersCollectionViewCell = @"GMOffersCollectionViewCell";

@interface GMOffersVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak)IBOutlet UICollectionView *offersCollectionView;
@property(nonatomic,strong) NSArray *dataSource;

@end

@implementation GMOffersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its
    
    [self fillDataSourceArray];
    [self configureUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Offer_Screen];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:self.gaTrackingEventText];
}

-(void)configureUI {
    
    [self.offersCollectionView registerNib:[UINib nibWithNibName:@"GMOffersCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:offersCollectionViewCell];
    
    self.offersCollectionView.delegate = self;
    self.offersCollectionView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GMOffersCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:offersCollectionViewCell forIndexPath:indexPath];
    [cell configureCellWithData:self.dataSource[indexPath.row] cellIndexPath:indexPath andPageContType:self.rootControllerType];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (kScreenWidth - 30)/2;
    return CGSizeMake(width,width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath");
    
    GMCategoryModal *tempCategoryModal = [[GMCategoryModal alloc] init];

    switch (self.rootControllerType) {
            
        case GMRootPageViewControllerTypeOffersByDealTypeListing:
        {
            GMDealModal *mdl = self.dataSource[indexPath.row];
            tempCategoryModal.categoryId = mdl.dealId;
        }
            break;
            
        case GMRootPageViewControllerTypeDealCategoryTypeListing:
        {
            GMDealModal *mdl = self.dataSource[indexPath.row];
            tempCategoryModal.categoryId = mdl.dealId;
        }
            break;
            
        default:
            break;
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DealCategoryOpened withCategory:@"" label:tempCategoryModal.categoryName value:nil];
    
    GMProductListingVC *proListVC = [[GMProductListingVC alloc] initWithNibName:@"GMProductListingVC" bundle:nil];
    proListVC.catMdl = tempCategoryModal;
    proListVC.rootPageAPIController = [[GMRootPageAPIController alloc] init];
    proListVC.productListingType = GMProductListingFromTypeOffer_OR_Deal;
    proListVC.parentVC = self.parentVC;
    proListVC.gaTrackingEventText =  kEY_GA_Event_ProductListingThroughOffers;
    
    [self.navigationController pushViewController:proListVC animated:YES];
}

#pragma mark - scrollView Delegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_OffersListScrolling withCategory:@"" label:nil value:nil];
}

#pragma mark - Fill DataSource Array

- (void)fillDataSourceArray {
    
    switch (self.rootControllerType) {
            
            
        case GMRootPageViewControllerTypeOffersByDealTypeListing:
        {
            GMOffersByDealTypeModal *offersTypeDealModal = self.data;
            self.dataSource = offersTypeDealModal.dealsArray;
        }
            break;
        case GMRootPageViewControllerTypeDealCategoryTypeListing:
        {
            GMDealCategoryModal *mdl = self.data;
            self.dataSource = mdl.deals;
        }
            break;
        default:
            break;
    }
    
    [self.offersCollectionView reloadData];
}

@end
