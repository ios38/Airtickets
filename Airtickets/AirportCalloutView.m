//
//  AirportAnnotationView.m
//  Airtickets
//
//  Created by Maksim Romanov on 14.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "AirportCalloutView.h"
#import <MapKit/MapKit.h>

#define MAS_SHORTHAND
#import "Masonry.h"

@interface AirportCalloutView ()

@property(strong,nonatomic) id <MKAnnotation> annotation;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIButton *selectButton;

@end

@implementation AirportCalloutView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation {
    self = [super init];
    if (self) {
        self.annotation = annotation;
        self.frame = CGRectMake(0, 0, 150, 100);
        [self configureSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)configureSubviews {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.annotation.title;
    self.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.selectButton = [[UIButton alloc] init];
    [self.selectButton setTitle:@"Select" forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.selectButton.backgroundColor = [UIColor darkGrayColor];
    self.selectButton.layer.cornerRadius = 10;
    [self addSubview:self.selectButton];
}

- (void)setupConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).with.offset(10);
        make.left.equalTo(self.left).with.offset(10);
        make.right.equalTo(self.right).with.inset(10);
    }];
    [self.selectButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).with.inset(10);
        make.centerX.equalTo(self.centerX);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
}

@end
