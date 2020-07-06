//
//  NotificationDelegate.m
//  Airtickets
//
//  Created by Maksim Romanov on 06.07.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "NotificationDelegate.h"

@implementation NotificationDelegate

#pragma mark - UNUserNotificationCenterDelegate

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    //NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}
 
-(void)_userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withComvoidpletionHandler:(void(^)(void))completionHandler {
    //NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}

- (void)dealloc {
    NSLog(@"NotificationDelegate dealloc");
}

@end
