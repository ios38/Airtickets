//
//  AppDelegate.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationDelegate.h"

@interface AppDelegate ()

@property (strong,nonatomic) NotificationDelegate *notificationDelegate;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
        
    if ([UNUserNotificationCenter class]) {
        self.notificationDelegate = NotificationDelegate.new;
        center.delegate = self.notificationDelegate;
    }

    [self addNotification];

    return YES;
}

#pragma mark - UNUserNotificationCenter

-(void) addNotification {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Уведомление";
    content.body = @"Прошла 1 минута";
    content.sound = [UNNotificationSound defaultSound];

    NSDateComponents *components = NSDateComponents.new;
    components.second = 0;
    /*
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *offset = NSDateComponents.new;
    [offset setSecond: 10];
    NSLog(@"%@", [NSDate now]);
    NSDate *notificationDate = [calendar dateByAddingComponents:offset toDate:[NSDate now] options:0];
    NSLog(@"%@", notificationDate);

    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:notificationDate];
    //NSLog(@"%@", components);
    NSLog(@"%ld:%ld:%ld", (long)components.hour, (long)components.minute,(long)components.second);

    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    */
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notification" content:content trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
