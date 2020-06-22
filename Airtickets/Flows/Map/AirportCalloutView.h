//
//  AirportAnnotationView.h
//  Airtickets
//
//  Created by Maksim Romanov on 14.06.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AirportCalloutView: UIView

@property(strong,nonatomic) id <MKAnnotation> annotation;
@property (strong,nonatomic) UIButton *selectButton;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation;

@end

NS_ASSUME_NONNULL_END
