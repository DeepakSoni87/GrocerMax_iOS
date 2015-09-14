//
//  GMRequestParams.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRequestParams.h"

@implementation GMRequestParams

static GMRequestParams *sharedClass;

+ (instancetype)sharedClass {
    
    if(!sharedClass) {
        sharedClass  = [[[self class] alloc] init];
    }
    return sharedClass;
}

#pragma mark -Create Customer

- (NSMutableDictionary *)getUserLoginRequestParamsWith:(NSString *)userName password:(NSString *)password{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [paramDict setObject:userName forKey:kEY_uemail];
    [paramDict setObject:password forKey:kEY_password];
    
    return paramDict;
}

@end
