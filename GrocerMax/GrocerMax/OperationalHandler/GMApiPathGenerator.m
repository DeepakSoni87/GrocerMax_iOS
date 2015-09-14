//
//  GMApiPathGenerator.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMApiPathGenerator.h"

static NSString const *baseUrl = @"http://dev.grocermax.com/webservice/new_services/";

@implementation GMApiPathGenerator

+ (NSString *)userLoginPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, @"login"];
}

@end
