//
//  CitiesController.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "CitiesController.h"
#import "AirportsController.h"

@interface CitiesController ()

@end

@implementation CitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreen *screen = [UIScreen mainScreen];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, screen.bounds.size.width, 40)];
    label.text = @"CitiesController";
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 400, screen.bounds.size.width - 10, 50)];
    [button addTarget:self action:@selector(nextScreen:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blackColor];
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

@end
