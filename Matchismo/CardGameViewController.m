//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Sujay Busam on 7/19/14.
//  Copyright (c) 2014 Sujay's Dev Center. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) Deck *deck;
@property (nonatomic, strong)  CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *commentaryLabel;


@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        // Start off game with selected match mode
        [self selectMatchModeControl:self.matchModeSegmentedControl];
    }
    return _game;
}

- (Deck *)deck {
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    self.matchModeSegmentedControl.enabled = NO;
    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateCommentaryLabel];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)updateCommentaryLabel
{
    NSString *commentaryString = @"";

    if ([self.game.currentMatchSet count]) {
        NSMutableArray *matchSet = [[NSMutableArray alloc] init];
        for (Card *card in self.game.currentMatchSet) {
            [matchSet addObject:card.contents];
        }
        NSString *matchSetContent = [matchSet componentsJoinedByString:@" "];
        
        if (self.game.currentMatchSetScore < 0) {
            commentaryString = [NSString stringWithFormat:@"%@ don't match! %d point penalty", matchSetContent, self.game.currentMatchSetScore];
        } else if (self.game.currentMatchSetScore > 0) {
            commentaryString = [NSString stringWithFormat:@"Matched %@ for %d points.", matchSetContent, self.game.currentMatchSetScore];
        } else {
            commentaryString = matchSetContent;
        }
    }
    
    self.commentaryLabel.text = commentaryString;
}

- (IBAction)selectMatchModeControl:(id)sender {
    int selectedIndex = [sender selectedSegmentIndex] ? [sender selectedSegmentIndex] : 0;
    self.game.matchModeNumber = [[sender titleForSegmentAtIndex:selectedIndex] integerValue];
}

- (IBAction)newGameButton:(id)sender
{
    self.game = nil;
    self.matchModeSegmentedControl.enabled = YES;
    [self updateUI];
}

@end
