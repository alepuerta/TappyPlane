//
//  TPTilesetTextureProvider.h
//  Tappy Plane
//
//  Created by Alejandro on 28/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface TPTilesetTextureProvider : NSObject

+(instancetype)getProvider;

-(void)randomizeTileset;
-(SKTexture*)getTextureForKey:(NSString*)key;

@end
