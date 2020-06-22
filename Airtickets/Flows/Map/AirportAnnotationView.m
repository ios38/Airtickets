//
//  AirportAnnotationView.m
//  Airtickets
//
//  Created by Maksim Romanov on 14.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "AirportAnnotationView.h"

#define MAS_SHORTHAND
#import "Masonry.h"

@interface AirportAnnotationView ()

@property (strong,nonatomic) UIImageView *iconView;

@end

@implementation AirportAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)configureSubviews {
    self.backgroundColor = [UIColor systemBlueColor];
    //self.tintColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    //self.image = [UIImage systemImageNamed:@"airplane"];

    self.iconView = UIImageView.new;
    self.iconView.image = [UIImage systemImageNamed:@"airplane"];
    self.iconView.tintColor = [UIColor whiteColor];
    [self addSubview:self.iconView];
}

- (void)setupConstraints {
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
    }];
    UIEdgeInsets padding = UIEdgeInsetsMake(2, 2, 2, 2);
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];

}
/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* hitView = [super hitTest:point withEvent:event];
    
    if (hitView != nil) {
        [self.superview bringSubviewToFront:self];
    }
    NSLog(@"hitTest %@",[hitView class]);
    return hitView;
}*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside) {
        for (UIView *view in self.subviews) {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    //NSLog(@"pointInside: %@", isInside ? @"Yes" : @"No");
    return isInside;
}

@end
