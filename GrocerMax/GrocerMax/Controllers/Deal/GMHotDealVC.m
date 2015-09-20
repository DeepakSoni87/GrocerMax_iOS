//
//  GMHotDealVC.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHotDealVC.h"
#import "GMHotDealCollectionViewCell.h"

static NSString *kIdentifierHotDealCollectionCell = @"hotDealIdentifierCollectionCell";

@interface GMHotDealVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *dealCollectionView;

@end

@implementation GMHotDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForCollectionView];
}

- (void)registerCellsForCollectionView {
    
    UINib *nib = [UINib nibWithNibName:@"GMHotDealCollectionViewCell" bundle:[NSBundle mainBundle]];
    
    [self.dealCollectionView registerNib:nib forCellWithReuseIdentifier:kIdentifierHotDealCollectionCell];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GMHotDealCollectionViewCell *hotDealCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierHotDealCollectionCell forIndexPath:indexPath];
    return hotDealCollectionViewCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval =  CGSizeMake(160, 160);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

[[GMSharedClass sharedClass] showInfoMessage:[NSString stringWithFormat:@"Arvind %ld",indexPath.row]];
    
}
@end
