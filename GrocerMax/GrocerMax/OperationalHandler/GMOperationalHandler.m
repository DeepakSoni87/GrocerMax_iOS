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
#import "GMOffersByDealTypeModal.h"
#import "GMDealCategoryBaseModal.h"
#import "GMProductModal.h"
#import "GMOrderDeatilBaseModal.h"
#import "GMCartDetailModal.h"
#import "GMSearchResultModal.h"
#import "GMGenralModal.h"
#import "GMCoupanCartDetail.h"
#import "GMHomeBannerModal.h"
#import "GMHomeModal.h"

static NSString * const kFlagKey                    = @"flag";
static NSString * const kCategoryKey                   = @"Category";
static NSString * const kQuoteId                    = @"QuoteId";
static NSString * const kResultKey                    = @"Result";


static GMOperationalHandler *sharedHandler;

@implementation GMOperationalHandler


#pragma mark - SharedInstance Method

+ (instancetype)handler {
    
    if(!sharedHandler) {
        sharedHandler  = [[[self class] alloc] init];
    }
    return sharedHandler;
}

- (AFHTTPRequestOperationManager *)operationManager {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return manager;
}

- (NSError *)getSuccessResponse:(NSDictionary *)responseObject {
    
    NSString *flag = responseObject[kFlagKey];
    if(flag.boolValue)
        return nil;
    else
        return [NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : responseObject[kResultKey]}];
}

#pragma mark - Login

/**
 * Function for Check User Login
 * @param GET Var uemail, password
 * @output JSON string
 * mandatory variable  uemail, password
 */

//http://dev.grocermax.com/webservice/new_services/login?uemail=kundan@sakshay.in&password=sakshay

