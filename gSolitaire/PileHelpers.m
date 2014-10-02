//
//  PileHelpers.m
//  gSolitaire
//
//  Created by Björn Hall on 01/10/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import "PileHelpers.h"

@implementation PileHelpers


+(void)makePileOnTop:(Pile*)pile
{
  NSEnumerator *enumerator = [[pile getCardArray] objectEnumerator];

  Card *c;
  while(c = [enumerator nextObject]) {
    c.zPosition += 1000;
  }
}

+(Pile*)getPileOfType:(enum pileType)pt inPiles:(NSMutableArray*)array
{
  Pile *p;
  NSEnumerator *enumerator = [array objectEnumerator];
  while(p = [enumerator nextObject]) {
    if([p getPileType] == pt) {
      return p;
    }
  }
  return NULL;
}

+(Pile *)getPileWithCard:(Card *)c from:(NSMutableArray*)array
{
  Pile *p;

  NSEnumerator *enumerator = [array objectEnumerator];

  while(p = [enumerator nextObject]) {
    if([p isCardInPile:c]) {
      return p;
    }
  }

  return NULL;
}

+(void)restoreZPosition:(NSMutableArray*)array
{
  NSEnumerator *enumerator = [array objectEnumerator];

  Card *c;
  while(c = [enumerator nextObject]) {
    c.zPosition -= 1000;
  }
}

+(void)calculateZPosition:(Pile*)p
{
  NSEnumerator *enumerator = [[p getCardArray] objectEnumerator];

  Card *c;
  int i = 10;

  while(c = [enumerator nextObject]) {
    c.zPosition = i++;
  }
}

+(Pile*)pileFromLocation:(CGPoint) point andPiles:(NSMutableArray*)array
{
  Pile *p;
  NSEnumerator *enumerator = [array objectEnumerator];

  while(p = [enumerator nextObject]) {
    if([p getPosition].x - 50 <= point.x && [p getPosition].x + 50 >= point.x
       && [p getPosition].y >= (point.y-100)) {
      return p;
    }
  }

  return NULL;
}

+(void)positionPile:(Pile*)pile at:(CGPoint)point
{
  NSEnumerator *enumerator = [[pile getCardArray] objectEnumerator];

  Card *c;
  while(c = [enumerator nextObject]) {
    c.position = point;
    point.y -= 30;
  }
}

+(NSMutableArray*)dealCardsFromDeck:(NSMutableArray*)array
{
  Card *c;
  NSEnumerator *enumerator;
  NSMutableArray *deltCards = [[NSMutableArray alloc] init];

  Pile *p = [PileHelpers getPileOfType:WASTE_PILE inPiles:array];

  if([[[PileHelpers getPileOfType:DECK_PILE inPiles:array] getCardArray] count] == 0) {
    // Move all cards from waste pile to deck
    enumerator = [[p getCardArray] objectEnumerator];

    while(c = [enumerator nextObject]) {
      [[PileHelpers getPileOfType:DECK_PILE inPiles:array] addCard:c];
      [c removeFromParent];
    }
    [[p getCardArray] removeAllObjects];
  }

  for(int i = 0; i < 3; i++) {
    if([[[PileHelpers getPileOfType:DECK_PILE inPiles:array] getCardArray] count] == 0) {
      break;
    }
    c = [[[PileHelpers getPileOfType:DECK_PILE inPiles:array] getCardArray] firstObject];
    [c setName:@"Card"];
    [p addCard:c];
    [[[PileHelpers getPileOfType:DECK_PILE inPiles:array] getCardArray] removeObjectAtIndex:0];
    [deltCards addObject:c];
  }
  [p updatePilePositions];

  return deltCards;
}

+(BOOL)isMoveAllowedFrom:(Pile *)fromPile toPile:(Pile*)toPile
{
  Card *cardFrom = [[fromPile getCardArray] firstObject];
  Card *cardTo = [[toPile getCardArray] lastObject];

  if(cardFrom == NULL) {
    return FALSE;
  }

  if(cardTo == NULL && cardFrom.cardValue == King) {
    return TRUE;
  }

  if((cardFrom.cardColor == Spade || cardFrom.cardColor == Club) &&
     (cardTo.cardColor == Spade || cardTo.cardColor == Club)) {
    return FALSE;
  }


  if((cardFrom.cardColor == Heart || cardFrom.cardColor == Diamond) &&
     (cardTo.cardColor == Heart || cardTo.cardColor == Diamond)) {
    return FALSE;
  }

  if(cardFrom.cardValue != cardTo.cardValue-1) {
    return FALSE;
  }

  return TRUE;
}

+(void)moveCardsFrom:(Pile *)fromPile toPile:(Pile*)toPile
{
  BOOL firstObject = TRUE;
  NSEnumerator *enumerator = [[fromPile getCardArray] objectEnumerator];

  Card *c;
  SKAction *action;
  SKAction *postAnimationCode = [SKAction runBlock:^(void){[PileHelpers calculateZPosition:toPile];}];

  while(c = [enumerator nextObject]) {
    [toPile addCard:c];
    [toPile updatePilePositions];
    if(firstObject) {
      action = [SKAction sequence:[NSArray arrayWithObjects:[SKAction moveTo:[c getCardPosition] duration:0.1], postAnimationCode, nil]];
    } else {
      action = [SKAction moveTo:[c getCardPosition] duration:0.1];
    }
    [c runAction:action];
  }

  [[fromPile getCardArray] removeAllObjects];
  
}

+(Pile*)getAllowedHomePile:(Card*)card inPiles:(NSMutableArray*)array
{
  NSEnumerator *enumerator;

  enumerator = [array objectEnumerator];

  Pile *pile;

  while(pile = [enumerator nextObject]) {
    if([pile getPileType] == HOME_PILE) {
      Card *cardTo = [[pile getCardArray] lastObject];
      if(!cardTo && card.cardValue == Ace) {
        return pile;
      }
      if(cardTo.cardColor == card.cardColor && cardTo.cardValue == (card.cardValue+1)) {
        return pile;
      }
    }
  }
  return NULL;
}


@end
