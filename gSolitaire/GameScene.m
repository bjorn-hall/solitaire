//
//  GameScene.m
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import "GameScene.h"
#import "Pile.h"

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
  for(int i = 0; i < 7; i++) {
    [piles addObject:[[Pile alloc] initWithPosition:CGPointMake(100+(i*120), 600)]];
  }
}

- (void)dealCards {
  for(int i = 0; i < 7; i++) {
    NSEnumerator *enumerator = [piles objectEnumerator];
    Pile *p;
    for(int j = 0; j < i; j++) {[enumerator nextObject];}
    while (p = [enumerator nextObject]) {
      Card *c = [deck objectAtIndex:0];
      Card *d = [c copy];

      CGPoint cgp = [p getPosition];

      cgp.y -= i*30;

      /* TODO: Is this the best way to handle this? */
      d.zPosition = 600-cgp.y;

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
  [self positionDraggedCards:originPoint];
  draggedCards = NULL;
}

-(void)positionDraggedCards:(CGPoint)point
{
  NSEnumerator *enumerator = [draggedCards objectEnumerator];

  Card *c;
  while(c = [enumerator nextObject]) {
    c.position = point;
    point.y -= 30;
  }
  [self makeStackOnTop:draggedCards];
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
