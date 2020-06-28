//
//  DataManager.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "DataManager.h"
#import "UIKit/UIKit.h"
#import "Country+CoreDataProperties.h"
#import "City+CoreDataProperties.h"
#import "Airport+CoreDataProperties.h"

@interface DataManager ()

@property (nonatomic, strong) NSMutableArray *countriesArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *airportsArray;

@property(strong,nonatomic) NSManagedObjectContext *context;

@end

@implementation DataManager

+ (instancetype)shared {
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
        instance.context = instance.persistentContainer.viewContext;
    });
    return instance;
}

-(void)fillCoreData {
    for (MRCountry *mrCountry in self.countriesArray) {
        Country *country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:self.context];
        country.name = mrCountry.name;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.countryCode MATCHES[cd] %@", mrCountry.code];
        NSArray *mrCities = [self.citiesArray filteredArrayUsingPredicate:predicate];
        for (MRCity *mrCity in mrCities) {
            City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.context];
            city.name = mrCity.name;
            city.country = country;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.cityCode MATCHES[cd] %@ AND SELF.countryCode MATCHES[cd] %@", mrCity.code, mrCountry.code];
            NSArray *mrAirports = [self.airportsArray filteredArrayUsingPredicate:predicate];
            for (MRAirport *mrAirport in mrAirports) {
                Airport *airport = [NSEntityDescription insertNewObjectForEntityForName:@"Airport" inManagedObjectContext:self.context];
                airport.name = mrAirport.name;
                airport.city = city;
            }
        }
        [DataManager.shared saveContext];
        [self printAllObjects];
    }
}

- (void) printArray:(NSArray*) array {
    
    for (id object in array) {
        if ([object isKindOfClass:[Country class]]) {
            Country *country = (Country *) object;
            NSLog(@"Country: %@, cities: %lu", country.name, (unsigned long)[country.cities count]);
        } else if ([object isKindOfClass:[City class]]) {
            City *city = (City *) object;
            NSLog(@"City: %@, %@, airports: %lu", city.name, city.country.name, (unsigned long)[city.airports count]);
        } else if ([object isKindOfClass:[Airport class]]) {
            Airport *airport = (Airport *) object;
            NSLog(@"Airport: %@ (%@, %@)", airport.name, airport.city.name, airport.city.country.name);
        }
    }
    NSLog(@"All objects count = %lu",(unsigned long)[array count]);
}

- (NSArray*)allObjects {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Object" inManagedObjectContext:self.context];
    [request setEntity:description];
    [request setFetchLimit:1000];

    NSError* requestError = nil;
    NSArray* resultArray = [self.context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    return resultArray;
}

- (void) deleteAllObjects {
    id allObjects = [self allObjects];
    
    for (id object in allObjects) {
        [self.context deleteObject:object];
    }
    [self.context save:nil];
}

- (void) printAllObjects {
    NSArray* allObjects = [self allObjects];
    [self printArray:allObjects];
}

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJsonArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        self.countriesArray = [self createObjectsFromArray:countriesJsonArray withType: DataSourceTypeCountry];
        
        NSArray *citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        self.citiesArray = [self createObjectsFromArray:citiesJsonArray withType: DataSourceTypeCity];
        
        NSArray *airportsJsonArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        self.airportsArray = [self createObjectsFromArray:airportsJsonArray withType: DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete object:nil];
            [self fillCoreData];
        });
        NSLog(@"Complete load data");
    });
}

- (NSMutableArray *)createObjectsFromArray:(NSArray *)array withType:(DataSourceType)type {
    NSMutableArray *results = [NSMutableArray new];
    
    for (NSDictionary *jsonObject in array) {
        if (type == DataSourceTypeCountry) {
            MRCountry *country = [[MRCountry alloc] initWithDictionary: jsonObject];
            [results addObject: country];
        }
        else if (type == DataSourceTypeCity) {
            MRCity *city = [[MRCity alloc] initWithDictionary: jsonObject];
            [results addObject: city];
        }
        else if (type == DataSourceTypeAirport) {
            MRAirport *airport = [[MRAirport alloc] initWithDictionary: jsonObject];
            [results addObject: airport];
        }
    }
    return results;
}

- (NSArray *)arrayFromFileName:(NSString *)fileName ofType:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (NSArray *)countries {
    return _countriesArray;
}

- (NSArray *)cities {
    return _citiesArray;
}

- (NSArray *)airports {
    return _airportsArray;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Airtickets"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {

                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    
                    //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //abort();
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

@end
