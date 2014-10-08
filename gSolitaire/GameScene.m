//
//  GameScene.m
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import "GameScene.h"
#import "Pile.h"

/* 
 Z-position info:
 Background: -10
 Pile background: -5
 Cards: 10+1 per card
 Dragged cards: 1000+original
 */

#define Y_OFFSET 30
#define NUMBER_OF_PILES 8
#define NUMBER_OF_TABLEAU_PILES 7
#define NUMBER_OF_DECK_PILES 1
#define NUMBER_OF_WASTE_PILES 1
#define NUMBER_OF_HOME_PILES 4
#define Y_POSITION_PILES 500
#define Y_POSITION_WASTE_PILES 675
#define Y_POSITION_DECK_PILES 675
#define NUMBER_OF_STACK_PILES 4

@implementation GameScene
{
  NSMutableArray *piles;
  Pile *draggedCards;
  CGPoint clickOffset;
  CGPoint originPoint;
  Pile *originPile;
  SKSpriteNode *DeckSprite;
}

- (void)didMoveToView:(SKView *)view {
  piles = [[NSMutableArray alloc] init];

  [self addPiles];
  [self addCardsToDeck];
  [PileHelpers shufflePile:[PileHelpers getPileOfType:DECK_PILE inPiles:piles]];
  [self dealCards];
  [self showDeckBack:TRUE];
  [self addBackground];
}

- (void)showDeckBack:(BOOL)show
{
  if(!DeckSprite) {
    DeckSprite = [[SKSpriteNode alloc] initWithImageNamed:@"back"];
    [DeckSprite setZPosition:0];
    [DeckSprite setPosition:CGPointMake(100, 675)];
    // Why does scale 3 make the sprite 1:1 size???
    [DeckSprite setScale:3];
    [DeckSprite setName:@"Deck"];
  }

  if(show) {
    [self addChild:DeckSprite];
  } else {
    [DeckSprite removeFromParent];
  }
}

- (void)addCardsToDeck {
  Card *c;
  Pile *deckPile = [PileHelpers getPileOfType:DECK_PILE inPiles:piles];
  for(int color = 0; color < 4; color++) {
    for(int value = 0; value < 13; value++) {
      c = [[Card alloc] initWithCard:color andvalue:value];
      [c setPosition:[deckPile getPosition]];
      [c setName:@"Card"];
      [self addCardToScene:c];
      [deckPile addCard:c];
    }
  }
}

- (void)addPiles {
  Pile *p;

  for(int i = 0; i < NUMBER_OF_TABLEAU_PILES; i++) {
    p = [[Pile alloc] initWithPosition:CGPointMake(100+(i*120), Y_POSITION_PILES)];
    [p setPileType:TABLEAU_PILE];
    [piles addObject:p];
    [self addChild:[p getPileBackground]];
  }

  for(int i = 0; i < NUMBER_OF_HOME_PILES; i++) {
    p = [[Pile alloc] initWithPosition:CGPointMake(460+(i*120), Y_POSITION_WASTE_PILES)];
    [p setPileType:HOME_PILE];
    [piles addObject:p];
    [self addChild:[p getPileBackground]];
  }

  for(int i = 0; i < NUMBER_OF_WASTE_PILES; i++) {
    p = [[Pile alloc] initWithPosition:CGPointMake(220+(i*120), Y_POSITION_WASTE_PILES)];
    [p setPileType:WASTE_PILE];
    [piles addObject:p];
    [self addChild:[p getPileBackground]];
  }

  for(int i = 0; i < NUMBER_OF_DECK_PILES; i++) {
    p = [[Pile alloc] initWithPosition:CGPointMake(-100, -100)];
    [p setPileType:DECK_PILE];
    [piles addObject:p];
    [self addChild:[p getPileBackground]];
  }
}

- (void)dealCards {
  BOOL firstCard = TRUE;
  Pile *deckPile = [PileHelpers getPileOfType:DECK_PILE inPiles:piles];
  Pile *p;
  float delay = 0;

  for(int i = 0; i < NUMBER_OF_PILES; i++) {
    firstCard = TRUE;
    NSEnumerator *enumerator = [piles objectEnumerator];

    /* Skip one more tableau pile each row */
    for(int j = 0; j < i; j++) {
      p = [enumerator nextObject];
      while([p getPileType] != TABLEAU_PILE) {
        p = [enumerator nextObject];
      }
    }

    while (p = [enumerator nextObject]) {
      /* Only deal to tableau piles */
      if([p getPileType] != TABLEAU_PILE) {
        continue;
      }
      [PileHelpers moveCardsFrom:1 fromPile:deckPile toPile:p withDelay:delay andDuration:0.2];
      delay += 0.1;

      [(Card*)[[p getCardArray] lastObject] cardTurned:!firstCard];
      firstCard = FALSE;
    }
  }
}

