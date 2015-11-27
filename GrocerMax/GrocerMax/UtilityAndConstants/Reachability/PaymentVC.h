//
//  PaymentVC.h
//  Parking
//
//  Created by neha.bansal on 7/24/15.
//  Copyright (c) 2015 Kellton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface PaymentVC : GAITrackedViewController<UIWebViewDelegate>
- (IBAction)Paytm_Tapped:(id)sender;
- (IBAction)Credit_tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btninternetbanking;

@property(nonatomic,retain)NSString *CustomerEmail;
@property(nonatomic,retain)NSString *TransactionId;
@property(nonatomic,retain)NSString *Transactionamount;

@property(nonatomic,retain)NSString *parkingId;

@property(nonatomic,retain)NSString *UserID;
@property(nonatomic,retain)NSString *Mobilenumber;
@end

