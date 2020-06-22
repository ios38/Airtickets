//
//  ViewController.m
//  Airtickets
//
//  Created by Maksim Romanov on 17.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "CountriesController.h"
#import "MapController.h"
#import "TabBarController.h"
#import "UserSession.h"
#define MAS_SHORTHAND
#import "Masonry.h"

typedef enum PlaceType {
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;

@interface ViewController ()

@property (nonatomic) UIActivityIndicatorView *activityView;
@property (nonatomic) UIButton *fromButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete:) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(departureAirportSelected) name:departureAirportNotification object:nil];

    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.activityView.tintColor = [UIColor blackColor];
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    
    [self.activityView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];

    self.fromButton = UIButton.new;
    [self.fromButton addTarget:self action:@selector(chooseFrom:) forControlEvents:UIControlEventTouchUpInside];
    self.fromButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.fromButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.fromButton setTitle:@"Select Airport" forState:UIControlStateNormal];

    self.fromButton.backgroundColor = [UIColor darkGrayColor];
    self.fromButton.layer.cornerRadius = 5;
    [self.view addSubview:self.fromButton];
    [self.fromButton setHidden:YES];
    
    [self.fromButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY);
        make.left.equalTo(self.view.left).with.offset(40);
        make.right.equalTo(self.view.right).with.inset(40);
    }];

    [[DataManager shared] loadData];
}

- (void)loadDataComplete:(NSNotification *)notification {
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    [self.fromButton setHidden:NO];
}

-(void)chooseFrom:(UIButton *)button {
    [self chooseAirport:PlaceTypeDeparture];
}

-(void)chooseTo:(UIButton *)button {
    [self chooseAirport:PlaceTypeArrival];
}

-(void)chooseAirport:(PlaceType)type {
    TabBarController *tabBarController = [[TabBarController alloc] init];
    tabBarController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:tabBarController animated:NO completion:nil];
}

-(void)departureAirportSelected {
    NSString *buttonTitle = [NSString stringWithFormat:@"%@\n%@", UserSession.shared.departureAirport, self.cityAndCountryFromAirport];
    [self.fromButton setTitle:buttonTitle forState:UIControlStateNormal];
}

-(NSString *)cityAndCountryFromAirport {
    NSPredicate *airportPredicate = [NSPredicate predicateWithFormat:@"SELF.name MATCHES %@", UserSession.shared.departureAirport];
    Airport *airport = [DataManager.shared.airports filteredArrayUsingPredicate:airportPredicate].firstObject;
    return [NSString stringWithFormat:@"%@, %@", airport.city, airport.country];
}

@end