- (void)addBackground {
  SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"wood_background"];
  background.position = CGPointMake([self size].width/2, [self size].height/2);
  background.zPosition = -10;
  [background setName:@"background"];
  [self addChild:background];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
  if (!draggedCards) {
    return;
  }
  CGPoint currentPosition = [theEvent locationInNode:self];
  currentPosition.x -= clickOffset.x;
  currentPosition.y -= clickOffset.y;
  [PileHelpers positionPile:draggedCards at:currentPosition];
}

- (void)addCardToScene:(Card*)card
{
  [self addChild:card];
}

- (void)addCardsToScene:(NSMutableArray*)cards
{
  Card *card;
  NSEnumerator *enumerator = [cards objectEnumerator];

  while (card = [enumerator nextObject]) {
    [self addChild:card];
  }
}

- (void)mouseDown:(NSEvent *)theEvent {
  Card *clicked_card;
  CGPoint clicked_position;

  clicked_position = [theEvent locationInNode:self];

  clicked_card = (Card*)[self nodeAtPoint:clicked_position];
  clickOffset = [theEvent locationInNode:clicked_card];

  if([clicked_card.name isEqualTo: @"Deck"]) {
    NSMutableArray *array = [PileHelpers dealCardsFromDeck:piles];
    [self addCardsToScene:array];
    [array removeAllObjects];

    if([[[PileHelpers getPileOfType:DECK_PILE inPiles:piles] getCardArray] count] == 0) {
      [DeckSprite setAlpha:0.2];
    } else {
      [DeckSprite setAlpha:1];
    }

    return;
  }

  if([[clicked_card name] isNotEqualTo: @"Card"] || clicked_card.turned) {
    draggedCards = NULL;
    return;
  }

  NSEnumerator *enumerator = [piles objectEnumerator];

  Pile *p = [PileHelpers getPileOfType:WASTE_PILE inPiles:piles];

  if([p isCardInPile:clicked_card]) {
    if([[p getCardArray] lastObject] == clicked_card) {
      draggedCards = [p getCardsBelow:clicked_card];
      [draggedCards setPileType:[p getPileType]];
      originPile = p;
    }
    else {
      return;
    }
  } else {
    while(p = [enumerator nextObject]) {
      if([p isCardInPile:clicked_card]) {
        draggedCards = [p getCardsBelow:clicked_card];
        originPile = p;
        break;
      }
    }
  }

  originPoint = [[[draggedCards getCardArray] firstObject] getCardPosition];
  [PileHelpers makePileOnTop:draggedCards];
  [clicked_card print];
}

- (void)mouseUp:(NSEvent *)theEvent
{
  if (!draggedCards) {
    return;
  }

  Card *card = [[draggedCards getCardArray] firstObject];
  Pile *destinationPile = originPile; // If we dont find a suitable home pile, return back where we came from
  CGPoint draggedCardPoint = card.position;

  if([theEvent clickCount] == 2) { // Double click
    if([[draggedCards getCardArray] count] == 1) { // First criteria is that dragged cards is one and only one
      Pile *pt = [PileHelpers getAllowedHomePile:card inPiles:piles];
      if(pt) {
        destinationPile = pt;
      }
    }
  } else { // Single click
    Pile *p = [PileHelpers pileFromLocation:draggedCardPoint andPiles:piles];

    if([PileHelpers isMoveAllowedFrom:draggedCards toPile:p]) {
      destinationPile = p;
    }
  }

  // Send pile either to allowed pile or back where it came from
  [PileHelpers moveCardsFrom:[[draggedCards getCardArray]count] fromPile:draggedCards toPile:destinationPile withDelay:0 andDuration:0.1];

  // Turn card if needed
  if([originPile getPileType] == TABLEAU_PILE && originPile != destinationPile) {
    card = [[originPile getCardArray] lastObject];
    if(card) {
      [card cardTurned:FALSE];
    }
  }

  draggedCards = NULL;
  return;
}

- (void)update:(CFTimeInterval)currentTime {
}

@end
