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
#import "GMProductModal.h"
#import "GMBaseOrderHistoryModal.h"


@interface GMButton : UIButton

@property (nonatomic, strong) GMTimeSloteModal *timeSlotModal;

@property (nonatomic, strong) GMAddressModalData *addressModal;

@property (nonatomic, strong) GMCityModal *cityModal;

@property (nonatomic, strong) GMProductModal *produtModal;

@property (nonatomic, strong) GMOrderHistoryModal *orderHistoryModal;
@end
