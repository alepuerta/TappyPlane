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
@property (nonatomic) SKEmitterNode *puffTrailEmitter;
@property (nonatomic) CGFloat puffTrailBirthRate;

@end

static NSString* const kKeyPlaneAnimation = @"PlaneAnimation";

@implementation TPPlane

-(id)init
{
    self = [super initWithImageNamed:@"planeBlue1"];
    if (self) {
        
        // Setup physics body.
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width * 0.5];
        self.physicsBody.mass = 0.08;
        
        // Init array to hold animation actions.
        _planeAnimations = [[NSMutableArray alloc] init];
        
        
//        NSArray *frames = @[[SKTexture textureWithImageNamed:@"planeBlue1"],
//                            [SKTexture textureWithImageNamed:@"planeGreen2"],
//                            [SKTexture textureWithInsmageNamed:@"planeRed3"]];
//        SKAction *animation = [SKAction animateWithTextures:frames timePerFrame:0.133 resize:NO restore:NO];
//        [self runAction:[SKAction repeatActionForever:animation]];
        
        // Load animation plist file.
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in animations) {
            [self.planeAnimations addObject:[self animationFromArray:[animations objectForKey:key] withDuration:0.4]];
        }
        
        // Setup puff trail particle effect.
        NSString *particleFile = [[NSBundle mainBundle] pathForResource:@"PlanePuffTrail" ofType:@"sks"];
        _puffTrailEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];
        _puffTrailEmitter.position = CGPointMake(-self.size.width * 0.5, -5);
        [self addChild:self.puffTrailEmitter];
        self.puffTrailBirthRate = self.puffTrailEmitter.particleBirthRate;
        self.puffTrailEmitter.particleBirthRate = 0;
        
        
        [self setRandomColour];
    }
    return self;
}

-(void)setEngineRunning:(BOOL)engineRunning
{
    _engineRunning = engineRunning;
    if (engineRunning) {
        self.puffTrailEmitter.targetNode = self.parent;
        [self actionForKey:kKeyPlaneAnimation].speed = 1;
        self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthRate;
    } else {
        [self actionForKey:kKeyPlaneAnimation].speed = 0;
        self.puffTrailEmitter.particleBirthRate = 0;
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
    SKTextureAtlas *planesAtlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Loop throught textureNames array and load textures.
    for (NSString *textureName in textureNames) {
        [frames addObject:[planesAtlas textureNamed:textureName]];
    }
    
    // Calculate time per frame.
    CGFloat frameTime = duration / (CGFloat)frames.count;
    
    // Create and return animation action.
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:frameTime resize:NO restore:NO]];
}

-(void)update
{
    if (self.accelerating) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
}


@end
