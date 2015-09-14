//
//  UIColor+Additions.m
//  Ruplee
//
//  Created by deepak.soni on 2/5/15.
//  Copyright (c) 2015 deepak.soni. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (instancetype)colorWithRGBValue:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    
    return [[self alloc] initWithRGBValue:red green:green blue:blue];
}

- (instancetype)initWithRGBValue:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    
    CGFloat r = red / 255.0f;
    CGFloat g = green / 255.0f;
    CGFloat b = blue / 255.0f;
    return [self initWithRed:r green:g blue:b alpha:1.0f];
}
@end
