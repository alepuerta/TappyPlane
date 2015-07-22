//
//  TPObstacleLayer.m
//  Tappy Plane
//
//  Created by Alejandro on 19/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPObstacleLayer.h"
#import "TPConstants.h"

@interface TPObstacleLayer()

@property (nonatomic) CGFloat marker;

@end

static const CGFloat kTPMarkerBuffer = 200.0;
static const CGFloat kTPVerticalGap = 90.0;
static const CGFloat kTPSpaceBetweenObstacleSets = 180.0;
static const int kTPCollectableVerticalRange = 200.0;
static const CGFloat kTPCollectableClearance = 50.0;

static NSString *const kTPKeyMountainUp = @"MountainUp";
static NSString *const kTPKeyMountainDown = @"MountainDown";
static NSString *const kTPKeyCollectableStar = @"CollectableStar";

@implementation TPObstacleLayer

-(id)init
{
    self = [super init];
    if (self) {
        // Load initial objects
        for (int i = 0; i < 5; i++) {
            [self createObjectForKey:kTPKeyMountainUp].position = CGPointMake(-1000, 0);
            [self createObjectForKey:kTPKeyMountainDown].position = CGPointMake(-1000, 0);
        }
    }
    return self;
}

-(void)reset
{
    // Loop throught child nodes and repositoion for reuse.
    for (SKNode *node in self.children) {
        node.position = CGPointMake(-1000, 0);
    }
    
    // Reposition marker
    if (self.scene) {
        self.marker = self.scene.size.width + kTPMarkerBuffer;
    }
}

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed
{
    [super updateWithTimeElapsed:timeElapsed];
    
    if (self.scrolling && self.scene) {
        // Find marker's location in scene coords.
        CGPoint markerLocationInScene = [self convertPoint:CGPointMake(self.marker, 0) toNode:self.scene];
        // When marker comes onto screen, add new obstacles.
        if (markerLocationInScene.x - (self.scene.size.width * self.scene.anchorPoint.x) < self.scene.size.width + kTPMarkerBuffer) {
            [self addObstacleSet];
        }
        
    }
}

-(void)addObstacleSet
{
    // Get mountain nodes.
    SKSpriteNode *mountainUp = [self getUnusedObjectForKey:kTPKeyMountainUp];
    SKSpriteNode *mountainDown = [self getUnusedObjectForKey:kTPKeyMountainDown];
    
    // Calculate maximum variation.
    CGFloat maxVariation = (mountainUp.size.height + mountainDown.size.height + kTPVerticalGap) - (self.ceiling - self.floor);
    CGFloat yAdjustment = (CGFloat)arc4random_uniform(maxVariation);
    
    // Position mountain nodes.
    mountainUp.position = CGPointMake(self.marker, self.floor + (mountainUp.size.height * 0.5) - yAdjustment);
    mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + kTPVerticalGap);
    
    // Get collectable star node.
    SKSpriteNode *collectable = [self getUnusedObjectForKey:kTPKeyCollectableStar];
    
    // Position collectable.
    CGFloat midPoint = mountainUp.position.y + (mountainUp.size.height * 0.5) + (kTPVerticalGap * 0.5);
    CGFloat yPosition = midPoint + arc4random_uniform(kTPCollectableVerticalRange) - (kTPCollectableVerticalRange * 0.5);
    
    yPosition = fmaxf(yPosition, self.floor + kTPCollectableClearance);
    yPosition = fminf(yPosition, self.ceiling - kTPCollectableClearance);
    
    collectable.position = CGPointMake(self.marker + (kTPSpaceBetweenObstacleSets * 0.5), yPosition);
    
    // Reposition marker.
    self.marker += kTPSpaceBetweenObstacleSets;
}

-(SKSpriteNode*)getUnusedObjectForKey:(NSString*)key
{
    if (self.scene) {
        // Get left edge of screen in local coordinates.
        CGFloat leftEdgeInLocalCoords = [self.scene convertPoint:CGPointMake(-self.scene.size.width * self.scene.anchorPoint.x, 0) toNode:self].x;
        
        // Try find object for key to the left of the screen.
        for (SKSpriteNode *node in self.children) {
            if (node.name == key && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoords) {
                // Return unused object.
                return node;
            }
        }
    }
    
    // Couldn't find an unused node with key so create a new one.
    return [self createObjectForKey:key];
}

-(SKSpriteNode*)createObjectForKey:(NSString*)key
{
    SKSpriteNode *object = nil;
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    if (key == kTPKeyMountainUp) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrass"]];
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 55 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 0 - offsetY);
        
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = kTPCategoryGround;
        
        [self addChild:object];
    } else if (key == kTPKeyMountainDown) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrassDown"]];
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 55 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 199 - offsetY);
        
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = kTPCategoryGround;
        [self addChild:object];
    } else if (key == kTPKeyCollectableStar) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"starGold"]];
        object.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:object.size.width * 0.3];
        object.physicsBody.categoryBitMask = kTPCategoryCollectable;
        object.physicsBody.dynamic = NO;
        
        [self addChild:object];
    }
    
    if (object) {
        object.name = key;
    }
    
    return object;
}

@end
