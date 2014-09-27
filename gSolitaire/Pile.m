//
//  Pile.m
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import "Pile.h"

@implementation Pile
{
  NSMutableArray *cards;
  CGPoint pilePosition;
}

-(CGPoint)getPosition
{
  return pilePosition;
}

-(Pile*)getCardsBelow:(Card*)c
{
  bool foundCard = false;
  Pile *pile = [[Pile alloc] init];

  NSEnumerator *enumerator = [cards objectEnumerator];

  Card *card;
  while(card = [enumerator nextObject]) {
    if(foundCard || (card.cardColor == c.cardColor && card.cardValue == c.cardValue)) {
      [pile addCard:card];
      foundCard = true;
    }
  }

  enumerator = [[pile getCardArray] objectEnumerator];

  while(card = [enumerator nextObject]) {
    [self removeCard:card];
  }

  if(foundCard) {
    return pile;
  }
  return NULL;
}

-(BOOL)isCardInPile:(Card*)c
{
  NSEnumerator *enumerator = [cards objectEnumerator];

  Card *card;
  while(card = [enumerator nextObject]) {
    if(card.cardColor == c.cardColor && card.cardValue == c.cardValue) {
      return true;
    }
  }

  return false;
}

-(id) init
{
  self = [super init];
  cards = [[NSMutableArray alloc] init];
  return self;
}

-(id)initWithPosition:(CGPoint) p
{
  self = [self init];

  pilePosition = p;

  return self;
}

-(void)addCard:(Card*)c
{
  [cards addObject:c];
  // Update pile positions
  NSEnumerator *enumerator = [cards objectEnumerator];

  Card *card;
  CGPoint cgp = [self getPosition];
  while(card = [enumerator nextObject]) {
    [card setCardPosition:cgp];
    cgp.y -= 30;
  }
}

-(void)removeCard:(Card *)c
{
  [cards removeObject:c];

}

-(NSMutableArray*)getCardArray
{
  return cards;
}

@end
