//
//  CitiesController.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "CitiesController.h"
#import "AirportsController.h"
#import "DataManager.h"
#import "Country.h"

@interface CitiesController ()

@property (strong,nonatomic) Country *country;
@property (strong,nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation CitiesController

- (instancetype)initWithCountry:(Country *)country {
    self = [super init];
    if (self) {
        self.country = country;
        self.cities = [self citiesFilteredWith:country.code];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreen *screen = [UIScreen mainScreen];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, screen.bounds.size.width, 40)];
    label.text = [NSString stringWithFormat:@"Cities of %@ (%lu)", self.country.name,(unsigned long)[self.cities count]];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 135, screen.bounds.size.width, 40)];
    searchBar.delegate = self;
    searchBar.placeholder = @"search city";
    [self.view addSubview:searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, screen.bounds.size.width, screen.bounds.size.height - 240)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tableView];


    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, screen.bounds.size.height - 70, screen.bounds.size.width, 40)];
    [button addTarget:self action:@selector(nextScreen:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    //[self.view addSubview:button];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void) nextScreen: (UIButton *)button {
    UIViewController *airportController = [[AirportsController alloc] init];
    [self.navigationController pushViewController:airportController animated:YES];
}

- (NSMutableArray *)citiesFilteredWith:(NSString *)countryCode{
    NSMutableArray *cities = [NSMutableArray array];
    for (City *city in DataManager.shared.cities) {
        if (city.countryCode == countryCode) {
            [cities addObject:city];
        }
    }
    return cities;
}

- (NSMutableArray *)citiesFilteredWith:(NSString *)countryCode andText:(NSString *)text{
    NSMutableArray *cities = [NSMutableArray array];
    for (City *city in DataManager.shared.cities) {
        if (city.countryCode == countryCode && [city.name containsString:text]) {
            [cities addObject:city];
        }
    }
    return cities;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cities count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cityCell"];
    Country *city = [self.cities objectAtIndex:indexPath.row];
    cityCell.textLabel.text = city.name;
    
    return cityCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *city = [self.cities objectAtIndex:indexPath.row];
    UIViewController *airportController = [[AirportsController alloc] initWithCity:city];
    [self.navigationController pushViewController:airportController animated:YES];
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText  isEqual: @""]) {
        self.cities = [self citiesFilteredWith:self.country.code];
        [self.tableView reloadData];
    } else {
        self.cities = [self citiesFilteredWith:self.country.code andText:searchText];
        [self.tableView reloadData];
    }
}

@end
