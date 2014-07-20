//
//  PlayingCard.h
//  Matchismo
//
//  Created by Sujay Busam on 7/19/14.
//  Copyright (c) 2014 Sujay's Dev Center. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSInteger)maxRank;

@end
