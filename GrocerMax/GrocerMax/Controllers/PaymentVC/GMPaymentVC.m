//
//  GMPaymentVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentVC.h"
#import "GMStateBaseModal.h"
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
    
    GMUserModal *userModal = self.checkOutModal.userModal;
    GMTimeSloteModal *timeSloteModal = self.checkOutModal.timeSloteModal;
    GMAddressModalData *shippingAddressModal = self.checkOutModal.shippingAddressModal;
    GMAddressModalData *billingAddressModal = self.checkOutModal.billingAddressModal;
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [checkOutDic setObject:userModal.userId forKey:kEY_userid];
    }
    if(NSSTRING_HAS_DATA(userModal.quoteId)) {
        [checkOutDic setObject:userModal.quoteId forKey:kEY_quote_id];
    }
//    [checkOutDic setObject:@"13807" forKey:kEY_userid];
//    [checkOutDic setObject:@"14" forKey:kEY_quote_id];
    
    if(NSSTRING_HAS_DATA(timeSloteModal.firstTimeSlote)) {
        [checkOutDic setObject:timeSloteModal.firstTimeSlote forKey:kEY_timeslot];
    }
    if(NSSTRING_HAS_DATA(timeSloteModal.deliveryDate)) {
        [checkOutDic setObject:timeSloteModal.deliveryDate forKey:kEY_date];
    }
    if(NSSTRING_HAS_DATA(timeSloteModal.deliveryDate)) {
        [checkOutDic setObject:timeSloteModal.deliveryDate forKey:kEY_date];
    }
    
    [checkOutDic setObject:@"cashondelivery" forKey:kEY_payment_method];
    [checkOutDic setObject:@"tablerate_bestway" forKey:kEY_shipping_method];
    
    NSMutableDictionary *shippingAddress = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(shippingAddressModal.customer_address_id)) {
        [shippingAddress setObject:shippingAddressModal.customer_address_id forKey:kEY_addressid];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.firstName)) {
        [shippingAddress setObject:shippingAddressModal.firstName forKey:kEY_fname];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.lastName)) {
        [shippingAddress setObject:shippingAddressModal.lastName forKey:kEY_lname];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.firstName)) {
        [shippingAddress setObject:shippingAddressModal.firstName forKey:kEY_fname];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.houseNo)) {
        [shippingAddress setObject:shippingAddressModal.houseNo forKey:kEY_addressline1];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.locality)) {
        [shippingAddress setObject:shippingAddressModal.locality forKey:kEY_addressline2];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.closestLandmark)) {
        [shippingAddress setObject:shippingAddressModal.closestLandmark forKey:kEY_addressline3];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.city)) {
        [shippingAddress setObject:shippingAddressModal.city forKey:kEY_city];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.region)) {
        [shippingAddress setObject:shippingAddressModal.region forKey:kEY_state];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.pincode)) {
        [shippingAddress setObject:shippingAddressModal.pincode forKey:kEY_postcode];
    }
    if(NSSTRING_HAS_DATA(cityModal.cityId)) {
        [shippingAddress setObject:cityModal.cityId forKey:kEY_cityId];
    }
    if(NSSTRING_HAS_DATA(shippingAddressModal.telephone)) {
        [shippingAddress setObject:shippingAddressModal.telephone forKey:kEY_telephone];
    }
    if([shippingAddressModal.is_default_billing intValue]== 1) {
        [shippingAddress setObject:@"1" forKey:kEY_default_billing];
    }else {
        [shippingAddress setObject:@"0" forKey:kEY_default_billing];
    }
    if([shippingAddressModal.is_default_shipping intValue] == 1) {
        [shippingAddress setObject:@"1" forKey:kEY_default_shipping];
    } else {
        [shippingAddress setObject:@"0" forKey:kEY_default_shipping];
    }
    
    
    NSMutableDictionary *billingAddress = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(billingAddressModal.customer_address_id)) {
        [billingAddress setObject:billingAddressModal.customer_address_id forKey:kEY_addressid];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.firstName)) {
        [billingAddress setObject:billingAddressModal.firstName forKey:kEY_fname];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.lastName)) {
        [billingAddress setObject:billingAddressModal.lastName forKey:kEY_lname];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.firstName)) {
        [billingAddress setObject:billingAddressModal.firstName forKey:kEY_fname];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.houseNo)) {
        [billingAddress setObject:billingAddressModal.houseNo forKey:kEY_addressline1];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.locality)) {
        [billingAddress setObject:billingAddressModal.locality forKey:kEY_addressline2];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.closestLandmark)) {
        [billingAddress setObject:billingAddressModal.closestLandmark forKey:kEY_addressline3];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.city)) {
        [billingAddress setObject:billingAddressModal.city forKey:kEY_city];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.region)) {
        [billingAddress setObject:billingAddressModal.region forKey:kEY_state];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.pincode)) {
        [billingAddress setObject:billingAddressModal.pincode forKey:kEY_postcode];
    }
    if(NSSTRING_HAS_DATA(cityModal.cityId)) {
        [billingAddress setObject:cityModal.cityId forKey:kEY_cityId];
    }
    if(NSSTRING_HAS_DATA(billingAddressModal.telephone)) {
        [billingAddress setObject:billingAddressModal.telephone forKey:kEY_telephone];
    }
    if([billingAddressModal.is_default_billing intValue]== 1) {
        [billingAddress setObject:@"1" forKey:kEY_default_billing];
    }else {
        [billingAddress setObject:@"0" forKey:kEY_default_billing];
    }
    if([billingAddressModal.is_default_shipping intValue] == 1) {
        [billingAddress setObject:@"1" forKey:kEY_default_shipping];
    } else {
        [billingAddress setObject:@"0" forKey:kEY_default_shipping];
    }
   
//    [checkOutDic setObject:shippingAddress forKey:kEY_shipping];
//    [checkOutDic setObject:billingAddress forKey:kEY_billing];
    
    [checkOutDic setObject:[NSString getJsonStringFromObject:shippingAddress] forKey:kEY_shipping];
    [checkOutDic setObject:[NSString getJsonStringFromObject:billingAddress] forKey:kEY_billing];
    
    
    [self showProgress];
    [[GMOperationalHandler handler] checkout:checkOutDic  withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        
        [self removeProgress];
    }];

    
}

@end
