//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Sujay Busam on 7/20/14.
//  Copyright (c) 2014 Sujay's Dev Center. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger currentMatchSetScore;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, strong, readwrite) NSArray *currentMatchSet; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        // Pull count number of cards out of deck and add it to internal deck
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card ];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (instancetype)init
{
    return nil;
}

- (NSArray *)currentMatchSet
{
    if (!_currentMatchSet) _currentMatchSet = [[NSArray alloc] init];
    return _currentMatchSet;
}


// Match mode number defaults to 2 (2-card-match mode) if not set
- (NSInteger)matchModeNumber
{
    if (!_matchModeNumber || _matchModeNumber < 2) {
        return 2;
    } else {
        return _matchModeNumber;
    }
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];

    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            NSMutableArray *otherChosenCards = [[NSMutableArray alloc] init];
            self.currentMatchSetScore = 0;
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherChosenCards addObject:otherCard];
                    if ([otherChosenCards count] + 1 == self.matchModeNumber) {
                        int matchScore = [card match:otherChosenCards];
                        if (matchScore) {
                            // Match was found
                            self.currentMatchSetScore = matchScore * MATCH_BONUS;
                            card.matched = YES;
                            for (Card *otherCard in otherChosenCards) {
                                otherCard.matched = YES;
                            }
                        } else {
                            // No match found
                            for (Card *otherCard in otherChosenCards) {
                                otherCard.chosen = NO;
                            }
                            self.currentMatchSetScore = - MISMATCH_PENALTY;
                        }
                    }
                }
            }
            // Update current match set
            self.currentMatchSet = [otherChosenCards arrayByAddingObject:card];
            
            self.score += self.currentMatchSetScore - COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
