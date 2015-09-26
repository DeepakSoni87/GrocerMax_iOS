//
//  GMPaymentVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentVC.h"

@interface GMPaymentVC ()

@end

@implementation GMPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)actionPaymentCash:(id)sender {
    
    NSMutableDictionary *checkOutDic = [[NSMutableDictionary alloc]init];
//    [checkOutDic setObject:<#(id)#> forKey:<#(id<NSCopying>)#>
    
    /**
     * Function for Final Order Checkout
     * @param GET Var userid, quote_id, shipping, billing, payment_method, shipping_method, timeslot, date
     * shipping input is in JSON Format. fields (fname,lname,addressline1,addressline2,city,region,postcode,country_id,telephone,default_billing,default_shipping)
     * billing input is in JSON Format. fields (fname,lname,addressline1,addressline2,city,region,postcode,country_id,telephone,default_billing,default_shipping)
     * @output JSON string
     * payment_method (cashondelivery,payucheckout_shared)
     * shipping_method (bestway)
     */
    
//dev.grocermax.com/webservice/new_services/checkout?shipping={"addressline2":"","default_billing":"0","lname":"yadav","addressline1":"dlf","country_id":"IN","postcode":"122001","telephone":"9999999999","default_shipping":"0","fname":"abhi","city":"Gurgaon"}&billing={"addressline2":"","default_billing":"0","lname":"yadav","addressline1":"dlf","country_id":"IN","postcode":"122001","telephone":"9999999999","default_shipping":"0","fname":"abhi","city":"Gurgaon"}&userid=6627"quote_id=14×lot=null&date=null&payment_method=cashondelivery&shipping_method=tablerate_bestway
    
//dev.grocermax.com/webservice/new_services/checkout?userid=323&quote_id=###&shipping={JSON Data}&billing={JSON Data}&payment_method=&shipping_method=&timeslot=&date=

    
}

@end
