//
//  TPButton.m
//  Tappy Plane
//
//  Created by Alejandro on 3/8/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPButton.h"
#import <objc/message.h>

@interface TPButton()

@property (nonatomic) CGRect fullSizeFrame;
@property (nonatomic) BOOL pressed;

@end;

@implementation TPButton

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture
{
    TPButton *instance = [super spriteNodeWithTexture:texture];
    instance.pressedScale = 0.9;
    instance.zPosition = 1.0;
    instance.userInteractionEnabled = YES;
    return instance;
}

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction
{
    _pressedTarget = pressedTarget;
    _pressedAction = pressedAction;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (self.pressed != CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            self.pressed = !self.pressed;
            
            if (self.pressed) {
                [self setScale:self.pressedScale];
                [self.pressedSound play];
            } else {
                [self setScale:1.0];
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
    self.pressed = NO;
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            // Pressed button.
            //[self.pressedTarget performSelector:self.pressedAction];
            objc_msgSend(self.pressedTarget, self.pressedAction);
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
    self.pressed = NO;
}

@end