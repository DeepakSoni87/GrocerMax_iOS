//
//  PaymentVC.m
//  Parking
//
//  Created by neha.bansal on 7/24/15.
//  Copyright (c) 2015 Kellton. All rights reserved.
//

#import "PaymentVC.h"
#import "Utility.h"
#import <PaymentsSDK.h>
#import "PayUTransactionVC.h"
#import "ReserveParkingVC.h"



//static NSString *const MERCHANT_ID = @"Justpa62606679232283"; //staging
static NSString *const  kMERCHANT_ID =@"parkin65769728146177"; //Production
// static NSString *const MERCHANT_Website = @"Justparkwap";  //staging
static NSString *const  kMERCHANT_Website = @"parkiwap"; //Production

// static NSString *const MERCHANT_KEY = @"kdQuhATY@UvxDaLG";  //Staging
static NSString *const  kMERCHANT_KEY = @"qIGS7By#mvqf_jDh";    //Production
//static NSString *const MERCHANT_INDUSTRY_TYPE = @"Retail";   //Staging
static NSString *const  kMERCHANT_INDUSTRY_TYPE = @"Retail128"; //Production
static NSString *const  kMERCHANT_CHANNEL_ID = @"WAP";

//static NSString *const kChecksum_Generator = @"http://parkingwale.com:8080/JustPark/api/generatePaytmChecksum";
////static NSString *const kChecksum_Generator = @"http://dev.parkingwale.com:9081/JustPark/api/generatePaytmChecksum";
// static NSString *const kChecksum_Verification = @"http://parkingwale.com:8080/JustPark/api/verifyPaytmChecksum";
////static NSString *const kChecksum_Verification = @"http://dev.parkingwale.com:9081/JustPark/api/verifyPaytmChecksum";

@interface PaymentVC ()<PGTransactionDelegate>
@property (nonatomic,retain) PGMerchantConfiguration *merchant ;

@end

@implementation PaymentVC
@synthesize merchant;

- (void)viewDidLoad {
    [super viewDidLoad];
    _btninternetbanking.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.screenName = @"Payment Screen";
    merchant = [PGMerchantConfiguration defaultConfiguration];

    merchant.merchantID = kMERCHANT_ID;
    merchant.website = kMERCHANT_Website;
    merchant.industryID = kMERCHANT_INDUSTRY_TYPE;
    merchant.channelID = kMERCHANT_CHANNEL_ID;
    merchant.theme = @"merchant";
    
    merchant.checksumGenerationURL = kChecksum_Generator;
    merchant.checksumValidationURL = kChecksum_Verification;

    _UserID = [UserStorage getUid];
    _Mobilenumber = [UserStorage getMobileNumber];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:33.0/255.0 green:150.0/255.0 blue:243.0/255.0 alpha:1.0]];
    self.navigationItem.titleView = [Utility setNavigationTitle:self.navigationItem.titleView
                                                       withText:@"Payment"
                                                   withFontSize:18];
    
   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Paytm_Tapped:(id)sender
{
    NSLog(@"%@,%@,%@,%@,%@",_TransactionId,_Transactionamount,_CustomerEmail,_Mobilenumber,_UserID);

    //PGOrder *order = [PGOrder orderForOrderID:_TransactionId customerID:_UserID amount:@"1.00" customerMail:_CustomerEmail customerMobile:_Mobilenumber];
    PGOrder *order = [PGOrder orderForOrderID:_TransactionId customerID:_UserID amount:_Transactionamount customerMail:_CustomerEmail customerMobile:_Mobilenumber];
    
    PGTransactionViewController *txncontroller = [[PGTransactionViewController alloc]initTransactionForOrder:order];
    txncontroller.serverType = eServerTypeProduction;
    txncontroller.merchant = merchant;
    txncontroller.delegate =self;
    [self.navigationController pushViewController:txncontroller animated:YES];
    
    
}

