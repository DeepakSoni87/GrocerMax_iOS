//
//  GMOffersCollectionViewCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOffersCollectionViewCell.h"

@interface GMOffersCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImgView;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@end

@implementation GMOffersCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.clipsToBounds = YES;
    
    self.itemImgView.layer.cornerRadius = 5.0;
    self.itemImgView.layer.masksToBounds = YES;
    self.itemImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.itemImgView.layer.borderWidth = 3.0;
}

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath{
    
    
    NSDictionary* style1 = @{
                             NSFontAttributeName:FONT_LIGHT(13),
                             NSForegroundColorAttributeName : [UIColor whiteColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName:FONT_LIGHT(10),
                             NSForegroundColorAttributeName : [UIColor lightGrayColor]
                             };
    
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:@"Buy 1 Get 1 Free \n" attributes:style1];
    
    [attString1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"Maaza" attributes:style2]];
    
    self.itemName.attributedText = attString1;
}

@end