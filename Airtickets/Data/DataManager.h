//
//  DataManager.h
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCountry.h"
#import "MRCity.h"
#import "MRAirport.h"
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

+ (instancetype)shared;
- (void)loadData;
- (void)printAllObjects;
- (void)deleteAllObjects;


@end

NS_ASSUME_NONNULL_END
