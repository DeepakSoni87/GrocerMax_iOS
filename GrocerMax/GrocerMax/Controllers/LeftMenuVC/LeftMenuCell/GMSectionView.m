//
//  GMSectionView.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSectionView.h"

@implementation GMSectionView

- (void)configureWithSectionDisplayName:(NSString *)displayName {
    
    [self.sectionNameLabel setText:displayName];
}

+ (CGFloat)sectionHeight {
    
    return 40.0f;
}
@end
