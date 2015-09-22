//
//  GMProductListTableViewCell.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMProductListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath;

@end
