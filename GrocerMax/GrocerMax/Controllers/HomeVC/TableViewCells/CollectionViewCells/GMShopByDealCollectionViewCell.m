//
//  GMShopByDealCollectionViewCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMShopByDealCollectionViewCell.h"

@interface GMShopByDealCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *buy1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *get1FreeLbl;

@end

@implementation GMShopByDealCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bgImgView.layer.cornerRadius = 2.0;
    self.bgImgView.layer.masksToBounds = YES;
}

#pragma mark - Configure Cell

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath{

    NSDictionary* style1 = @{
                             NSFontAttributeName:FONT_LIGHT(11),
                             NSForegroundColorAttributeName : [UIColor whiteColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName:FONT_LIGHT(20),
                             NSForegroundColorAttributeName : [UIColor whiteColor]
                             };
    
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:@"Buy 1 \nBuy 2 \nBuy 3" attributes:style1];
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:@"GET 1 \nFREE" attributes:style2];
    
    self.buy1Lbl.attributedText = attString1;
    self.get1FreeLbl.attributedText = attString2;
    
}

@end
