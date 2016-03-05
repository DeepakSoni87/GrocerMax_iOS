//
//  MGAppliactionUpdate.m
//  FINDIT333
//
//  Created by arvind gupta on 24/02/15.
//  Copyright (c) 2015 Arvind Gupta. All rights reserved.
//

#import "MGInternalNotificationAlert.h"




@interface MGInternalNotificationAlert ()
+ (MGInternalNotificationAlert*)sharedInstance;
- (void)shownotificationAlert;
@end

@implementation MGInternalNotificationAlert
//@synthesize notificationAlert;

+ (MGInternalNotificationAlert*)sharedInstance {
    static MGInternalNotificationAlert *notificationAlert = nil;
    if (notificationAlert == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            notificationAlert = [[MGInternalNotificationAlert alloc] init];
          
        });
    }
    
    return notificationAlert;
}

- (void)shownotificationAlert {
    if([self.notificationModal.type isEqualToString:KEY_APPLICATION_INTERNAL_NOTIFICATION_POPUP]) {
        
        if(self.notificationModal.actions.count>0) {
        NSString *msg = @"";
        if(NSSTRING_HAS_DATA(self.notificationModal.notificationMessage)){
            msg = self.notificationModal.notificationMessage;
        }
            UIViewController *topControler = [APP_DELEGATE getTopControler];
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:msg preferredStyle:UIAlertControllerStyleAlert];
        
            for(int i = 0; i<[self.notificationModal.actions count]; i++) {
                GMInternalNotificationActionsModal *notificationActionsModal = [self.notificationModal.actions objectAtIndex:i];
                NSString *firstActionTitle = @"";
                
                if(NSSTRING_HAS_DATA(notificationActionsModal.text)){
                    firstActionTitle = notificationActionsModal.text;
                }
                
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:firstActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [topControler dismissViewControllerAnimated:YES completion:nil];
                [self  notificationAction:notificationActionsModal];
            }];
                [alertController addAction:alertAction];
            }
            
        
        [topControler presentViewController:alertController animated:YES completion:nil];
        }
    }
    
}

-(void)notificationAction:(GMInternalNotificationActionsModal*)actionModal {
    
    NSString *value = @"";
    NSString *name = @"";
    
    if(NSSTRING_HAS_DATA(actionModal.page)) {
        value = actionModal.page;
    }
    
    if(NSSTRING_HAS_DATA(actionModal.name)) {
        name = actionModal.name;
    }
    [APP_DELEGATE openScreen:actionModal.key data:value displayName:name];
}


+ (void)showNotificationAlert:(GMInternalNotificationModal *)notiModal{
    
    [MGInternalNotificationAlert sharedInstance].notificationModal = notiModal;
     [[MGInternalNotificationAlert sharedInstance] shownotificationAlert];
}
@end
