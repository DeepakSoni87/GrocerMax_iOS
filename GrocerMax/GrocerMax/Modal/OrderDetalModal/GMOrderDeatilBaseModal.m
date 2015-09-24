//
//  GMOrderDeatilBaseModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderDeatilBaseModal.h"

#define Key_OrderDetail @"OrderDetail"
#define Key_OredrId @"oeder_id"
#define Key_OredrDate @"created_at"
#define Key_ShippingCharge @"base_shipping_amount"
#define Key_PaymentMethod @"shipping_method"
#define Key_Delivery_Date @"deliverydate"
#define Key_Delivery_key @"key"
#define Key_Delivery_value @"value"
#define Key_Sipping_Address @"shipping_address"
#define Key_Sipping_Street @"street"
#define Key_items @"items"

@implementation GMOrderDeatilBaseModal

- (GMOrderDeatilBaseModal *) initWithDictionary:(NSMutableDictionary *)orderDetailDic {
    
    if([orderDetailDic objectForKey:Key_OrderDetail] && [[orderDetailDic objectForKey:Key_OrderDetail] isKindOfClass:[NSDictionary class]]) {
    
        NSMutableDictionary *dataDic = [orderDetailDic objectForKey:Key_OrderDetail];
        
        if([dataDic objectForKey:Key_OredrId]) {
            [self setOrderId:[NSString stringWithFormat:@"%@",[dataDic objectForKey:Key_OredrId]]];
        }
        if([dataDic objectForKey:Key_OredrDate] && NSSTRING_HAS_DATA([dataDic objectForKey:Key_OredrDate])) {
            [self setOrderDate:[NSString stringWithFormat:@"%@",[dataDic objectForKey:Key_OredrDate]]];
        }
        if([dataDic objectForKey:Key_ShippingCharge] && NSSTRING_HAS_DATA([dataDic objectForKey:Key_ShippingCharge])) {
            [self setShippingCharge:[NSString stringWithFormat:@"%@",[dataDic objectForKey:Key_ShippingCharge]]];
        }
        if([dataDic objectForKey:Key_PaymentMethod]) {
            [self setPaymentMethod:[NSString stringWithFormat:@"%@",[dataDic objectForKey:Key_PaymentMethod]]];
        }
        if([dataDic objectForKey:Key_Delivery_Date] && [[dataDic objectForKey:Key_Delivery_Date] isKindOfClass:[NSArray class]]) {
            NSArray *delviryDatetimeArray = [dataDic objectForKey:Key_Delivery_Date];
            if(delviryDatetimeArray.count>0) {
            NSDictionary *deliveryDateTime = [delviryDatetimeArray objectAtIndex:0];
                if([deliveryDateTime objectForKey:Key_Delivery_key] && [[deliveryDateTime objectForKey:Key_Delivery_key] isEqualToString:@"date"]) {
                    [self setDeliveryDate:[NSString stringWithFormat:@"%@",[deliveryDateTime objectForKey:Key_Delivery_value]]];
                }
                else {
                    [self setDeliveryTime:[NSString stringWithFormat:@"%@",[deliveryDateTime objectForKey:Key_Delivery_value]]];
                }
            }
            if(delviryDatetimeArray.count>1) {
                NSDictionary *deliveryDateTime = [delviryDatetimeArray objectAtIndex:1];
                if([deliveryDateTime objectForKey:Key_Delivery_key] && [[deliveryDateTime objectForKey:Key_Delivery_key] isEqualToString:@"date"]) {
                    [self setDeliveryDate:[NSString stringWithFormat:@"%@",[deliveryDateTime objectForKey:Key_Delivery_value]]];
                }
                else {
                    [self setDeliveryTime:[NSString stringWithFormat:@"%@",[deliveryDateTime objectForKey:Key_Delivery_value]]];
                }
            }
            
            
        }
       
        if([dataDic objectForKey:Key_Sipping_Address] && [[dataDic objectForKey:Key_Sipping_Address] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *shippingAddressDic = [dataDic objectForKey:Key_Sipping_Address];
            if([shippingAddressDic objectForKey:Key_Sipping_Street] ) {
            [self setShippingAddress:[NSString stringWithFormat:@"%@",[shippingAddressDic objectForKey:Key_Sipping_Street]]];
            }
        }
        
        self.itemModalArray = [[NSMutableArray alloc]init];
        
        if([dataDic objectForKey:Key_items] && [[dataDic objectForKey:Key_items] isKindOfClass:[NSArray class]]) {
            NSArray *itemArray = [dataDic objectForKey:Key_items];
            for(int i = 0; i<itemArray.count; i++){
                if([[itemArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *itemDic = [itemArray objectAtIndex:i];
                    GMOrderItemDeatilModal *orderItemDeatilModal = [[GMOrderItemDeatilModal alloc]init];
                }
            }
            
        }
    }
    
    return self;
}

@end

@implementation GMOrderItemDeatilModal

@end