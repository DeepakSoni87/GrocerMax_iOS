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
    [self getHotDealDataFromServer];
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
#pragma mark - WebService Handler

- (void) getHotDealDataFromServer {
        [self showProgress];
    
    [[GMOperationalHandler handler] shopByDealType:nil withSuccessBlock:^(NSArray *responceData) {
        self.hotdealArray = (NSMutableArray *)responceData;
        if(self.hotdealArray.count>0) {
            [self.dealCollectionView reloadData];
        } else {
            [[GMSharedClass sharedClass] showErrorMessage:@"No Hot deal available"];
        }
        
        [self removeProgress];
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        [self removeProgress];
        
    }];
}
#pragma mark - UICollectionView DataSource and Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.hotdealArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
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
    [[GMSharedClass sharedClass] showInfoMessage:hotDealModal.dealType];
}
@end
