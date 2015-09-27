//
//  GMAddShippingAddressVC.h
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMAddressModalData;

@interface GMAddShippingAddressVC : UIViewController

@property (nonatomic, strong) GMAddressModalData *editAddressModal;

@property (weak, nonatomic) IBOutlet UIImageView *prgressBarImageView;

@property (nonatomic) BOOL isProgress;

@end
