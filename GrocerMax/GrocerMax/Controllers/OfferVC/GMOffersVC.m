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
}

#pragma mark - Fill DataSource Array

-(void)fillDataSourceArray {
    
    switch (self.rootControllerType) {
            
            
        case GMRootPageViewControllerTypeOffersByDealTypeListing:
        {
            NSDictionary *dic = self.data;
            self.dataSource = dic[dic.allKeys[0]];
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
