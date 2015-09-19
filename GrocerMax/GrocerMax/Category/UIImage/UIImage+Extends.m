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

@implementation UIImage (Extends)

#pragma mark - RegistrationVC Image

+ (UIImage *)validInputFieldImage {
    
    return [[UIImage imageNamed:kValidInputImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)inValidInputFieldImage {
    
    return [[UIImage imageNamed:kInValidInputImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
