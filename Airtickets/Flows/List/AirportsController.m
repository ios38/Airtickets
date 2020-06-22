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
#import "UserSession.h"
#define MAS_SHORTHAND
#import "Masonry.h"

@interface AirportsController ()

@property (strong,nonatomic) City *city;
@property (strong,nonatomic) NSArray *airports;

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

    self.navigationItem.title = [NSString stringWithFormat:@"Airports of %@ (%lu)", self.city.name,(unsigned long)[self.airports count]];

    UITableView *tableView = UITableView.new;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.topMargin);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottomMargin);
    }];
}

- (NSArray *)airportsFilteredWith:(NSString *)cityCode and:(NSString *)countryCode {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.cityCode MATCHES[cd] %@ AND SELF.countryCode MATCHES[cd] %@", cityCode, countryCode];
    return [DataManager.shared.airports filteredArrayUsingPredicate:predicate];
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
    //double latitude = airport.coordinate.latitude;
    //double longitude = airport.coordinate.longitude;
    //NSLog(@"%@: %f, %f",airport.name,latitude,longitude);
    UserSession.shared.departureAirport = airport.name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
