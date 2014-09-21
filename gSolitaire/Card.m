//
//  Card.m
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import "Card.h"

@implementation Card
{
  enum Color color;
  enum Value value;
}

-(id)init
{
  self = [super init];

  color = Heart;
  value = Two;

  return self;

}

-(id)initWithCard:(enum Color) c: (enum Value) v
{
  self = [super initWithImageNamed:[self getCardString:c :v]];

  if(self) {
    self.scale = 0.25;
    self.position = CGPointMake(100, 100);
  }

  return self;
}

-(void)print
{
  NSLog([self getCardString:color :value]);
}

-(NSString*)getCardString: (enum Color) c: (enum Value)v
{
  NSString *s;

  switch(v)
  {
    case Ace:
      s = @"ace_of_";
      break;
    case Two:
      s = @"2_of_";
      break;
    case Three:
      s = @"3_of_";
      break;
    case Four:
      s = @"4_of_";
      break;
    case Five:
      s = @"5_of_";
      break;
    case Six:
      s = @"6_of_";
      break;
    case Seven:
      s = @"7_of_";
      break;
    case Eight:
      s = @"8_of_";
      break;
    case Nine:
      s = @"9_of_";
      break;
    case Ten:
      s = @"10_of_";
      break;
    case Jack:
      s = @"jack_of_";
      break;
    case Queen:
      s = @"queen_of_";
      break;
    case King:
      s = @"king_of_";
      break;
  }

  switch(c)
  {
    case Heart:
      s = [s stringByAppendingString:@"hearts"];
      break;
    case Diamond:
      s = [s stringByAppendingString:@"diamonds"];
      break;
    case Club:
      s = [s stringByAppendingString:@"clubs"];
      break;
    case Spade:
      s = [s stringByAppendingString:@"spades"];
      break;
  }

  return s;
}

@end
