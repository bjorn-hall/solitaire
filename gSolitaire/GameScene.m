//
//  GameScene.m
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
{
  NSMutableArray *deck;
}

- (void)addCardsToDeck {
  for(int color = 0; color < 4; color++) {
    for(int value = 0; value < 13; value++) {
      [deck addObject:[[Card alloc] initWithCard:color:value]];
    }
  }
}

-(void)didMoveToView:(SKView *)view {
  /* Setup your scene here */

  deck = [[NSMutableArray alloc] init];

  [self addCardsToDeck];

  Card *c = deck[0];

  [self addChild:c];
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
