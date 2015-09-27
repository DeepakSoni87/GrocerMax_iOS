//
//  GMCartRequestParam.m
//  GrocerMax
//
//  Created by Deepak Soni on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartRequestParam.h"
#import "GMCartModal.h"
#import "GMProductModal.h"
#import "GMCartDetailModal.h"

static GMCartRequestParam *sharedClass;


static NSString * const kProductsKey                        =    @"products";
static NSString * const kProductIdKey                       =    @"productid";
static NSString * const kUpdateIdKey                        =    @"updateid";
static NSString * const kQuoteIdKey                         =    @"quote_id";


static NSString * const kReservationDetailsKey              =    @"reservation_details";
static NSString * const kUserAddressIdKey                   =    @"user_address_id";
static NSString * const kDealIdKey                          =    @"deal_id";

static NSString * const kAddonsKey                          =    @"addons";
static NSString * const kOptionIdKey                        =    @"optionId";
static NSString * const kPriorityKey                        =    @"priority";

static NSString * const kSpecialInstructionKey              =    @"special_instruction";
static NSString * const kPriceIdKey                         =    @"price_id";
static NSString * const kQuantityKey                        =    @"quantity";
static NSString * const kItemIdKey                          =    @"item_id";
static NSString * const kIdKey                              =    @"id";

static NSString * const kItemsKey                           =    @"items";
static NSString * const kTaxKey                             =    @"tax";
static NSString * const kTipPercentKey                      =    @"tip_percent";
static NSString * const kTipTypeKey                         =    @"tiptype";
static NSString * const kOrderType2Key                      =    @"order_type2";
static NSString * const kOrderType1Key                      =    @"order_type1";
static NSString * const kEmailKey                           =    @"email";
static NSString * const kOrderTypeKey                       =    @"order_type";
static NSString * const kOwnInstructionsKey                 =    @"own_instruction";
static NSString * const kDeliveryDateKey                    =    @"delivery_date";
static NSString * const kDeliveryTimeKey                    =    @"delivery_time";
static NSString * const kDeliveryAddressKey                 =    @"delivery_address";
static NSString * const kRestaurantIdKey                    =    @"restaurant_id";
static NSString * const kOrderDetailsKey                    =    @"order_details";

static NSString * const kSaveCardKey                        =    @"save_card";
static NSString * const kBillingZipKey                      =    @"billing_zip";
static NSString * const kCVCKey                             =    @"cvc";
static NSString * const kNameOnCardKey                      =    @"name_on_card";
static NSString * const kExpirydOnKey                       =    @"expired_on";
static NSString * const kExpiryYearKey                      =    @"expiry_year";
static NSString * const kExpiryMonthKey                     =    @"expiry_month";
static NSString * const kCardNoKey                          =    @"card_no";
static NSString * const kCardTypeKey                        =    @"card_type";
static NSString * const kCardIdKey                          =    @"card_id";
static NSString * const kCardDetailsKey                     =    @"card_details";
static NSString * const kCardLast4DigitsKey                 =    @"card_number";
static NSString * const kCardDefaultKey                     =    @"default";
static NSString * const kStatusKey                          =    @"status";
static NSString * const kStripeTokenIdKey                   =    @"stripe_token_id";

static NSString * const kStateCodeKey                       =    @"state_code";
static NSString * const kZipCodeKey                         =    @"zipcode";
static NSString * const kCityKey                            =    @"city";
static NSString * const kPhoneKey                           =    @"phone";
static NSString * const kAddressKey                         =    @"address";
static NSString * const kAptSuiteKey                        =    @"apt_suit";
static NSString * const kLnameKey                           =    @"lname";
static NSString * const kFnameKey                           =    @"fname";
static NSString * const kUserDetailsKey                     =    @"user_details";
static NSString * const kLatitudeKey                        =    @"address_lat";
static NSString * const kLongitudeKey                       =    @"address_lng";

//reservation key
static NSString * const kReservationDateKey                 =    @"date";
static NSString * const kReservationFirstNameKey            =    @"first_name";
static NSString * const kReservationFriendEmailKey          =    @"friend_email";
static NSString * const kReservationInstructionArrKey       =    @"instruction_arr";
static NSString * const kReservationIsPreorderKey           =    @"is_preorder_reservation";
static NSString * const kReservationIsRegisterKey           =    @"is_register";
static NSString * const kReservationLastNameKey             =    @"last_name";
static NSString * const kPointsKey                          =    @"points";
static NSString * const kReservationReceiptKey              =    @"receipt_no";
static NSString * const kReservationPointsKey               =    @"reservation_points";
static NSString * const kReservationSeatsKey                =    @"reserved_seats";
static NSString * const kRestaurantNameKey                  =    @"restaurant_name";
static NSString * const kSendFriendListViewKey              =    @"sendfriendlistview";
static NSString * const kReservationTimeKey                 =    @"time";
static NSString * const kReservationTimeSlotKey             =    @"time_slot";
static NSString * const kUserIdKey                          =    @"user_id";
static NSString * const kUserInstructionKey                 =    @"user_instruction";
static NSString * const kReservationIdKey                   =    @"reservation_id";

