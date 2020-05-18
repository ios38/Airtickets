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

@interface CitiesController ()

@property (strong,nonatomic) NSMutableArray *cities;

@end

@implementation CitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cities = [NSMutableArray arrayWithArray:DataManager.shared.cities];

    UIScreen *screen = [UIScreen mainScreen];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, screen.bounds.size.width, 40)];
    label.text = [NSString stringWithFormat:@"Cities count: %lu", (unsigned long)[self.cities count]];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, screen.bounds.size.width, screen.bounds.size.height - 200)];
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
    self.navigationController.navigationBar.hidden = NO;
}

- (void) nextScreen: (UIButton *)button {
    UIViewController *airportController = [[AirportsController alloc] init];
    [self.navigationController pushViewController:airportController animated:YES];
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

@end
