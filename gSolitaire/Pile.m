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
  enum pileType pile_type;
  SKSpriteNode *pileBackground;
}

-(CGPoint)getPosition
{
  return pilePosition;
}

-(SKSpriteNode*)getPileBackground
{
  return pileBackground;
}

-(void)setPileType:(enum pileType)pt {
  pile_type = pt;
}

-(enum pileType)getPileType {
  return pile_type;
}

-(void)setPilePosition:(CGPoint)p {
  pilePosition = p;
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

  pileBackground = [SKSpriteNode spriteNodeWithColor:[NSColor blackColor] size:CGSizeMake(100, 145)];
  [pileBackground setName:@"PileBackground"];
  return self;
}

-(id)initWithPosition:(CGPoint) p
{
  self = [self init];

  pilePosition = p;

  pileBackground.position = pilePosition;
  pileBackground.zPosition = -5;
  pileBackground.alpha = 0.1;

  return self;
}

-(void)updateCardPositionsInPile
{
  CGPoint cgp = [self getPosition];
  NSEnumerator *enumerator = [cards objectEnumerator];
  Card *card;
  int i = 10;

  switch([self getPileType])
  {
    case TABLEAU_PILE:
    {
      while(card = [enumerator nextObject]) {
        [card setCardPosition:cgp];
        [card setZPosition:i++];
        cgp.y -= 30;
      }
    }
      break;
    case WASTE_PILE:
    {
      // All card should be same pos as pile except last 3 which should be x+10 each
      while(card = [enumerator nextObject]) {
        [card setCardPosition:cgp];
        //[card setPosition:cgp];
        [card setZPosition:i++];
      }
      int j = 0;
      if([cards count] > 3) {
        for(i = (int)[cards count]-3; i < [cards count]; i++) {
          card = [cards objectAtIndex:i];
          CGPoint cgp = [self getPosition];

         // [card setPosition:CGPointMake(cgp.x+(10*j), cgp.y)];
          [card setCardPosition:CGPointMake(cgp.x+(10*j++), cgp.y)];
        }
      } else {
        for(i = 0; i < [cards count]; i++) {
          card = [cards objectAtIndex:i];
          CGPoint cgp = [self getPosition];

         // [card setPosition:CGPointMake(cgp.x+(10*i), cgp.y)];
          [card setCardPosition:CGPointMake(cgp.x+(10*i), cgp.y)];
        }
      }
    }
      break;
    case HOME_PILE:
    {
      while(card = [enumerator nextObject]) {
        [card setCardPosition:cgp];
        //[card setPosition:cgp];
        [card setZPosition:i++];
      }
    }
      break;
    default:
      NSLog(@"updatePilePositions: Warning - Unknown piles type");
      NSAssert(FALSE, @"updatePilePositions: Warning - Unknown piles type");
      break;
  }
}

-(void)addCard:(Card*)c
{
  [cards addObject:c];
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
