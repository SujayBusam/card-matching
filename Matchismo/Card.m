//
//  Card.m
//  Matchismo
//
//  Created by Sujay Busam on 7/19/14.
//  Copyright (c) 2014 Sujay's Dev Center. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    
    return score;
}


@end
