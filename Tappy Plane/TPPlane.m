//
//  TPPlane.m
//  Tappy Plane
//
//  Created by Alejandro on 1/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPPlane.h"
#import "TPConstants.h"

@interface TPPlane()

@property (nonatomic) NSMutableArray *planeAnimations;  // Hold animation actions.
@property (nonatomic) SKEmitterNode *puffTrailEmitter;
@property (nonatomic) CGFloat puffTrailBirthRate;

@end

static NSString* const kTPKeyPlaneAnimation = @"PlaneAnimation";
static const CGFloat kTPMaxAltitude = 300.0;

@implementation TPPlane

-(id)init
{
    self = [super initWithImageNamed:@"planeBlue1"];
    if (self) {
        
        // Setup physics body with path.
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 43 - offsetX, 18 - offsetY);
        CGPathAddLineToPoint(path, NULL, 34 - offsetX, 36 - offsetY);
        CGPathAddLineToPoint(path, NULL, 11 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 28 - offsetY);
        CGPathAddLineToPoint(path, NULL, 10 - offsetX, 4 - offsetY);
        CGPathAddLineToPoint(path, NULL, 29 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 37 - offsetX, 5 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        self.physicsBody.mass = 0.08;
        self.physicsBody.categoryBitMask = kTPCategoryPlane;
        self.physicsBody.contactTestBitMask = kTPCategoryGround | kTPCategoryCollectable;
        self.physicsBody.collisionBitMask = kTPCategoryGround;
        
        // Init array to hold animation actions.
        _planeAnimations = [[NSMutableArray alloc] init];
        
        
//        NSArray *frames = @[[SKTexture textureWithImageNamed:@"planeBlue1"],
//                            [SKTexture textureWithImageNamed:@"planeGreen2"],
//                            [SKTexture textureWithInsmageNamed:@"planeRed3"]];
//        SKAction *animation = [SKAction animateWithTextures:frames timePerFrame:0.133 resize:NO restore:NO];
//        [self runAction:[SKAction repeatActionForever:animation]];
        
        // Load animation plist file.
        NSString *animationPlistPath = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:animationPlistPath];
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

-(void)reset
{
        // Set plane's initial values.
    self.crashed = NO;
    self.engineRunning = YES;
    self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    self.zRotation = 0.0;
    self.physicsBody.angularVelocity = 0.0;
    [self setRandomColour];
}


-(void)setEngineRunning:(BOOL)engineRunning
{
    _engineRunning = engineRunning && !self.crashed;
    if (engineRunning) {
        self.puffTrailEmitter.targetNode = self.parent;
        [self actionForKey:kTPKeyPlaneAnimation].speed = 1;
        self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthRate;
    } else {
        [self actionForKey:kTPKeyPlaneAnimation].speed = 0;
        self.puffTrailEmitter.particleBirthRate = 0;
    }
}


// Commented for the challenge
-(void)setAccelerating:(BOOL)accelerating
{
    _accelerating = accelerating && !self.crashed;
}

-(void)setCrashed:(BOOL)crashed
{
    _crashed = crashed;
    if (crashed) {
        self.engineRunning = NO;
        // Commented for the challenge
        self.accelerating = NO;
    }
}

-(void)flap
{
    if (!self.crashed && self.position.y < kTPMaxAltitude) {
        
        // Make sure plane can't drop faster than -200
        if (self.physicsBody.velocity.dy < -200) {
            self.physicsBody.velocity = CGVectorMake(0, -200);
        }
        
        [self.physicsBody applyImpulse:CGVectorMake(0.0, 20)];
        
        // Make sure plane can't go up faster than 300
        if (self.physicsBody.velocity.dy > 300) {
            self.physicsBody.velocity = CGVectorMake(0, 300);
        }
    }
}

-(void)setRandomColour
{
    [self removeActionForKey:kTPKeyPlaneAnimation];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform(self.planeAnimations.count)];
    [self runAction:animation withKey:kTPKeyPlaneAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kTPKeyPlaneAnimation].speed = 0;
    }
}

-(void)collide:(SKPhysicsBody*)body
{
    // Ignore the collision if already crashed.
    if (!self.crashed) {
        if (body.categoryBitMask == kTPCategoryGround) {
            // Hit the ground.
            self.crashed = YES;
        }
        if (body.categoryBitMask == kTPCategoryCollectable) {
            [body.node runAction:[SKAction removeFromParent]];
        }
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
    // Commented for the challenge
    if (self.accelerating && self.position.y < kTPMaxAltitude) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
    
    if (!self.crashed) {
        self.zRotation = fmaxf(fminf(self.physicsBody.velocity.dy, 400), -400) / 400;
    }
}


@end
