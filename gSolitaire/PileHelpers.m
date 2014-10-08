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

  [p updateCardPositionsInPile];

  enumerator = [[p getCardArray] objectEnumerator];

  while(c = [enumerator nextObject]) {
    [c setPosition:[c getCardPosition]];
  }

  return deltCards;
}

+(BOOL)isMoveAllowedFrom:(Pile *)fromPile toPile:(Pile*)toPile
{
  Card *cardFrom = [[fromPile getCardArray] firstObject];
  Card *cardTo = [[toPile getCardArray] lastObject];

  if(cardFrom == NULL) {
    return FALSE;
  }

  if([toPile getPileType] == TABLEAU_PILE) {
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
  } else if([toPile getPileType] == HOME_PILE) {
    if([[toPile getCardArray] count] == 0) {
      return TRUE;
    }
    if(cardFrom.cardColor != cardTo.cardColor) {
      return FALSE;
    }
    if(cardFrom.cardValue != (cardTo.cardValue+1)) {
      return FALSE;
    }
  } else {
    return FALSE;
  }

  return TRUE;
}

+(void)moveCardsFrom:(NSUInteger)nbrCards fromPile:(Pile *)fromPile toPile:(Pile*)toPile withDelay:(float)delay andDuration:(float)duration
{
  BOOL firstObject = TRUE;
  NSEnumerator *enumerator = [[fromPile getCardArray] objectEnumerator];

  NSUInteger startPos = [[fromPile getCardArray] count] - nbrCards;

  Card *c;
  SKAction *action;
  SKAction *postAnimationCode = [SKAction runBlock:^(void){[PileHelpers calculateZPosition:toPile];NSLog(@"Done!");}];

  while(c = [enumerator nextObject]) {
    if(startPos) {
      startPos--;
      continue;
    }
    [toPile addCard:c];
    [toPile updateCardPositionsInPile];
    if(firstObject) {
      action = [SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:delay], [SKAction moveTo:[c getCardPosition] duration:duration], postAnimationCode, nil]];
    } else {
      action = [SKAction moveTo:[c getCardPosition] duration:duration];
    }
    [c runAction:action];
  }

  startPos = [[fromPile getCardArray] count] - nbrCards;
  enumerator = [[fromPile getCardArray] objectEnumerator];

  while(c = [enumerator nextObject]) {
    if(startPos) {
      startPos--;
      continue;
    }

    [[fromPile getCardArray] removeObject:c];
  }
}

/* When double clicking we need to find a suitable home pile */
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
      if(cardTo.cardColor == card.cardColor && (cardTo.cardValue+1) == card.cardValue) {
        return pile;
      }
    }
  }
  return NULL;
}

+(void)shufflePile:(Pile*)pile
{
  for (int x = 0; x < [[pile getCardArray] count]; x++) {
    int randInt = (arc4random() % ([[pile getCardArray] count] - x)) + x;
    [[pile getCardArray] exchangeObjectAtIndex:x withObjectAtIndex:randInt];
  }
}


@end
