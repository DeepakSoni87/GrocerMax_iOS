//
//  GMDeliveryDetailVC.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMDeliveryDetailVC : UIViewController


//@property (strong, nonatomic) NSMutableArray *dateArray;
//@property (strong, nonatomic) NSMutableArray *timeSloteModalArray;
@property (strong, nonatomic) NSMutableArray *dateTimeSloteModalArray;

@property (strong, nonatomic) GMTimeSlotBaseModal *timeSlotBaseModal;
@end
