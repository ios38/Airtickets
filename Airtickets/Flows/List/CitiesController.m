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
#import "MRCountry.h"
#define MAS_SHORTHAND
#import "Masonry.h"

@interface CitiesController ()

@property (strong,nonatomic) MRCountry *country;
@property (strong,nonatomic) NSArray *cities;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation CitiesController

- (instancetype)initWithCountry:(MRCountry *)country {
    self = [super init];
    if (self) {
        self.country = country;
        self.cities = [self citiesFilteredWith:country.code];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Cities of %@ (%lu)", self.country.name,(unsigned long)[self.cities count]];
    
    UISearchBar *searchBar = UISearchBar.new;
    searchBar.delegate = self;
    searchBar.placeholder = @"search city";
    [self.view addSubview:searchBar];
    
    [searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.topMargin);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];

    self.tableView = UITableView.new;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottomMargin);
    }];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = NO;
}

- (NSArray *)citiesFilteredWith:(NSString *)countryCode{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.countryCode MATCHES[cd] %@", countryCode];
    return [DataManager.shared.cities filteredArrayUsingPredicate:predicate];
}

- (NSArray *)citiesFilteredWith:(NSString *)countryCode andText:(NSString *)text{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@ AND SELF.countryCode MATCHES[cd] %@", text, countryCode];
    return [DataManager.shared.cities filteredArrayUsingPredicate:predicate];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cities count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cityCell"];
    MRCountry *city = [self.cities objectAtIndex:indexPath.row];
    cityCell.textLabel.text = city.name;
    
    return cityCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MRCity *city = [self.cities objectAtIndex:indexPath.row];
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
