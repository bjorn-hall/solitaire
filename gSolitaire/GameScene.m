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
  for(int color = 0; color < 4; color++) {
    for(int value = 0; value < 13; value++) {
      [deck addObject:[[Card alloc] initWithCard:color andvalue:value]];
    }
  }
}

- (void)addPiles {
  for(int i = 0; i < NUMBER_OF_PILES; i++) {
    [piles addObject:[[Pile alloc] initWithPosition:CGPointMake(100+(i*120), Y_POSITION_PILES)]];
  }
}

- (void)dealCards {
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

      [d setCardPosition:cgp];
      [deck removeObjectAtIndex:0];
      [p addCard:d];
    }
  }
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

-(void)mouseUp:(NSEvent *)theEvent
{
  NSEnumerator *enumerator = [draggedCards objectEnumerator];
  Card *c;

  SKAction *fixZOrderWhenDone = [SKAction runBlock:
  ^{
    Pile *p;
    NSLog(@"Done!");

    p = [self getPileWithCard:[draggedCards objectAtIndex:0]];
    [self calculateZPosition:p];
  }];

  SKAction *sequence = [SKAction sequence:[NSArray arrayWithObjects:[SKAction moveTo:originPoint duration:0.1], fixZOrderWhenDone, nil]];

  while(c = [enumerator nextObject]) {
    [c runAction:sequence];
    originPoint.y -= Y_OFFSET;
    sequence = [SKAction moveTo:originPoint duration:0.1];
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
  [self makeStackOnTop:draggedCards];
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
