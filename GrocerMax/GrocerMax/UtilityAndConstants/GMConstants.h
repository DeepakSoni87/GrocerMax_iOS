//
//  GMConstants.h
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#ifndef GrocerMax_GMConstants_h
#define GrocerMax_GMConstants_h

#ifdef DEBUG
#define DLOG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLOG(xx, ...)  ((void)0)
#endif

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

// Key : Login

#define kEY_uemail                        @"uemail"
#define kEY_password                      @"password"


#endif
