//
//  CountriesController.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "CountriesController.h"
#import "CitiesController.h"
#import "DataManager.h"
#import "Country.h"

@interface CountriesController ()

@property (strong,nonatomic) NSMutableArray *countries;

@end

@implementation CountriesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countries = [NSMutableArray arrayWithArray:DataManager.shared.countries];

    UIScreen *screen = [UIScreen mainScreen];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, screen.bounds.size.width, 40)];
    label.text = [NSString stringWithFormat:@"Countries count: %lu", (unsigned long)[self.countries count]];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, screen.bounds.size.width, screen.bounds.size.height - 150)];
    tableView.dataSource = self;
    [self.view addSubview:tableView];


    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, screen.bounds.size.height - 70, screen.bounds.size.width, 40)];
    [button addTarget:self action:@selector(nextScreen:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void) nextScreen: (UIButton *)button {
    UIViewController *citiesController = [[CitiesController alloc] init];
    [self.navigationController pushViewController:citiesController animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.countries count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *countryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"countryCell"];
    Country *country = [self.countries objectAtIndex:indexPath.row];
    countryCell.textLabel.text = country.name;
    
    return countryCell;
}

@end
