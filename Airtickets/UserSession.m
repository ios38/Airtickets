//
//  UserSession.m
//  Airtickets
//
//  Created by Maksim Romanov on 21.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "UserSession.h"

NSString* const departureAirportNotification = @"departureAirportNotification";
NSString* const departureAirportUserInfoKey =@"departureAirportUserInfoKey";

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

- (void) setDepartureAirport:(NSString*)departureAirport {
    _departureAirport = departureAirport;
    NSLog(@"%@ selected", departureAirport);
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:departureAirport forKey:departureAirportUserInfoKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:departureAirportNotification object:nil userInfo:dictionary];
}

@end
