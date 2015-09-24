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
#import "GMCategoryModal.h"
#import "GMTimeSlotBaseModal.h"
#import "GMProductModal.h"

#import "GMAddressModal.h"

#import "GMRegistrationResponseModal.h"
#import "GMStateBaseModal.h"
#import "GMLocalityBaseModal.h"
#import "GMUserModal.h"
#import "GMBaseOrderHistoryModal.h"
#import "GMProductDetailModal.h"
#import "GMHotDealBaseModal.h"
#import "GMDealCategoryBaseModal.h"
#import "GMProductModal.h"
#import "GMOrderDeatilBaseModal.h"

static NSString * const kFlagKey                    = @"flag";
static NSString * const kCategoryKey                   = @"Category";


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

- (void)login:(NSDictionary *)param withSuccessBlock:(void (^)(GMUserModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator userLoginPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        
        GMUserModal *userModal = [MTLJSONAdapter modelOfClass:[GMUserModal class] fromJSONDictionary:responseObject error:&mtlError];
        
        if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
        else            { if (successBlock) successBlock(userModal); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)fetchCategoriesFromServerWithSuccessBlock:(void (^)(GMCategoryModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator categoryPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        
        GMCategoryModal *rootCategoryModal = [MTLJSONAdapter modelOfClass:[GMCategoryModal class] fromJSONDictionary:responseObject[kCategoryKey] error:&mtlError];
        
        if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
        else            { if (successBlock) successBlock(rootCategoryModal); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)userLogin:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator userLoginPath],[GMRequestParams userLoginParameter:param]];
    
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


- (void)createUser:(NSDictionary *)param withSuccessBlock:(void (^)(GMRegistrationResponseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator createUserPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        
        GMRegistrationResponseModal *registrationResponse = [MTLJSONAdapter modelOfClass:[GMRegistrationResponseModal class] fromJSONDictionary:responseObject error:&mtlError];
        
        if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
        else            { if (successBlock) successBlock(registrationResponse); }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}


- (void)userDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator userDetailPath],[GMRequestParams userDetailParameter:param]];
    
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



+ (void)logOut:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator logOutPath],[GMRequestParams logoutParameter:param]];
    
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

- (void)forgotPassword:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator forgotPasswordPath],[GMRequestParams forgotPasswordParameter:param]];
    
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


- (void)changePassword:(NSDictionary *)param withSuccessBlock:(void(^)(GMRegistrationResponseModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator changePasswordPath],[GMRequestParams changePasswordParameter:param]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            NSError *mtlError = nil;
            
            GMRegistrationResponseModal *registrationResponse = [MTLJSONAdapter modelOfClass:[GMRegistrationResponseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(registrationResponse); }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}


- (void)editProfile:(NSDictionary *)param withSuccessBlock:(void(^)(GMRegistrationResponseModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator editProfilePath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            NSError *mtlError = nil;
            
            GMRegistrationResponseModal *registrationResponse = [MTLJSONAdapter modelOfClass:[GMRegistrationResponseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(registrationResponse); }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}

#pragma mark - Add Address Api

- (void)addAddress:(NSDictionary *)param withSuccessBlock:(void (^)(BOOL))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    //    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator addAddressPath],[GMRequestParams addAndEditAddressParameter:param]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator addAddressPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                if(HAS_KEY(responseObject, @"AddressId"))  {
                    if(successBlock) successBlock(YES);
                }
                else
                    if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : responseObject[kEY_Result]}]);
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}

#pragma mark - Edit Address Api

- (void)editAddress:(NSDictionary *)param withSuccessBlock:(void (^)(BOOL))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator editAddressPath],[GMRequestParams addAndEditAddressParameter:param]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                if(successBlock) successBlock(YES);
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)getAddress:(NSDictionary *)param withSuccessBlock:(void(^)(GMAddressModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getAddressPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            NSError *mtlError = nil;
            
            GMAddressModal *addressModal = [MTLJSONAdapter modelOfClass:[GMAddressModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }

            else            { if (successBlock) successBlock(addressModal);}
                

            
            
            
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)deleteAddress:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator deleteAddressPath],[GMRequestParams deleteAddressParameter:param]];
    
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


- (void)getAddressWithTimeSlot:(NSDictionary *)param withSuccessBlock:(void (^)(GMTimeSlotBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator getAddressWithTimeSlotPath],[GMRequestParams getAddressWithTimeSlotParameter:param]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            NSError *mtlError = nil;
            
            GMTimeSlotBaseModal *timeSlotBaseModal = [MTLJSONAdapter modelOfClass:[GMTimeSlotBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(timeSlotBaseModal); }
            
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)category:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator categoryPath],[GMRequestParams categoryParameter:param]];
    
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


