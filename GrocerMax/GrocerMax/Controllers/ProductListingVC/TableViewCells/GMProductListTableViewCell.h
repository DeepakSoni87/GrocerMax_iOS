//
//  GMProductListTableViewCell.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMProductModal;

@interface GMProductListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet GMButton *addBtn;

- (void)configureCellWithProductModal:(GMProductModal *)productModal;

+ (CGFloat)cellHeight;
@end
