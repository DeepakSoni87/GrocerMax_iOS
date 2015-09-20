//
//  GMLeftMenuCell.h
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMLeftMenuCell : UITableViewCell

- (void)configureWithCategoryName:(NSString *)categoryName;

+ (CGFloat)cellHeight;
@end
