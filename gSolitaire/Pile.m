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
