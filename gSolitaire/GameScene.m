//
//  GameScene.m
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import "GameScene.h"
#import "Pile.h"

#define Y_OFFSET 30
#define NUMBER_OF_PILES 7
#define Y_POSITION_PILES 500
#define NUMBER_OF_STACK_PILES 4

@implementation GameScene
{
  NSMutableArray *deck;
  NSMutableArray *piles;
  NSMutableArray *draggedCards;
  CGPoint clickOffset;
  CGPoint originPoint;
}

- (void)addCardsToDeck {
  Card *c;
  for(int color = 0; color < 4; color++) {
    for(int value = 0; value < 13; value++) {
      c = [[Card alloc] initWithCard:color andvalue:value];
      [c setName:@"Card"];
      [deck addObject:c];
    }
  }
}

- (void)addPiles {
  for(int i = 0; i < NUMBER_OF_PILES; i++) {
    [piles addObject:[[Pile alloc] initWithPosition:CGPointMake(100+(i*120), Y_POSITION_PILES)]];
  }
}

- (void)dealCards {
  SKAction *action;
  SKAction *delay_action;
  SKAction *sequence_action;
  float delay = 0;
  for(int i = 0; i < NUMBER_OF_PILES; i++) {
    NSEnumerator *enumerator = [piles objectEnumerator];
    Pile *p;
    for(int j = 0; j < i; j++) {[enumerator nextObject];}
    while (p = [enumerator nextObject]) {
      Card *c = [deck objectAtIndex:0];
      Card *d = [c copy];

      CGPoint cgp = [p getPosition];

      cgp.y -= i*Y_OFFSET;

      /* TODO: Is this the best way to handle this? */
      d.zPosition = Y_POSITION_PILES-cgp.y;

      [d setCardPosition:CGPointMake(-100,-100)];
      [deck removeObjectAtIndex:0];
      [p addCard:d];
      action = [SKAction moveTo:cgp duration:0.5];
      delay_action = [SKAction waitForDuration:delay];
      SKAction *card_delt_action = [SKAction runBlock:
                                     ^{
                                       [d setCardPosition:d.position];

                                     }];
      sequence_action = [SKAction sequence:[NSArray arrayWithObjects:delay_action, action,card_delt_action, nil]];
      delay += 0.05;
      [d runAction:sequence_action];
    }
  }
}

- (void)addBackground {
  SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"wood_background"];
  background.position = CGPointMake([self size].width/2, [self size].height/2);
  background.zPosition = -1;
  [background setName:@"background"];
  [self addChild:background];
}

-(void)didMoveToView:(SKView *)view {
  deck =  [[NSMutableArray alloc] init];
  piles = [[NSMutableArray alloc] init];

  [self addCardsToDeck];

  for (int x = 0; x < [deck count]; x++) {
    int randInt = (arc4random() % ([deck count] - x)) + x;
    [deck exchangeObjectAtIndex:x withObjectAtIndex:randInt];
  }

  [self addPiles];

  [self dealCards];

  for(Pile *p in piles) {
    for(Card *c in [p getCardArray]) {
      [self addChild:c];
    }
  }

  [self addBackground];
}

-(void)makeStackOnTop:(NSMutableArray*)array
{
  NSEnumerator *enumerator = [array objectEnumerator];

  Card *c;
  while(c = [enumerator nextObject]) {
    c.zPosition += 1000;
  }
}

-(void)restoreZPosition:(NSMutableArray*)array
{
  NSEnumerator *enumerator = [array objectEnumerator];

  Card *c;
  while(c = [enumerator nextObject]) {
    c.zPosition -= 1000;
  }
}

-(void)calculateZPosition:(Pile*)p
{
  NSEnumerator *enumerator = [[p getCardArray] objectEnumerator];

  Card *c;
  int i = 0;

  while(c = [enumerator nextObject]) {
    c.zPosition = Y_POSITION_PILES+(Y_OFFSET*i++);
  }
}

-(Pile *)getPileWithCard:(Card *)c {
  Pile *p;

  NSEnumerator *enumerator = [piles objectEnumerator];

  while(p = [enumerator nextObject]) {
    if([p isCardInPile:c]) {
      return p;
    }
  }

  return NULL;
}

-(void)mouseDragged:(NSEvent *)theEvent
{
  if (!draggedCards) {
    return;
  }
  CGPoint currentPosition = [theEvent locationInNode:self];
  currentPosition.x -= clickOffset.x;
  currentPosition.y -= clickOffset.y;
  [self positionDraggedCards:currentPosition];
}

-(void)mouseDown:(NSEvent *)theEvent {
  Card *clicked_card;
  CGPoint clicked_position;

  clicked_position = [theEvent locationInNode:self];

  clicked_card = (Card*)[self nodeAtPoint:clicked_position];
  clickOffset = [theEvent locationInNode:clicked_card];

  if([[clicked_card name]  isNotEqualTo: @"Card"]) {
    draggedCards = NULL;
    return;
  }

  NSEnumerator *enumerator = [piles objectEnumerator];

  Pile *p;
  while(p = [enumerator nextObject]) {
    if([p isCardInPile:clicked_card]) {
      draggedCards = [p getCardsBelow:clicked_card];
    }
  }

  originPoint = [[draggedCards objectAtIndex:0] getCardPosition];
  [self makeStackOnTop:draggedCards];
  [clicked_card print];
}

-(Pile*)pileFromLocation:(CGPoint) point
{
  Pile *p;
  NSEnumerator *enumerator = [piles objectEnumerator];

  while(p = [enumerator nextObject]) {
    if([p getPosition].x - 50 <= point.x && [p getPosition].x + 50 >= point.x) {
      return p;
    }
  }

  return NULL;
}

-(BOOL)isMoveAllowedFrom:(NSMutableArray *)array toPile:(Pile*)p
{
  return TRUE;
}

-(void)moveCardsFrom:(NSMutableArray *)array toPile:(Pile*)pile
{
  BOOL firstObject = TRUE;
  NSEnumerator *enumerator = [array objectEnumerator];

  Card *c;
  Pile *fromPile = [self getPileWithCard:[array objectAtIndex:0]];
  SKAction *action;
  SKAction *postAnimationCode = [SKAction runBlock:^(void){[self calculateZPosition:pile];}];

  while(c = [enumerator nextObject]) {
    [pile addCard:c];
    if(firstObject) {
      action = [SKAction sequence:[NSArray arrayWithObjects:[SKAction moveTo:[c getCardPosition] duration:0.1], postAnimationCode, nil]];
    } else {
      action = [SKAction moveTo:[c getCardPosition] duration:0.1];
    }
    [c runAction:action];
    [fromPile removeCard:c];
  }
}

-(void)mouseUp:(NSEvent *)theEvent
{
  if (!draggedCards) {
    return;
  }

  // Check if we released card on another pile
  Card *card = [draggedCards lastObject];
  CGPoint point = card.position;
  Pile *p = [self pileFromLocation:point];

  if(p) {
    if([self isMoveAllowedFrom:draggedCards toPile:p]) {
      // Move cards
      [self moveCardsFrom:draggedCards toPile:p];
      draggedCards = NULL;
      return;
    }
  }
}

-(void)positionDraggedCards:(CGPoint)point
{
  NSEnumerator *enumerator = [draggedCards objectEnumerator];

  Card *c;
  while(c = [enumerator nextObject]) {
    c.position = point;
    point.y -= Y_OFFSET;
  }
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
