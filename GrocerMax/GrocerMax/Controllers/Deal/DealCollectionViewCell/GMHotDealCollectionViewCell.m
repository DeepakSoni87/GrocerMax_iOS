//
//  GMHotDealCollectionViewCell.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHotDealCollectionViewCell.h"
#import "GMHotDealBaseModal.h"

@implementation GMHotDealCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.cellBgView.layer.borderColor = [UIColor colorFromHexString:@"BEBEBE"].CGColor;
//    self.cellBgView.layer.borderWidth = 1.0;
    self.cellBgView.layer.cornerRadius = 2.0;
    
//    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
}


- (void)configureCellWithData:(id)data {
    
    GMHotDealModal *hotDealModal = (GMHotDealModal *)data;
    [self.dealImage setImageWithURL:[NSURL URLWithString:hotDealModal.imageURL] placeholderImage:nil];
    NSLog(@"%@",hotDealModal.imageName);
}
@end
