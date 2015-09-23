//
//  GMApiPathGenerator.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMApiPathGenerator : NSObject

+ (NSString *)userLoginPath;


/**
 * Function for Check User Login
 * @param
 * @Return loginpath
 **/
+ (NSString *)userLoginPath;

/**
 * Function for Create New User
 * @param
 * @Return createUserPath
 **/
+ (NSString *)createUserPath;

/**
 * Function for Get User Details
 * @param
 * @Return userDetailPath
 **/
+ (NSString *)userDetailPath;


/**
 * Function for User Logout
 * @param
 * @Return logOutPath
 **/
+ (NSString *)logOutPath;

/**
 * Function for User Forgot Password
 * @param
 * @Return forgotPasswordPath
 **/
+ (NSString *)forgotPasswordPath;

/**
 * Function for User Change Password
 * @param
 * @Return changePasswordPath
 **/
+ (NSString *)changePasswordPath;

/**
 * Function for User Edit Profile
 * @param
 * @Return editProfilePath
 **/
+ (NSString *)editProfilePath;

/**
 * Function for Add User Address
 * @param
 * @Return addAddressPath
 **/
+ (NSString *)addAddressPath;

/**
 * Function for Edit User Address
 * @param
 * @Return editAddressPath
 **/
+ (NSString *)editAddressPath;

/**
 * Function for Get All User Address
 * @param
 * @Return getAddressPath
 **/
+ (NSString *)getAddressPath;

/**
 * Function for Delete User Address
 * @param
 * @Return deleteAddressPath
 **/
+ (NSString *)deleteAddressPath;

/**
 * Function for Get User Address With Available Date / Time Slot
 * @param
 * @Return getAddressWithTimeSlotPath
 **/
+ (NSString *)getAddressWithTimeSlotPath;

/**
 * Function for Category Listing
 * @param
 * @Return categoryPath
 **/
+ (NSString *)categoryPath;

/**
 * Function for Product Listing
 * @param
 * @Return productListPath
 **/
+ (NSString *)productListPath;

/**
 * Function for Product Detail
 * @param
 * @Return productDetailPath
 **/
+ (NSString *)productDetailPath;

/**
 * Function for Search
 * @param
 * @Return searchPath
 **/
+ (NSString *)searchPath;

/**
 * Function for Get User Active Orders (Pending,Processing)
 * @param
 * @Return activeOrderPath
 **/
+ (NSString *)activeOrderPath;

/**
 * Function for Get User All Orders History
 * @param
 * @Return orderHistoryPath
 **/
+ (NSString *)orderHistoryPath;

/**
 * Function for Get Orders Detail
 * @param
 * @Return getOrderDetailPath
 **/
+ (NSString *)getOrderDetailPath;

/**
 * Function for Add to Cart
 * @param
 * @Return addToCartPath
 **/
+ (NSString *)addToCartPath;

/**
 * Function for Get Cart Detail
 * @param
 * @Return cartDetailPath
 **/
+ (NSString *)cartDetailPath;

/**
 * Function for Delete and Update Item from Cart
 * @param
 * @Return deleteItemPath
 **/
+ (NSString *)deleteItemPath;

/**
 * Function for Set Order Status
 * @param
 * @Return asetStatusPath
 **/
+ (NSString *)asetStatusPath;

/**
 * Function for Final Order Checkout
 * @param
 * @Return checkoutPath
 **/
+ (NSString *)checkoutPath;

/**
 * Function for Apply Coupon on cart
 * @param
 * @Return addCouponPath
 **/
+ (NSString *)addCouponPath;

/**
 * Function for Remove Coupon on cart
 * @param
 * @Return removeCouponPath
 **/
+ (NSString *)removeCouponPath;

/**
 * Function for Successful Payment
 * @param
 * @Return successPath
 **/
+ (NSString *)successPath;

/**
 * Function for Fail Payment
 * @param
 * @Return failPath
 **/
+ (NSString *)failPath;

/**
 * Function for Add to Cart
 * @param
 * @Return addTocartGustPath
 **/
+ (NSString *)addTocartGustPath;

/**
 * Function for Location
 * @param
 * @Return getLocationPath
 **/
+ (NSString *)getLocationPath;

+ (NSString *)getStatePath;

+ (NSString *)getLocalityPath;

+ (NSString *)userCategoryPath;


/**
 * Function for shop by Catalog Listing
 * @param GET Var page, cat_id
 * @output shopbyCategoryPath
 */

+ (NSString *)shopbyCategoryPath;

/**
 * Function for shop by Catalog Listing
 * @param GET Var page, cat_id
 * @output shopByDealTypePath
 */

+ (NSString *)shopByDealTypePath;

/**
 * Function for Deals by deal type  Listing
 * @param GET Var page, deal_type_id
 * @output dealsbydealtypePath
 */

+ (NSString *)dealsbydealtypePath;

/**
 * Function for Deal Catalog Listing
 * @param GET Var page, deal_id
 * @output dealProductListingPath
 */

+ (NSString *)dealProductListingPath;

@end
