//
//  TPChallengeProvider.h
//  Tappy Plane
//
//  Created by Alejandro on 3/8/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPChallengeItem : NSObject

@property (nonatomic) NSString *obstacleKey;
@property (nonatomic) CGPoint position;

+(instancetype)challengeItemWithKey:(NSString*)key andPosition:(CGPoint)position;

@end



@interface TPChallengeProvider : NSObject

+(instancetype)getProvider;
-(NSArray*)getRandomChallenge;

@end
