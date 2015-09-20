//
//  GMShopByCategoryCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMShopByCategoryCell.h"
#import "GMShopByCategoryCollectionViewCell.h"


NSString *const shopByCategoryCollectionViewCell = @"GMShopByCategoryCollectionViewCell";

@interface GMShopByCategoryCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,weak)IBOutlet UICollectionView *categoryCollectionView;
@property (nonatomic) NSIndexPath* tblIndexPath;
@property (nonatomic) NSArray* categoriesArray;

@end

@implementation GMShopByCategoryCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.categoryCollectionView registerClass:[GMShopByCategoryCollectionViewCell class] forCellWithReuseIdentifier:shopByCategoryCollectionViewCell];
    [self.categoryCollectionView registerNib:[UINib nibWithNibName:@"GMShopByCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:shopByCategoryCollectionViewCell];

    self.categoryCollectionView.delegate = self;
    self.categoryCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Configure Cell

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath{
    
    self.categoriesArray = data;
    self.tblIndexPath = indexPath;
    [self.categoryCollectionView reloadData];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoriesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GMShopByCategoryCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:shopByCategoryCollectionViewCell forIndexPath:indexPath];
    [cell configureCellWithData:self.categoriesArray[indexPath.item] cellIndexPath:indexPath];
    cell.offerBtn.tag = indexPath.item;
    [cell.offerBtn addTarget:self action:@selector(offerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(220, self.categoryCollectionView.bounds.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectCategoryItemAtTableViewCellIndexPath:andCollectionViewIndexPath:)]) {
        [self.delegate didSelectCategoryItemAtTableViewCellIndexPath:self.tblIndexPath andCollectionViewIndexPath:indexPath];
    }
}

#pragma mark - Button Action

-(void)offerBtnPressed:(UIButton*)sender {
    
    if ([self.delegate respondsToSelector:@selector(offerBtnPressedAtTableViewCellIndexPath:andCollectionViewIndexPath:)]) {
        [self.delegate offerBtnPressedAtTableViewCellIndexPath:self.tblIndexPath andCollectionViewIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    }
}

@end
