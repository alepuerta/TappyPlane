//
//  TPGameScene.m
//  Tappy Plane
//
//  Created by Alejandro on 1/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPGameScene.h"
#import "TPPlane.h"
#import "TPScrollingLayer.h"
#import "TPConstants.h"
#import "TPObstacleLayer.h"
#import "TPBitmapFontLabel.h"
#import "TPTilesetTextureProvider.h"

typedef enum : NSUInteger {
    GameReady,
    GameRunning,
    GameOver,
} GameState;

@interface TPGameScene()

@property (nonatomic) TPPlane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) TPScrollingLayer *background;
@property (nonatomic) TPObstacleLayer *obstacles;
@property (nonatomic) TPScrollingLayer *foreground;
@property (nonatomic) TPBitmapFontLabel *scoreLabel;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) TPGameOverMenu *gameOverMenu;
@property (nonatomic) GameState gameState;


@end

static const CGFloat kMinFPS = 10.0 / 60.0;
static NSString *const kTPKeyBestScore = @"BestScore";

@implementation TPGameScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])   {
        
        // Set background colour to sky blue.
        self.backgroundColor = [SKColor colorWithRed:0.835294118 green:0.929411765 blue:0.968627451 alpha:1.0];
        
        // Get atlas file.
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        // Setup physics.
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        self.physicsWorld.contactDelegate = self;
        
        // Setup world.
        _world = [SKNode node];
        [self addChild:_world];
        
        // Setup background.
        NSMutableArray *backgroundTiles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
        }
        
        _background = [[TPScrollingLayer alloc] initWithTiles:backgroundTiles];
        _background.horizontalScrollSpeed = -60;
        _background.scrolling = YES;
        [_world addChild:_background];
        
        // Setup obstacle layer.
        _obstacles = [[TPObstacleLayer alloc] init];
        _obstacles.collectableDelegate = self;
        _obstacles.horizontalScrollSpeed = -80;
        _obstacles.scrolling = YES;
        _obstacles.floor = 0.0;
        _obstacles.ceiling = self.size.height;
        [_world addChild:_obstacles];
        
        // Setup foreground.
        _foreground = [[TPScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                               [self generateGroundTile],
                                                               [self generateGroundTile]]];
        _foreground.horizontalScrollSpeed = -80;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        // Setup player.
        _player = [[TPPlane alloc] init];
        _player.physicsBody.affectedByGravity = NO;
        [_world addChild:_player];
        
        // Load best score.
        self.bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:kTPKeyBestScore];
        
        // Setup score label.
        _scoreLabel = [[TPBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 100);
        [self addChild:_scoreLabel];
        
        // Setup game over menu.
        _gameOverMenu = [[TPGameOverMenu alloc] initWithSize:size];
        _gameOverMenu.delegate = self;
    
        // Start a new game
        [self newGame];
        
    }
    return self;
}

-(SKSpriteNode*)generateGroundTile
{
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    
    sprite.anchorPoint = CGPointZero;
    
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 403 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 367 - offsetX, 35 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 287 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 235 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 205 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 168 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 122 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 76 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 46 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 16 - offsetY);
    
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = kTPCategoryGround;
    
//    SKShapeNode *bodyShape = [SKShapeNode node];
//    bodyShape.path = path;
//    bodyShape.strokeColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
//    bodyShape.lineWidth = 1.0;
//    [sprite addChild:bodyShape];
    
    return sprite;
}

-(void)pressedStartNewGameButton
{
    [self newGame];
    [self.gameOverMenu removeFromParent];
    
}

-(void)newGame
{
    // Randomize tileset.
    [[TPTilesetTextureProvider getProvider] randomizeTileset];
    
    // Reset layers.
    self.foreground.position = CGPointZero;
    for (SKSpriteNode *node in self.foreground.children) {
        node.texture = [[TPTilesetTextureProvider getProvider] getTextureForKey:@"ground"];
    }
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    self.obstacles.scrolling = NO;
    self.background.position = CGPointZero;
    [self.background layoutTiles];
    
    // Reset score.
    self.score = 0;
    self.scoreLabel.alpha = 1.0;
    
    // Reset plane.
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
    
    // Set game state to ready
    self.gameState = GameReady;
}

-(void)gameOver
{
    // Update game state.
    self.gameState = GameOver;
    // Fade out score display
    [self.scoreLabel runAction:[SKAction fadeOutWithDuration:0.4]];
    // Set properties om game over menu.
    self.gameOverMenu.score = self.score;
    self.gameOverMenu.medal = [self getMedalForCurrentScore];
    // Update best score.
    if (self.score > self.bestScore) {
        self.bestScore = self.score;
        [[NSUserDefaults standardUserDefaults] setInteger:self.bestScore forKey:kTPKeyBestScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.gameOverMenu.bestScore = self.bestScore;
    // Show game over menu.
    [self addChild:self.gameOverMenu];
    [self.gameOverMenu show];
}

-(void)wasCollected:(TPCollectable *)collectable
{
//    NSLog(@"Collected item worth %ld points", collectable.pointValue);
    self.score += collectable.pointValue;
}

-(void)setScore:(NSInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.gameState == GameReady) {
        self.player.physicsBody.affectedByGravity = YES;
        self.obstacles.scrolling = YES;
        self.gameState = GameRunning;
    }
    
    if (self.gameState == GameRunning) {
        self.player.accelerating = YES;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.gameState == GameRunning) {
        // Commented for the challenge
        self.player.accelerating = NO;
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == kTPCategoryPlane) {
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == kTPCategoryPlane) {
        [self.player collide:contact.bodyA];
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    
    [self.player update];
    if (self.gameState == GameRunning && self.player.crashed) {
        // Player just crashed in last frame so trigger game  over.
        [self gameOver];
    }
    
    if (self.gameState != GameOver) {
        [self.background updateWithTimeElapsed:timeElapsed];
        [self.foreground updateWithTimeElapsed:timeElapsed];
        [self.obstacles updateWithTimeElapsed:timeElapsed];
    }
}

-(MedalType)getMedalForCurrentScore
{
    NSInteger adjustedScore = self.score - (self.bestScore / 5);
    
    if (adjustedScore >= 45) {
        return MedalGold;
    } else if (adjustedScore >= 25) {
        return  MedalSilver;
    } else if (adjustedScore >= 10) {
        return MedalBronze;
    }
    return MedalNone;
    
    
}




@end
