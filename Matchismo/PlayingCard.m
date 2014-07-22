//
//  PlayingCard.m
//  Matchismo
//
//  Created by Sujay Busam on 7/19/14.
//  Copyright (c) 2014 Sujay's Dev Center. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSInteger)maxRank { return [[self rankStrings] count]-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♥️",@"♦️",@"♠️",@"♣️"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}


// Reimplement match method

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        score += [self matchOnePlayingCard:otherCard];
    } else {
        for (PlayingCard *otherCard in otherCards) {
            score += [self matchOnePlayingCard:otherCard];
        }
        // Recursively match the rest of the cards
        NSRange arrayRange = NSMakeRange(1, [otherCards count]-1);
        score += [otherCards[0] match:[otherCards subarrayWithRange:arrayRange]];
    }
    
    return score;
}

- (int)matchOnePlayingCard:(PlayingCard *)otherCard
{
    int score = 0;
    
    if ([self.suit isEqualToString:otherCard.suit]) {
        score += 1;
    } else if (self.rank == otherCard.rank) {
        score += 4;
    }
    
    return score;
}

@end