-(void)didSucceedTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    NSLog(@"succedd %@ ",response);
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        //Do not forget to import AnOldViewController.h
        NSString *strlable = [NSString stringWithFormat:@"Mobileno= %@, TxnID = %@",[UserStorage getMobileNumber],response[@"BANKTXNID"]];
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate logEventwithcategory:@"Screen" action:@"booking confirmation" label:strlable Value:NULL];

        if ([controller isKindOfClass:[ReserveParkingVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTransactionSuccessFull object:@"success" userInfo:response];
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
            
        }
    }
    
}
-(void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    NSLog(@" fail %@  %@",error.localizedDescription,response);
    NSString *service;
    service=[NSString stringWithFormat:@"%@cancelBooking/?",kAPIBaseURLString];
    NSDictionary   *params = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.UserID,@"userId",
                              self.TransactionId,@"transactionId",
                              @"9",@"statusCode",
                              self.parkingId,@"parkingID",nil];
    
    [HttpOprationManager getService:service withParam:params withBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Mobile number response-------%@",responseObject);
    }];

    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[ReserveParkingVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTransactionSuccessFull object:@"fail" userInfo:response];
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
            
        }
    }
    
}
-(void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    NSLog(@"cancel %@ ",response);
    NSString *service;
    service=[NSString stringWithFormat:@"%@cancelBooking/?",kAPIBaseURLString];
    NSDictionary   *params = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.UserID,@"userId",
                              self.TransactionId,@"transactionId",
                              @"9",@"statusCode",
                              self.parkingId,@"parkingID",nil];
    
    [HttpOprationManager getService:service withParam:params withBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Mobile number response-------%@",responseObject);
    }];

    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[ReserveParkingVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTransactionSuccessFull object:@"cancel" userInfo:response];
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
            
        }
    }

   
}

- (IBAction)Credit_tapped:(id)sender
{
    PayUTransactionVC *payuVC = [[PayUTransactionVC alloc]initWithNibName:@"PayUTransactionVC" bundle:nil];
    payuVC.transactionID = self.TransactionId;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.TransactionId forKey:@"transactionid"];
    [dict setObject:self.parkingId forKey:@"parkingID"];
    [dict setObject:self.UserID forKey:@"userid"];
    
    payuVC.cancel_Info = [dict copy];
    [self.navigationController pushViewController:payuVC animated:NO];
    
}

/*-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString* pdfFilePath = [request.URL absoluteString];
    if([pdfFilePath rangeOfString:@"iossuccess"].location != NSNotFound)
    {
        NSLog(@"the url show be %@",pdfFilePath);
        
        NSLog(@"the url show be %@",pdfFilePath);
        NSArray *arr = [pdfFilePath componentsSeparatedByString:@"?"];
        NSString *status = [arr objectAtIndex:1];
        NSArray *arr1 = [status componentsSeparatedByString:@"&"];
        
        NSString *strstatus = [arr1 objectAtIndex:0];
        strstatus = [strstatus stringByReplacingOccurrencesOfString:@"status=" withString:@""];
        int status11 = [strstatus intValue];
        
        switch (status11) {
            case TransactionFailed:
                
                // booking failure
                break;
            case BookingAlreadyReserve:
                //booking already exist
                break;
            case Success:
                // booking success
                break;
                
            default:
                break;
        }

        return NO;
    }
    else if ([pdfFilePath rangeOfString:@"iosfailure"].location != NSNotFound)
    {
       NSLog(@"the url show be %@",pdfFilePath);
        NSArray *arr = [pdfFilePath componentsSeparatedByString:@"?"];
        NSString *status = [arr objectAtIndex:1];
        NSArray *arr1 = [status componentsSeparatedByString:@"&"];
        
        NSString *strstatus = [arr1 objectAtIndex:0];
        strstatus = [strstatus stringByReplacingOccurrencesOfString:@"status=" withString:@""];
        int status11 = [strstatus intValue];
        
        switch (status11) {
            case TransactionFailed:
            
            // booking failure
                break;
            case BookingAlreadyReserve:
           //booking already exist
                break;
            case Success:
            // booking success
                break;
                
            default:
                break;
        }
        
    }
    return YES;

    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView

{
    
}*/
@end
