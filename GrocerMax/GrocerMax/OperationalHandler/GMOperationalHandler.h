//
//  GMOperationalHandler.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GMOperationalHandler : NSObject

+ (instancetype)handler;

#pragma mark - Login

- (void)login:(NSDictionary *)param withSuccessBlock:(void(^)(id loggedInUser))successBlock failureBlock:(void(^)(NSError * error))failureBlock;


@end