- (void)fgLoginRequestParamsWith:(NSDictionary *)param withSuccessBlock:(void(^)(id data))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator fbregisterPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:[GMRequestParams getUserFBLoginRequestParamsWith:param] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            } else {
                if(failureBlock) failureBlock(error);
            }
            
            
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)login:(NSDictionary *)param withSuccessBlock:(void (^)(GMUserModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator userLoginPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        NSError *error = [self getSuccessResponse:responseObject];
        if(!error) {
            
            GMUserModal *userModal = [MTLJSONAdapter modelOfClass:[GMUserModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(userModal); }
        }
        else
            if(failureBlock) failureBlock(error);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)fetchCategoriesFromServerWithSuccessBlock:(void (^)(GMCategoryModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator categoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        NSError *error = [self getSuccessResponse:responseObject];
        if(!error) {
            NSString *baseUrl = responseObject[@"urlImg"];
            if(NSSTRING_HAS_DATA(baseUrl))
                [[GMSharedClass sharedClass] setCategoryImageBaseUrl:baseUrl];
            
            NSDictionary *categoryDict = responseObject[kCategoryKey];
            GMCategoryModal *rootCategoryModal = [MTLJSONAdapter modelOfClass:[GMCategoryModal class] fromJSONDictionary:categoryDict error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(rootCategoryModal); }
        } else {
            if(failureBlock) failureBlock(error);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)userLogin:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator userLoginPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = [self getSuccessResponse:responseObject];
        if(!error) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        } else {
            if(failureBlock) failureBlock(error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}


- (void)createUser:(NSDictionary *)param withSuccessBlock:(void (^)(GMRegistrationResponseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator createUserPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        NSError *error = [self getSuccessResponse:responseObject];
        if(!error) {
            GMRegistrationResponseModal *registrationResponse = [MTLJSONAdapter modelOfClass:[GMRegistrationResponseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(registrationResponse); }
        } else {
            if(failureBlock) failureBlock(error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}


- (void)userDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator userDetailPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            } else {
                if(failureBlock) failureBlock(error);
            }
            
            
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}



- (void)logOut:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator logOutPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
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
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator forgotPasswordPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
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
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator changePasswordPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator editAddressPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSError *mtlError = nil;
            
            GMAddressModal *addressModal = [MTLJSONAdapter modelOfClass:[GMAddressModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);}
            else            { if (successBlock) successBlock(addressModal);}
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)deleteAddress:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator deleteAddressPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getAddressWithTimeSlotPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            NSError *mtlError = nil;
            
            GMTimeSlotBaseModal *timeSlotBaseModal = [MTLJSONAdapter modelOfClass:[GMTimeSlotBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            for (GMAddressModalData *addressModal in timeSlotBaseModal.addressesArray) {
                [addressModal updateHouseNoLocalityAndLandmarkWithStreet:addressModal.street];
            }
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(timeSlotBaseModal); }
            
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
        responseObject = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)category:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator categoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator productDetailPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSError *mtlError = nil;
                
                
                GMSearchResultModal *productListingModal = [MTLJSONAdapter modelOfClass:[GMSearchResultModal class] fromJSONDictionary:responseObject error:&mtlError];
                
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator activeOrderPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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


- (void)orderHistory:(NSDictionary *)param withSuccessBlock:(void(^)(NSArray *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator orderHistoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator addToCartPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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


- (void)cartDetail:(NSDictionary *)param withSuccessBlock:(void (^)(GMCartDetailModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator cartDetailPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                GMCartDetailModal *cartDetailModal = [[GMCartDetailModal alloc] initWithCartDetailDictionary:responseObject[@"CartDetail"]];
                if(successBlock) successBlock(cartDetailModal);
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)deleteItem:(NSDictionary *)param withSuccessBlock:(void (^)(GMCartDetailModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator deleteItemPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                GMCartDetailModal *cartDetailModal = [[GMCartDetailModal alloc] initWithCartDetailDictionary:responseObject[@"CartDetail"]];
                if(successBlock) successBlock(cartDetailModal);
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)asetStatus:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator asetStatusPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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


- (void)checkout:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator checkoutPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSError *mtlError = nil;
                GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(genralModal); }
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)addCoupon:(NSDictionary *)param withSuccessBlock:(void(^)(GMCoupanCartDetail *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator addCouponPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                if(responseObject[@"flag"] && [responseObject[@"flag"] intValue] == 1) {
                    GMCoupanCartDetail *coupanCartDetail = [[GMCoupanCartDetail alloc] initWithCartDetailDictionary:responseObject];
                    if(successBlock) successBlock(coupanCartDetail);            } else {
                        if(failureBlock) failureBlock(nil);
                    }
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)removeCoupon:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator removeCouponPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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


- (void)success:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal* responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator successPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSError *mtlError = nil;
                
                GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(genralModal); }
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)fail:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator failPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSError *mtlError = nil;
                
                GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(genralModal); }
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)addTocartGust:(NSDictionary *)param withSuccessBlock:(void (^)(NSString *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator addTocartGustPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSString *quoteId;
                if(HAS_KEY(responseObject, kQuoteId)) {
                    
                    quoteId = responseObject[kQuoteId];
                    GMUserModal *userModal = [GMUserModal loggedInUser];
                    if(quoteId && !userModal) {
                        
                        userModal = [[GMUserModal alloc] init];
                        [userModal setQuoteId:quoteId];
                        [userModal persistUser];
                    } else {
                        if(userModal && !NSSTRING_HAS_DATA(userModal.quoteId)) {
                            [userModal setQuoteId:quoteId];
                            [userModal persistUser];
                        }
                    }
                }
                if(successBlock) successBlock(quoteId);
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        
        GMLocalityBaseModal *localityBaseModal = [MTLJSONAdapter modelOfClass:[GMLocalityBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
        
        if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
        else            { if (successBlock) successBlock(localityBaseModal); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)shopbyCategory:(NSDictionary *)param withSuccessBlock:(void(^)(id catArray))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator shopbyCategoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                if(successBlock) successBlock(responseObject[kEY_category]);
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
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator dealsbydealtypePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
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

- (void)dealProductListing:(NSDictionary *)param withSuccessBlock:(void (^)(id data))successBlock failureBlock:(void (^)(NSError *))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator dealProductListingPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            NSError *mtlError = nil;
            
            GMProductListingBaseModal *productListBaseModal = [MTLJSONAdapter modelOfClass:[GMProductListingBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(productListBaseModal); }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)getOfferByDeal:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator offerByDealTypePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSError *mtlError = nil;
                
                GMOffersByDealTypeBaseModal *offersByDealTypeBaseModal = [MTLJSONAdapter modelOfClass:[GMOffersByDealTypeBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(offersByDealTypeBaseModal); }
                
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)productListAll:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator productListAllPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                GMProductListingBaseModal *productListingBaseModal = [[GMProductListingBaseModal alloc] initWithResponseDict:responseObject];
                if (successBlock) successBlock(productListingBaseModal);
                
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)homeBannerList:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator homeBannerPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSError *mtlError = nil;
                
                GMHomeBannerBaseModal *bannerBaseModal = [MTLJSONAdapter modelOfClass:[GMHomeBannerBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(bannerBaseModal); }
                
            }
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)getMobileHash:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator hashGenreatePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            if([responseObject objectForKey:@"Result"]) {
                if (successBlock) successBlock([responseObject objectForKey:@"Result"]);
            } else {
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
            
            
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)deviceToken:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator sendDeviceToken]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                
                if (successBlock) successBlock(responseObject);
            }
                
        }else {
            
            if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)fetchHomeScreenDataFromServerWithSuccessBlock:(void (^)(GMHomeModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator homePagePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *mtlError = nil;
        NSError *error = [self getSuccessResponse:responseObject];
        if(!error) {
            
            GMHomeModal *homeModal = [MTLJSONAdapter modelOfClass:[GMHomeModal class] fromJSONDictionary:responseObject error:&mtlError];
            if(NSSTRING_HAS_DATA(homeModal.imageUrl))
                [[GMSharedClass sharedClass] setCategoryImageBaseUrl:homeModal.imageUrl];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(homeModal); }
        } else {
            if(failureBlock) failureBlock(error);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}
@end
