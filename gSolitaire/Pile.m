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

-(NSMutableArray*)getCardsBelow:(Card*)c
{
  bool foundCard = false;
  NSMutableArray *array = [[NSMutableArray alloc] init];

  NSEnumerator *enumerator = [cards objectEnumerator];

  Card *card;
  while(card = [enumerator nextObject]) {
    if(foundCard || (card.cardColor == c.cardColor && card.cardValue == c.cardValue)) {
      [array addObject:card];
      foundCard = true;
    }
  }

  if(foundCard) {
    return array;
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
}

-(NSMutableArray*)getCardArray
{
  return cards;
}

@end
