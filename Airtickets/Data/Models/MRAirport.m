//
//  Airport.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "DataManager.h"
#import "MRAirport.h"
#import "MRCity.h"
#import "MRCountry.h"

@implementation MRAirport

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _timezone = [dictionary valueForKey:@"time_zone"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        _cityCode = [dictionary valueForKey:@"city_code"];
        _code = [dictionary valueForKey:@"code"];
        _flightable = [dictionary valueForKey:@"flightable"];
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = [coords valueForKey:@"lon"];
            NSNumber *lat = [coords valueForKey:@"lat"];
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
    }
    return self;
}

-(NSString *)city {
    NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"SELF.code MATCHES %@", self.cityCode];
    MRCity *city = [DataManager.shared.cities filteredArrayUsingPredicate:cityPredicate].firstObject;
    return city.name;
}

-(NSString *)country {
    NSPredicate *countryPredicate = [NSPredicate predicateWithFormat:@"SELF.code MATCHES %@", self.countryCode];
    MRCountry *country = [DataManager.shared.countries filteredArrayUsingPredicate:countryPredicate].firstObject;
    return country.name;
}

@end
