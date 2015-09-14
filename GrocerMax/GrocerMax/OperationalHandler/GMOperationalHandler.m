//
//  GMOperationalHandler.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOperationalHandler.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

#import "GMApiPathGenerator.h"

static GMOperationalHandler *sharedHandler;

@implementation GMOperationalHandler


#pragma mark - SharedInstance Method

+ (instancetype)handler {
    
    if(!sharedHandler) {
        sharedHandler  = [[[self class] alloc] init];
    }
    return sharedHandler;
}

#pragma mark - Login

/**
 * Function for Check User Login
 * @param GET Var uemail, password
 * @output JSON string
 * mandatory variable  uemail, password
 */

//http://dev.grocermax.com/webservice/new_services/login?uemail=kundan@sakshay.in&password=sakshay

- (void)login:(NSDictionary *)param withSuccessBlock:(void(^)(id loggedInUser))successBlock failureBlock:(void(^)(NSError * error))failureBlock {

    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator userLoginPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                if(successBlock) successBlock(responseObject);
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


@end
