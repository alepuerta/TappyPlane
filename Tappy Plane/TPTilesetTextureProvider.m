//
//  TPTilesetTextureProvider.m
//  Tappy Plane
//
//  Created by Alejandro on 28/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPTilesetTextureProvider.h"

@interface TPTilesetTextureProvider()

@property (nonatomic) NSMutableDictionary *tilesets;
@property (nonatomic) NSDictionary *currentTileset;

@end

@implementation TPTilesetTextureProvider

+(instancetype)getProvider
{
    static TPTilesetTextureProvider *provider = nil;
    @synchronized(self) {
        if (!provider) {
            provider = [[TPTilesetTextureProvider alloc] init];
        }
        return provider;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadTilesets];
        [self randomizeTileset];
    }
    return self;
}

-(void)randomizeTileset
{
    NSArray *tilesetKeys = [self.tilesets allKeys];
    NSString *key = [tilesetKeys objectAtIndex:arc4random_uniform((uint)tilesetKeys.count)];
    self.currentTileset = [self.tilesets objectForKey:key];
}

-(SKTexture*)getTextureForKey:(NSString*)key
{
    return [self.currentTileset objectForKey:key];
}



-(void)loadTilesets
{
    self.tilesets = [[NSMutableDictionary alloc] init];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Get path to property list.
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TilesetGraphics" ofType:@"plist"];
    // Load contents of file.
    NSDictionary *tilesetList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    // Loop through tilesetList.
    for (NSString *tilesetKey in tilesetList) {
        // Get dictionary of texture names.
        NSDictionary *textureList = [tilesetList objectForKey:tilesetKey];
        // Create dictionary to hold textures.
        NSMutableDictionary *textures = [[NSMutableDictionary alloc] init];
        
        for (NSString *textureKey in textureList) {
            // Get textur for key.
            SKTexture *texture = [atlas textureNamed:[textureList objectForKey:textureKey]];
            // Insert texture to textures dictionary.
            [textures setObject:texture forKey:textureKey];
        }
        
        
        // Add textures dictionary to tilesets.
        [self.tilesets setObject:textures forKey:tilesetKey];
    }
}

@end
