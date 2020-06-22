//
//  UserSession.m
//  Airtickets
//
//  Created by Maksim Romanov on 21.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "UserSession.h"

NSString* const fromAirportNotification = @"fromAirportNotification";
NSString* const fromAirportUserInfoKey =@"fromAirportUserInfoKey";

@implementation UserSession

+ (UserSession *) shared {
    static UserSession *userSession = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        userSession = [[UserSession alloc] init];
        NSLog(@"UserSession created");
    });
    
    return userSession;
}

- (void) setFromAirport:(NSString*)fromAirport {
    _fromAirport = fromAirport;
    NSLog(@"%@ selected", fromAirport);
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:fromAirport forKey:fromAirportUserInfoKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:fromAirportNotification object:nil userInfo:dictionary];
}

@end
