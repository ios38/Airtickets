//
//  CountriesController.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "MRCountriesController.h"
#import "MRCitiesController.h"
#import "DataManager.h"
#import "MRCountry.h"
#define MAS_SHORTHAND
#import "Masonry.h"

@interface MRCountriesController ()

@property (strong,nonatomic) NSArray *countries;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation MRCountriesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countries = [NSMutableArray arrayWithArray:DataManager.shared.countries];

    self.navigationItem.title = [NSString stringWithFormat:@"Countries (%lu)", (unsigned long)[self.countries count]];
    
    UISearchBar *searchBar = UISearchBar.new;
    searchBar.delegate = self;
    searchBar.placeholder = @"search country";
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
    //self.navigationController.navigationBar.hidden = YES;
}

- (NSArray *)countriesFilteredWith:(NSString *)text{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", text];
    return [DataManager.shared.countries filteredArrayUsingPredicate:predicate];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.countries count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *countryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"countryCell"];
    MRCountry *country = [self.countries objectAtIndex:indexPath.row];
    countryCell.textLabel.text = country.name;
    
    return countryCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MRCountry *country = [self.countries objectAtIndex:indexPath.row];
    UIViewController *citiesController = [[MRCitiesController alloc] initWithCountry:country];
    [self.navigationController pushViewController:citiesController animated:YES];
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText  isEqual: @""]) {
        self.countries = [NSArray arrayWithArray:DataManager.shared.countries];
        [self.tableView reloadData];
    } else {
        self.countries = [self countriesFilteredWith:searchText];
        [self.tableView reloadData];
    }
}

@end
