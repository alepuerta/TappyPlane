//
//  TPWeatherLayer.m
//  Tappy Plane
//
//  Created by Alejandro on 11/8/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPWeatherLayer.h"
#import "SoundManager.h"

@interface TPWeatherLayer()

@property (nonatomic) SKEmitterNode *rainEmitter;
@property (nonatomic) SKEmitterNode *snowEmitter;
@property (nonatomic) Sound *rainSound;

@end

@implementation TPWeatherLayer

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _size = size;
        
        // Load rain effect.
        NSString *rainEffectPath = [[NSBundle mainBundle] pathForResource:@"RainEffect" ofType:@"sks"];
        _rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:rainEffectPath];
        _rainEmitter.position = CGPointMake(size.width * 0.5 + 32, size.height + 5);
        
        // Setup rain sound.
        _rainSound = [Sound soundNamed:@"Rain.caf"];
        _rainSound.looping = YES;
        
        // Load snow effect.
        NSString *snowEffectPath = [[NSBundle mainBundle] pathForResource:@"SnowEffect" ofType:@"sks"];
        _snowEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:snowEffectPath];
        _snowEmitter.position = CGPointMake(size.width * 0.5, size.height + 5);
        
    }
    return self;
}

-(void)setConditions:(WeatherType)conditions
{
    if (_conditions != conditions) {
        _conditions = conditions;
        
        //Remove existing weather effect.
        [self removeAllChildren];
        
        // Stop any existing sound from playing.
        if (self.rainSound.playing) {
            [self.rainSound fadeOut:1.0];
        }
        
        // Add weather conditions.
        switch (conditions) {
            case WeatherRaining:
                [self.rainSound play];
                [self.rainSound fadeIn:1.0];
                [self addChild:self.rainEmitter];
                [self.rainEmitter advanceSimulationTime:5];
                break;
                
            case WeatherSnowing:
                [self addChild:self.snowEmitter];
                [self.snowEmitter advanceSimulationTime:5];
                break;
                
            default:
                break;
        }
    }
}

@end
