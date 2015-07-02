//
//  TPPlane.m
//  Tappy Plane
//
//  Created by Alejandro on 1/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPPlane.h"

@interface TPPlane()

@property (nonatomic) NSMutableArray *planeAnimations;  // Hold animation actions.

@end

static NSString* const kKeyPlaneAnimation = @"PlanaAnimation";

@implementation TPPlane

-(id)init
{
    self = [super initWithImageNamed:@"planeBlue1"];
    if (self) {
        
        // Init array to hold animation actions.
        _planeAnimations = [[NSMutableArray alloc] init];
        
        // Load animation plist file.
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in animations) {
            [self.planeAnimations addObject:[self animationFromArray:[animations objectForKey:key] withDuration:0.4]];
        }
        
        [self setRandomColour];
    }
    return self;
}

-(void)setEngineRunning:(BOOL)engineRunning
{
    _engineRunning = engineRunning;
    if (engineRunning) {
        [self actionForKey:kKeyPlaneAnimation].speed = 1;
    } else {
        [self actionForKey:kKeyPlaneAnimation].speed = 0;
    }
}

-(void)setRandomColour
{
    [self removeActionForKey:kKeyPlaneAnimation];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform(self.planeAnimations.count)];
    [self runAction:animation withKey:kKeyPlaneAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kKeyPlaneAnimation].speed = 0;
    }
}

-(SKAction *)animationFromArray:(NSArray *)textureNames withDuration:(CGFloat)duration
{
    // Create array to hold textures.
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    // Get planes atlas.
    SKTextureAtlas *planesAtlas = [SKTextureAtlas atlasNamed:@"Planes"];
    
    // Loop throught textureNames array and load textures.
    for (NSString *textureName in textureNames) {
        [frames addObject:[planesAtlas textureNamed:textureName]];
    }
    
    // Calculate time per frame.
    CGFloat frameTime = duration / (CGFloat)frames.count;
    
    // Create and return animation action.
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:frameTime resize:NO restore:NO]];
}

@end
