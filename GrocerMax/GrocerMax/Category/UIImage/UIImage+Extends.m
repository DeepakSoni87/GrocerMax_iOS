//
//  UIImage+Extends.m
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "UIImage+Extends.h"

static NSString * const kValidInputImage                 = @"check";
static NSString * const kInValidInputImage               = @"error";
static NSString * const kForwardArrowImage               = @"forward_caret";
static NSString * const kSearch_iconImage                = @"search_icon";
static NSString * const kLogoImage                       = @"logo";
static NSString * const kmenuBtnImage                    = @"menuBtn";


@implementation UIImage (Extends)

#pragma mark - RegistrationVC Image

+ (UIImage *)validInputFieldImage {
    
    return [[UIImage imageNamed:kValidInputImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)inValidInputFieldImage {
    
    return [[UIImage imageNamed:kInValidInputImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)forwardArrowImage {
    
    return [[UIImage imageNamed:kForwardArrowImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)searchIconImage{
    
    return [[UIImage imageNamed:kSearch_iconImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)logoImage{
    
    return [[UIImage imageNamed:kLogoImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)menuBtnImage{
    
    return [[UIImage imageNamed:kmenuBtnImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
