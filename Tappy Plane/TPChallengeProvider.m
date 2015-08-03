//
//  TPChallengeProvider.m
//  Tappy Plane
//
//  Created by Alejandro on 3/8/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

#import "TPChallengeProvider.h"
#import "TPConstants.h"

@implementation TPChallengeItem

+(instancetype)challengeItemWithKey:(NSString*)key andPosition:(CGPoint)position
{
    TPChallengeItem *item = [[TPChallengeItem alloc] init];
    item.obstacleKey = key;
    item.position = position;
    return item;
}

@end

@interface TPChallengeProvider()

@property (nonatomic) NSMutableArray *challenges;

@end

@implementation TPChallengeProvider

+(instancetype)getProvider
{
    static TPChallengeProvider *sharedInstance = nil;
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[TPChallengeProvider alloc] init];
            [sharedInstance loadChallenges];
        }
        return sharedInstance;
    }
    
}

-(NSArray*)getRandomChallenge
{
    return [self.challenges objectAtIndex:arc4random_uniform((uint)self.challenges.count)];
}

-(void)loadChallenges
{
    _challenges = [NSMutableArray array];
    
    // Challenge 1
    NSMutableArray *challenge = [NSMutableArray array];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyMountainUp andPosition:CGPointMake(0, 105)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyMountainDown andPosition:CGPointMake(143, 250)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(23, 290)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(128, 40)]];
    [self.challenges addObject:challenge];
    
    // Challenge 2
    challenge = [NSMutableArray array];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyMountainUp andPosition:CGPointMake(90, 25)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyMountainDownAlternate andPosition:CGPointMake(0, 232)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(100, 243)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(152, 205)]];
    [self.challenges addObject:challenge];

    // Challenge 3
    challenge = [NSMutableArray array];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyMountainUp andPosition:CGPointMake(0, 82)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyMountainUpAlternate andPosition:CGPointMake(122, 0)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyMountainDown andPosition:CGPointMake(85, 320)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(10, 213)]];
    [challenge addObject:[TPChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(81, 116)]];
    [self.challenges addObject:challenge];

}



@end
