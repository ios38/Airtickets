//
//  AirportsController.m
//  Airtickets
//
//  Created by Maksim Romanov on 18.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "AirportsController.h"

@interface AirportsController ()

@end

@implementation AirportsController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreen *screen = [UIScreen mainScreen];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, screen.bounds.size.width, 40)];
    label.text = @"AirportController";
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
}

@end
