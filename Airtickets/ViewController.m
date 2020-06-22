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
    UIScreen *screen = [UIScreen mainScreen];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete:) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromAirportSelected) name:fromAirportNotification object:nil];

    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.activityView.tintColor = [UIColor blackColor];
    self.activityView.frame = CGRectMake((screen.bounds.size.width - self.activityView.frame.size.width)/2, (screen.bounds.size.height - self.activityView.frame.size.height)/2, self.activityView.frame.size.width, self.activityView.frame.size.height);
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    
    self.fromButton = [[UIButton alloc] initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height / 2 - 40 - 60, [UIScreen mainScreen].bounds.size.width - 80, 60)];
    [self.fromButton addTarget:self action:@selector(chooseFrom:) forControlEvents:UIControlEventTouchUpInside];
    [self.fromButton setTitle:@"Select Airport" forState:UIControlStateNormal];
    self.fromButton.backgroundColor = [UIColor darkGrayColor];
    self.fromButton.layer.cornerRadius = 5;
    [self.view addSubview:self.fromButton];
    [self.fromButton setHidden:YES];

    [[DataManager shared] loadData];
}

- (void)loadDataComplete:(NSNotification *)notification {
    //UIViewController *countriesController = [[CountriesController alloc] init];
    //[self.navigationController pushViewController:countriesController animated:NO];
    //UIViewController *mapController = [[MapController alloc] init];
    //[self.navigationController pushViewController:mapController animated:NO];
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
    NSLog(@"%@ button tapped",type == 2 ? @"Arrival" : @"Departure");
    //ViewController *controller = [[ViewController alloc] init];
    //controller.type = type;
    //controller.delegate = self;
    //[self.navigationController showViewController:controller sender:nil];
    TabBarController *tabBarController = [[TabBarController alloc] init];
    tabBarController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:tabBarController animated:NO completion:nil];


}

-(void)fromAirportSelected {
    [self.fromButton setTitle:UserSession.shared.fromAirport forState:UIControlStateNormal];
}

@end
