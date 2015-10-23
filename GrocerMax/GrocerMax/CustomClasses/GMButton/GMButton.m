//
//  GMButton.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMButton.h"

@implementation GMButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setAttributedTextWith:self.titleLabel.text];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        [self setAttributedTextWith:self.titleLabel.text];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    [self setAttributedTextWith:title];
}

- (void)setAttributedTextWith:(NSString *)title {
    
    if(!title)
        return;
    
    if([title isEqualToString:@"ADD"])
        return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [title length])];
    [self.titleLabel setAttributedText:attributedString];
}

@end
