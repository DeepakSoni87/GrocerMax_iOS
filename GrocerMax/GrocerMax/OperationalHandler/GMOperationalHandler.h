//
//  GMOperationalHandler.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//


#import <Foundation/Foundation.h>

@class GMCategoryModal;
@class GMTimeSlotBaseModal;
@class GMAddressModal;

@class GMRegistrationResponseModal;
@class GMStateBaseModal;
@class GMLocalityBaseModal;
@class GMUserModal;
@class GMBaseOrderHistoryModal;
@class GMHotDealBaseModal;
@class GMDealCategoryBaseModal;
@class GMCartDetailModal;
@class GMGenralModal;
@class GMCoupanCartDetail;
@class GMHomeModal;

@interface GMOperationalHandler : NSObject

+ (instancetype)handler;

#pragma mark - Login

- (void)fgLoginRequestParamsWith:(NSDictionary *)param withSuccessBlock:(void(^)(id data))successBlock failureBlock:(void(^)(NSError * error))failureBlock;


- (void)fetchCategoriesFromServerWithSuccessBlock:(void(^)(GMCategoryModal *rootCategoryModal))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Check User Login
 * @param
 **/
- (void)login:(NSDictionary *)param withSuccessBlock:(void (^)(GMUserModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock ;

/**
 * Function for Create New User
 * @param
 **/
- (void)createUser:(NSDictionary *)param withSuccessBlock:(void(^)(GMRegistrationResponseModal *registrationResponse))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get User Details
 * @param
 **/
- (void)userDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;


/**
 * Function for User Logout
 * @param
 **/
- (void)logOut:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for User Forgot Password
 * @param
 **/
- (void)forgotPassword:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for User Change Password
 * @param
 **/
- (void)changePassword:(NSDictionary *)param withSuccessBlock:(void(^)(GMRegistrationResponseModal * responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for User Edit Profile
 * @param
 **/
- (void)editProfile:(NSDictionary *)param withSuccessBlock:(void(^)(GMRegistrationResponseModal * responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Add User Address
 * @param
 **/
- (void)addAddress:(NSDictionary *)param withSuccessBlock:(void(^)(BOOL success))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Edit User Address
 * @param
 **/
- (void)editAddress:(NSDictionary *)param withSuccessBlock:(void(^)(BOOL success))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get All User Address
 * @param
 **/
- (void)getAddress:(NSDictionary *)param withSuccessBlock:(void(^)(GMAddressModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Delete User Address
 * @param
 **/
- (void)deleteAddress:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get User Address With Available Date / Time Slot
 * @param
 **/
- (void)getAddressWithTimeSlot:(NSDictionary *)param withSuccessBlock:(void(^)(GMTimeSlotBaseModal *timeSlotBaseModal))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Category Listing
 * @param
 **/
- (void)category:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Product Listing
 * @param
 **/
- (void)productList:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Product Detail
 * @param
 **/
- (void)productDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Search
 * @param
 **/
- (void)search:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get User Active Orders (Pending,Processing)
 * @param
 **/
- (void)activeOrder:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get User All Orders History
 * @param
 **/
- (void)orderHistory:(NSDictionary *)param withSuccessBlock:(void(^)(NSArray *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get Orders Detail
 * @param
 **/
- (void)getOrderDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Add to Cart
 * @param
 **/
- (void)addToCart:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get Cart Detail
 * @param
 **/
- (void)cartDetail:(NSDictionary *)param withSuccessBlock:(void(^)(GMCartDetailModal *cartDetailModal))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Delete and Update Item from Cart
 * @param
 **/
- (void)deleteItem:(NSDictionary *)param withSuccessBlock:(void(^)(GMCartDetailModal *cartDetailModal))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Set Order Status
 * @param
 **/
- (void)asetStatus:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Final Order Checkout
 * @param
 **/
- (void)checkout:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Apply Coupon on cart
 * @param
 **/
- (void)addCoupon:(NSDictionary *)param withSuccessBlock:(void(^)(GMCoupanCartDetail *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Remove Coupon on cart
 * @param
 **/
- (void)removeCoupon:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Successful Payment
 * @param
 **/
- (void)success:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Fail Payment
 * @param
 **/
- (void)fail:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Add to Cart
 * @param
 **/
- (void)addTocartGust:(NSDictionary *)param withSuccessBlock:(void(^)(NSString *quoteId))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Location
 * @param
 **/
- (void)getLocation:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get State
 * @param
 **/
- (void)getStateWithSuccessBlock:(void(^)(GMStateBaseModal *stateBaseModal))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Get Locality
 * @param
 **/
- (void)getLocalitiesOfCity:(NSString *)cityId withSuccessBlock:(void(^)(GMLocalityBaseModal *localityBaseModal))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for shopbyCategory
 * @param
 **/
- (void)shopbyCategory:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for shopByDealType
 * @param
 **/
- (void)shopByDealType:(NSDictionary *)param withSuccessBlock:(void(^)(GMHotDealBaseModal *hotDealBaseModal))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for dealsByDealType
 * @param
 **/
- (void)dealsByDealType:(NSDictionary *)param withSuccessBlock:(void(^)(GMDealCategoryBaseModal *dealCategoryBaseModal))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for dealProductListing
 * @param
 **/
- (void)dealProductListing:(NSDictionary *)param withSuccessBlock:(void(^)(id data))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for dealProductListing
 * @param
 **/
- (void)getOfferByDeal:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for product listing for all product
 * @param
 **/
- (void)productListAll:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for Home Banner
 * @param
 **/
- (void)homeBannerList:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function for PayU hash gentre
 * @param
 **/
- (void)getMobileHash:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

/**
 * Function to send device token on server
 * @param
 **/
- (void)deviceToken:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock;

- (void)fetchHomeScreenDataFromServerWithSuccessBlock:(void (^)(GMHomeModal *homeModal))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
@end
