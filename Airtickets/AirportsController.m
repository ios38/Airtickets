//
//  AirportsController.m
//  Airtickets
//
//  Created by Maksim Romanov on 18.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "AirportsController.h"
#import "DataManager.h"
#import "Airport.h"
#import "City.h"

@interface AirportsController ()

@property (strong,nonatomic) City *city;
@property (strong,nonatomic) NSMutableArray *airports;

@end

@implementation AirportsController

- (instancetype)initWithCity:(City *)city {
    self = [super init];
    if (self) {
        self.city = city;
        self.airports = [self airportsFilteredWith:city.code and:city.countryCode];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreen *screen = [UIScreen mainScreen];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, screen.bounds.size.width, 40)];
    label.text = [NSString stringWithFormat:@"Airports of %@ (%lu)", self.city.name,(unsigned long)[self.airports count]];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, screen.bounds.size.width, screen.bounds.size.height - 190)];
    //tableView.allowsSelection = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    //tableView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:tableView];
}

- (NSMutableArray *)airportsFilteredWith:(NSString *)cityCode and:(NSString *)countryCode {
    NSMutableArray *airports = [NSMutableArray array];
    for (Airport *airport in DataManager.shared.airports) {
        if (airport.cityCode == cityCode && airport.countryCode == countryCode) {
            //NSLog(@"%@,%@,%@",airport.name,cityCode,countryCode);
            [airports addObject:airport];
        }
    }
    return airports;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.airports count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *airportCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"airportCell"];
    Country *airport = [self.airports objectAtIndex:indexPath.row];
    airportCell.textLabel.text = airport.name;
    
    return airportCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Airport *airport = [self.airports objectAtIndex:indexPath.row];
    double latitude = airport.coordinate.latitude;
    double longitude = airport.coordinate.longitude;
    NSLog(@"%@: %f, %f",airport.name,latitude,longitude);
}

@end
