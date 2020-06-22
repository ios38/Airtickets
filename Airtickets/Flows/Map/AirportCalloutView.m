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

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *subtitleLabel;

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
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = self.annotation.subtitle;
    self.subtitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.numberOfLines = 0;
    [self addSubview:self.subtitleLabel];

    self.selectButton = [[UIButton alloc] init];
    [self.selectButton setTitle:@"Select" forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.selectButton.backgroundColor = [UIColor systemBlueColor];
    self.selectButton.layer.cornerRadius = 10;
    [self addSubview:self.selectButton];
}

- (void)setupConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).with.offset(7);
        make.left.equalTo(self.left).with.offset(10);
        make.right.equalTo(self.right).with.inset(10);
    }];
    [self.subtitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).with.offset(0);
        make.left.equalTo(self.left).with.offset(10);
        make.right.equalTo(self.right).with.inset(10);
    }];
    [self.selectButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).with.inset(7);
        make.centerX.equalTo(self.centerX);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    //[self makeConstraints:^(MASConstraintMaker *make) {
    //    make.bottom.equalTo(self.selectButton.bottom).with.offset(10);
    //}];
}

@end
