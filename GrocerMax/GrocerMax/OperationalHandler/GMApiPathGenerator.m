//
//  GMApiPathGenerator.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMApiPathGenerator.h"


//static NSString const *baseUrl = @"http://staging.grocermax.com/api/";
static NSString const *baseUrl = @"http://grocermax.com/api/";
//static NSString const *baseUrl = @"http://staging.grocermax.com/webservice/new_services/";

//static NSString const *baseUrl = @"http://dev.grocermax.com/webservice/new_services/"; 


static NSString const *fbregisterMethodName = @"fbregister";
static NSString const *loginMethodName = @"login";
static NSString const *createuserMethodName = @"createuser";
static NSString const *userDetailMethodName = @"userdetail";
static NSString const *logoutMethodName = @"logout";
static NSString const *forgotPasswordMethodName = @"forgotpassword";
static NSString const *changePasswordMethodName = @"changepassword";
static NSString const *editProfileMethodName = @"editprofile";
static NSString const *addAddressMethodName = @"addaddress";
static NSString const *editAddressMethodName = @"editaddress";
static NSString const *getAddressMethodName = @"getaddress";
static NSString const *deleteAddressMethodName = @"deleteaddress";
static NSString const *getAddressWithTimeSlotMethodName = @"getaddresswithtimeslot";
static NSString const *categoryMethodName = @"category";
static NSString const *productListMethodName = @"productlist";
static NSString const *productDetailMethodName = @"productdetail";
static NSString const *searchMethodName = @"search";
static NSString const *activeOrderMethodName = @"activeorder";
static NSString const *orderHistoryMethodName = @"orderhistory";
static NSString const *getOrderDetailMethodName = @"getorderdetail";
static NSString const *addToCartMethodName = @"addtocart";
static NSString const *cartDetailMethodName = @"cartdetail";
static NSString const *deleteItemMethodName = @"deleteitem";
static NSString const *setStatusMethodName = @"setstatus";
static NSString const *checkoutMethodName = @"checkout";
static NSString const *addCouponMethodName = @"addcoupon";
static NSString const *removeCouponMethodName = @"removecoupon";
static NSString const *successMethodName = @"success";
static NSString const *failMethodName = @"fail";
static NSString const *addToCartGustMethodName = @"addtocartgust";
static NSString const *getLocationMethodName = @"getlocation";
static NSString const *getStateMethodName = @"getstate";
static NSString const *getLocalityMethodName = @"getlocality";
static NSString const *getCategoryMethodName = @"category";
static NSString const *shopbyCategoryMethodName = @"shopbycategory";
static NSString const *shopByDealTypeMethodName = @"shopbydealtype";
static NSString const *dealsbydealtypeMethodName = @"dealsbydealtype";
static NSString const *dealProductListingMethodName = @"dealproductlisting";
static NSString const *offerbydealtypeMethodName = @"offerbydealtype";
static NSString const *productlistallMethodName = @"productlistall";
static NSString const *homeBannerMethodName = @"homebanner";
static NSString const *hashMethodName = @"getmobilehash";


@implementation GMApiPathGenerator

+ (NSString *)fbregisterPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, fbregisterMethodName];
}

+ (NSString *)userLoginPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, loginMethodName];
}

+ (NSString *)userCategoryPath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, getCategoryMethodName];
}

+ (NSString *)createUserPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, createuserMethodName];
}

+ (NSString *)userDetailPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, userDetailMethodName];
}

+ (NSString *)logOutPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, logoutMethodName];
}

+ (NSString *)forgotPasswordPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, forgotPasswordMethodName];
}

+ (NSString *)changePasswordPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, changePasswordMethodName];
}

+ (NSString *)editProfilePath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, editProfileMethodName];
}

+ (NSString *)addAddressPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl,addAddressMethodName];
}

+ (NSString *)editAddressPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, editAddressMethodName];
    
}

+ (NSString *)getAddressPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, getAddressMethodName];
}

+ (NSString *)deleteAddressPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, deleteAddressMethodName];
}

+ (NSString *)getAddressWithTimeSlotPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, getAddressWithTimeSlotMethodName];
}

+ (NSString *)categoryPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, categoryMethodName];
}

+ (NSString *)productListPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, productListMethodName];
}

+ (NSString *)productDetailPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, productDetailMethodName];
}

+ (NSString *)searchPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, searchMethodName];
}

+ (NSString *)activeOrderPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, activeOrderMethodName];
}

+ (NSString *)orderHistoryPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, orderHistoryMethodName];
}

+ (NSString *)getOrderDetailPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, getOrderDetailMethodName];
}

+ (NSString *)addToCartPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, addToCartMethodName];
}

+ (NSString *)cartDetailPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, cartDetailMethodName];
}

+ (NSString *)deleteItemPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, deleteItemMethodName];
}

+ (NSString *)asetStatusPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, setStatusMethodName];
}

+ (NSString *)checkoutPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, checkoutMethodName];
}

+ (NSString *)addCouponPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, addCouponMethodName];
}

+ (NSString *)removeCouponPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, removeCouponMethodName];
}

+ (NSString *)successPath{
    return [NSString stringWithFormat:@"%@%@", baseUrl, successMethodName];
}

+ (NSString *)failPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, failMethodName];
}

+ (NSString *)addTocartGustPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, addToCartGustMethodName];
}

+ (NSString *)getLocationPath{
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, getLocationMethodName];
}

+ (NSString *)getStatePath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, getStateMethodName];
}

+ (NSString *)getLocalityPath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, getLocalityMethodName];
}

+ (NSString *)shopbyCategoryPath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, shopbyCategoryMethodName];
}

+ (NSString *)shopByDealTypePath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, shopByDealTypeMethodName];
}

+ (NSString *)dealsbydealtypePath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, dealsbydealtypeMethodName];
}

+ (NSString *)dealProductListingPath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, dealProductListingMethodName];
}

+ (NSString *)offerByDealTypePath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, offerbydealtypeMethodName];
}

+ (NSString *)productListAllPath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, productlistallMethodName];
}

+ (NSString *)homeBannerPath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, homeBannerMethodName];
}
+ (NSString *)hashGenreatePath {
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, hashMethodName];
}


@end

