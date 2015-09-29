//
//  GMConstants.h
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#define GrocerMax_GMConstants_h

#ifdef DEBUG
#define DLOG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLOG(xx, ...)  ((void)0)
#endif

#define SCREEN_SIZE    CGSizeMake([[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height)

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define HAS_KEY(_x,_y) (([_x objectForKey:_y]) && !([[_x objectForKey:_y] isEqual:[NSNull null]]))

#define NSSTRING_HAS_DATA(_x) (((_x) != nil) && ( [(_x) length] > 0 ))

#define HAS_DATA(_x,_y) (([_x objectForKey:_y]) && !([[_x objectForKey:_y] isEqual:[NSNull null]]) && ([[_x objectForKey:_y] length] > 0))

#define GMLocalizedString(key) [[NSBundle mainBundle]localizedStringForKey:(key) value:@"" table:@"Messages"]

#define APP_DELEGATE (AppDelegate *)([[UIApplication sharedApplication] delegate])

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define grocerMaxDirectory [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


// fonts

#define FONT_REGULAR(s) [UIFont fontWithName:@"HelveticaNeue-Regular" size:s]
#define FONT_BOLD(s)    [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define FONT_LIGHT(s)   [UIFont fontWithName:@"HelveticaNeue-Light" size:s]


//Resoponce Key
#define kEY_Result                        @"Result"
#define kEY_flag                          @"flag"

// Key : Login

#define kEY_uemail                        @"uemail"
#define kEY_password                      @"password"
#define kEY_email                         @"email"
#define kEY_oldPassword                   @"old_password"



//key : Registration

#define kEY_fname                          @"fname"
#define kEY_lname                          @"lname"
#define kEY_number                         @"number"
#define kEY_otp                            @"otp"

// Key : fbRegister

#define kEY_QuoteId                         @"QuoteId"
#define kEY_Result                          @"Result"
#define kEY_TotalItem                       @"TotalItem"
#define kEY_UserID                          @"UserID"
#define kEY_flag                            @"flag"




//key : userdetail

#define kEY_userid                         @"userid"

//key : changepassword

#define kEY_old_password                   @"old_password"

//key : addaddress

#define kEY_addressid                      @"addressid"
#define kEY_addressline1                   @"addressline1"
#define kEY_addressline2                   @"addressline2"
#define kEY_addressline3                   @"addressline3"
#define kEY_city                           @"city"
#define kEY_state                          @"state"
#define kEY_pin                            @"pin"
#define kEY_postcode                       @"postcode"

#define kEY_state                          @"state"
#define kEY_countrycode                    @"countrycode"
#define kEY_phone                          @"phone"
#define kEY_phone                          @"phone"
#define kEY_telephone                      @"telephone"

#define kEY_default_billing                @"default_billing"
#define kEY_default_shipping               @"default_shipping"
#define kEY_cityId                         @"cityid"

//key : category

#define kEY_parentid                       @"parentid"
#define kEY_cat_id                         @"cat_id"
#define kEY_pro_id                         @"pro_id"
#define kEY_page                           @"page"

//key : search

#define kEY_keyword                        @"keyword"

//key : getorderdetail

#define kEY_orderid                        @"orderid"

//key : addtocart

#define kEY_cus_id                         @"cus_id"
#define kEY_quote_id                       @"quote_id"
#define kEY_products                       @"products"

//key : deleteitem

#define kEY_productid                      @"productid"
#define kEY_updateid                       @"updateid"
#define kEY_products                       @"products"

//key : setstatus

#define kEY_orderid                        @"orderid"
#define kEY_status                         @"status"
#define kEY_comment                        @"comment"

//key : checkout

#define kEY_shipping                       @"shipping"
#define kEY_billing                        @"billing"
#define kEY_lot                            @"lot"
#define kEY_payment_method                 @"payment_method"
#define kEY_shipping_method                @"shipping_method"
#define kEY_timeslot                       @"timeslot"
#define kEY_date                           @"date"

//key : addcoupon

#define kEY_couponcode                     @"couponcode"
#define kEY_products                       @"products"
#define kEY_quantity                       @"quantity"

// Key : Deals

#define kEY_deal_type_id                  @"deal_type_id"
#define kEY_deal_id                       @"deal_id"

// Key : Categoriew

#define kEY_category_id                    @"category_id"
#define kEY_category                       @"category"
#define kEY_offercount                     @"offercount"