- (void)productList:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator productListPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                
                NSError *mtlError = nil;
                
                GMProductListingBaseModal *productListingModal = [MTLJSONAdapter modelOfClass:[GMProductListingBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(productListingModal); }
                
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)productDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator productDetailPath],[GMRequestParams productDetailParameter:param]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSError *mtlError = nil;
                
                GMProductDetailBaseModal *productListingModal = [MTLJSONAdapter modelOfClass:[GMProductDetailBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(productListingModal); }
                

            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)search:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator searchPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSError *mtlError = nil;
                
                GMProductListingBaseModal *productListingModal = [MTLJSONAdapter modelOfClass:[GMProductListingBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(productListingModal); }
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)activeOrder:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator activeOrderPath],[GMRequestParams activeOrderOrOrderHistryParameter:param]];
    
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


- (void)orderHistory:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator orderHistoryPath],[GMRequestParams activeOrderOrOrderHistryParameter:param]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
//
            
            NSError *mtlError = nil;
            
            GMBaseOrderHistoryModal *baseOrderHistoryModal = [MTLJSONAdapter modelOfClass:[GMBaseOrderHistoryModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(baseOrderHistoryModal.orderHistoryArray);}
            
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)getOrderDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getOrderDetailPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                GMOrderDeatilBaseModal *orderDeatilBaseModal = [[GMOrderDeatilBaseModal alloc]initWithDictionary:responseObject];
                
                if(successBlock) successBlock(orderDeatilBaseModal);
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)addToCart:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator addToCartPath],[GMRequestParams addToCartParameter:param]];
    
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


- (void)cartDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator cartDetailPath],[GMRequestParams cartDetailParameter:param]];
    
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


- (void)deleteItem:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator deleteItemPath],[GMRequestParams deleteItemParameter:param]];
    
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


- (void)asetStatus:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator asetStatusPath],[GMRequestParams setStatusParameter:param]];
    
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


- (void)checkout:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator checkoutPath],[GMRequestParams checkoutParameter:param]];
    
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


- (void)addCoupon:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator addCouponPath],[GMRequestParams addOrRemoveCouponParameter:param]];
    
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


- (void)removeCoupon:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator removeCouponPath],[GMRequestParams addOrRemoveCouponParameter:param]];
    
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


- (void)success:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator successPath],[GMRequestParams paymentSuccessOrfailParameter:param]];
    
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


- (void)fail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator failPath],[GMRequestParams paymentSuccessOrfailParameter:param]];
    
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


- (void)addTocartGust:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator addTocartGustPath],[GMRequestParams addToCartGustParameter:param]];
    
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


- (void)getLocation:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getLocationPath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSLog(@"URL = %@",operation.request.URL.absoluteString);
            NSLog(@"RESPONSE = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil] encoding:NSStringEncodingConversionExternalRepresentation]);
            
            NSError *mtlError = nil;
            
            GMStateBaseModal *stateBaseModal = [MTLJSONAdapter modelOfClass:[GMStateBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(stateBaseModal);
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

#pragma mark - State Api

- (void)getStateWithSuccessBlock:(void (^)(GMStateBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getStatePath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        
        GMStateBaseModal *stateBaseModal = [MTLJSONAdapter modelOfClass:[GMStateBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
        
        if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
        else            { if (successBlock) successBlock(stateBaseModal); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

#pragma mark - Locality Api

- (void)getLocalitiesOfCity:(NSString *)cityId withSuccessBlock:(void (^)(GMLocalityBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    //    http://dev.grocermax.com/webservice/new_services/getlocality?cityid=1
    NSString *urlStr = [NSString stringWithFormat:@"%@?cityid=%@", [GMApiPathGenerator getLocalityPath], cityId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        
        GMLocalityBaseModal *localityBaseModal = [MTLJSONAdapter modelOfClass:[GMLocalityBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
        
        if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
        else            { if (successBlock) successBlock(localityBaseModal); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)shopbyCategory:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator shopbyCategoryPath],[GMRequestParams shopbyCategoryParameter:param]];
    
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

- (void)shopByDealType:(NSDictionary *)param withSuccessBlock:(void (^)(GMHotDealBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator shopByDealTypePath]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSError *mtlError = nil;
            
            GMHotDealBaseModal *hotDealBaseModal = [MTLJSONAdapter modelOfClass:[GMHotDealBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(hotDealBaseModal); }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)dealsByDealType:(NSDictionary *)param withSuccessBlock:(void (^)(GMDealCategoryBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator dealsbydealtypePath],[GMRequestParams dealsByDealTypeParameter:param]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSError *mtlError = nil;
            
            GMDealCategoryBaseModal *dealCategoryBaseModal = [MTLJSONAdapter modelOfClass:[GMDealCategoryBaseModal class] fromJSONDictionary:responseObject[@"dealcategory"] error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(dealCategoryBaseModal); }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)dealProductListing:(NSDictionary *)param withSuccessBlock:(void (^)(NSArray *))successBlock failureBlock:(void (^)(NSError *))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator dealProductListingPath],[GMRequestParams dealProductListingParameter:param]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSError *mtlError = nil;
            
            GMProductListingBaseModal *productListBaseModal = [MTLJSONAdapter modelOfClass:[GMProductListingBaseModal class] fromJSONDictionary:responseObject[@"dealcategory"] error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(productListBaseModal.productsListArray); }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


@end
