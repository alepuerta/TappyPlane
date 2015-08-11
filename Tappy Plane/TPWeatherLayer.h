//
//  TPWeatherLayer.h
//  Tappy Plane
//
//  Created by Alejandro on 11/8/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    WeatherClear,
    WeatherRaining,
    WeatherSnowing,
} WeatherType;

@interface TPWeatherLayer : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) WeatherType conditions;

-(instancetype)initWithSize:(CGSize)size;

@end
