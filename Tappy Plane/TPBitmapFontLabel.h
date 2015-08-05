//
//  TPBitmapFontLabel.h
//  Tappy Plane
//
//  Created by Alejandro on 23/7/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    BitmapFontAlignmentLeft,
    BitmapFontAlignmentCenter,
    BitmapFontAlignmentRight,
} BitmapFontAlignment;

@interface TPBitmapFontLabel : SKNode

@property (nonatomic) NSString* fontName;
@property (nonatomic) NSString* text;
@property (nonatomic) CGFloat letterSpacing;
@property (nonatomic) BitmapFontAlignment alignment;

-(instancetype)initWithText:(NSString*)text andFontName:(NSString*)fontName;

@end
