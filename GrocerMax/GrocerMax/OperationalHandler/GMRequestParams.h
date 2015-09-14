//
//  GMRequestParams.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMRequestParams : NSObject

+ (instancetype)sharedClass;

#pragma mark - Login Req Param

- (NSMutableDictionary *)getUserLoginRequestParamsWith:(NSString *)userName password:(NSString *)password;

@end
