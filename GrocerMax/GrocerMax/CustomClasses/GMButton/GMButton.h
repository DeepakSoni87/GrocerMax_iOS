//
//  GMButton.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMTimeSloteModal.h"
#import "GMAddressModal.h"

@interface GMButton : UIButton

@property (nonatomic, strong) GMTimeSloteModal *timeSlotModal;

@property (nonatomic, strong) GMAddressModalData *addressModal;
@end
