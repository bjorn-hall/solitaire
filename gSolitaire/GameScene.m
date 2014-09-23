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
    [piles addObject:[[Pile alloc] initWithPosition:CGPointMake(100+(i*140), 600)]];
  }
}

- (void)dealCards {
  for(Pile *p in piles) {
    Card *c = [deck objectAtIndex:0];
    Card *d = [c copy];
    [d setPosition:[p getPosition]];
    [deck removeObjectAtIndex:0];
    [p addCard:d ];
  }
}

-(void)didMoveToView:(SKView *)view {
  /* Setup your scene here */

  deck =  [[NSMutableArray alloc] init];
  piles = [[NSMutableArray alloc] init];

  [self addCardsToDeck];

  [self addPiles];

  [self dealCards];

  for(Pile *p in piles) {
    for(Card *c in [p getCardArray]) {
      [self addChild:c];
      break;
    }
  }
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
  Card *clicked_card;
  CGPoint clicked_position;

  clicked_position = [theEvent locationInNode:self];

  clicked_card = [self nodeAtPoint:clicked_position];

  [clicked_card print];

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