@implementation GMCartRequestParam

+ (instancetype)sharedCartRequest {
    
    if(!sharedClass) {
        sharedClass  = [[[self class] alloc] init];
    }
    return sharedClass;
}

- (NSDictionary *)addToCartParameterDictionaryFromCartModal:(GMCartModal *)cartModal {
    
    NSMutableDictionary *cartGuestDictionary = [NSMutableDictionary dictionary];
    return cartGuestDictionary;
}

- (NSDictionary *)addToCartParameterDictionaryFromProductModal:(GMProductModal *)productModal {
    
    NSMutableDictionary *cartGuestDictionary = [NSMutableDictionary dictionary];
   
    NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
    [productDict setObject:[self getValidStringObjectFromString:productModal.productid] forKey:kProductIdKey];
    [productDict setObject:[self getValidStringObjectFromString:productModal.productQuantity] forKey:kQuantityKey];

    NSArray *productArray = [NSArray arrayWithObject:productDict];
    [cartGuestDictionary setObject:[NSString getJsonStringFromObject:productArray] forKey:kProductsKey];
    return cartGuestDictionary;
}

- (NSDictionary *)updateDeleteRequestParameterFromCartModal:(GMCartModal *)cartModal {
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    [requestParam setObject:[self getValidStringObjectFromString:userModal.userId] forKey:kEY_userid];
    [requestParam setObject:[self getValidStringObjectFromString:userModal.quoteId] forKey:kQuoteIdKey];
    [requestParam setObject:[self deletedProductIds:cartModal.deletedProductItems] forKey:kProductIdKey];
    [requestParam setObject:[self jsonStringOfProductItems:cartModal.cartItems] forKey:kUpdateIdKey];
    return requestParam;
}

- (NSDictionary *)updateDeleteRequestParameterFromCartDetailModal:(GMCartDetailModal *)cartModal {
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    [requestParam setObject:[self getValidStringObjectFromString:userModal.userId] forKey:kEY_userid];
    [requestParam setObject:[self getValidStringObjectFromString:userModal.quoteId] forKey:kQuoteIdKey];
    [requestParam setObject:[self deletedProductIds:cartModal.deletedProductItemsArray] forKey:kProductIdKey];
    [requestParam setObject:[self jsonStringOfProductItems:cartModal.productItemsArray] forKey:kUpdateIdKey];
    return requestParam;
}

- (NSString *)jsonStringOfProductItems:(NSMutableArray *)productItems {
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isProductUpdated == YES"];
//    NSArray *updatedProductsArr = [productItems filteredArrayUsingPredicate:pred];
//    if(!updatedProductsArr.count)
//        return @"";
    
    NSMutableArray *productItemsArray = [NSMutableArray array];
    
    for (GMProductModal *productModal in productItems) {
        
        NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
        [productDict setObject:[self getValidStringObjectFromString:productModal.productid] forKey:kProductIdKey];
        [productDict setObject:[self getValidStringObjectFromString:productModal.productQuantity] forKey:kQuantityKey];
        [productItemsArray addObject:productDict];
    }
    return [NSString getJsonStringFromObject:productItemsArray];
}

- (NSString *)deletedProductIds:(NSMutableArray *)deletedProductItems {
    
    if(!deletedProductItems.count)
        return @"";
    
    NSArray *productIdArr = [deletedProductItems valueForKeyPath:@"@distinctUnionOfObjects.productid"];
    NSString *resultedStr = [productIdArr componentsJoinedByString:@","];
    return resultedStr;
}

- (NSDictionary *)cartDetailRequestParameter {
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    [requestParam setObject:[self getValidStringObjectFromString:userModal.userId] forKey:kEY_userid];
    [requestParam setObject:[self getValidStringObjectFromString:userModal.quoteId] forKey:kQuoteIdKey];
    return requestParam;
}

#pragma mark - Helper Methods

- (NSString *)getValidStringObjectFromString:(NSString *)strInput {
    
    if(NSSTRING_HAS_DATA(strInput))
        return strInput;
    else
        return @"";
}
@end
