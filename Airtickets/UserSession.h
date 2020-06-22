//
//  UserSession.h
//  Airtickets
//
//  Created by Maksim Romanov on 21.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const departureAirportNotification;
extern NSString* const departureAirportUserInfoKey;

@interface UserSession : NSObject

@property (assign,nonatomic) NSString * _Nullable departureAirport;

+ (UserSession *) shared;

@end

NS_ASSUME_NONNULL_END
