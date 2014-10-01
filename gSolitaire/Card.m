//
//  Card.m
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize cardColor;
@synthesize cardValue;
@synthesize turned;
@synthesize cardFrontTexture;
@synthesize cardBackTexture;

-(void)setCardPosition:(CGPoint) p
{
  pos.x = p.x;
  pos.y = p.y;
//  self.position = p;
}

-(id)copyWithZone:(NSZone *)zone
{
  Card *c = [super copyWithZone:zone];
  //c = [[Card alloc] initWithCard:self.color andvalue:self.value];
  c.cardColor = self.cardColor;
  c.cardValue = self.cardValue;
  c.position = self.position;
  [c setCardPosition:[self getCardPosition]];

  return c;
}

-(CGPoint)getCardPosition
{
  return pos;
}

-(void)cardTurned:(BOOL) t
{
  self.turned = t;
  if(t) {
    [super setTexture:cardBackTexture];
  } else {
    [super setTexture:cardFrontTexture];
  }
}

-(id)initWithCard:(enum Color)c andvalue:(enum Value)v
{
  NSString *ns = [self getCardString:c andvalue:v];
  self.cardFrontTexture = [SKTexture textureWithImageNamed:ns];
  self.cardBackTexture = [SKTexture textureWithImageNamed:@"back"];

  self = [super initWithTexture:cardFrontTexture];

  if(self) {
    self.name = ns;
    self.scale = 1;
    cardColor = c;
    cardValue = v;
    self.turned = FALSE;
  }

  return self;
}

-(void)print
{
  NSString *string = [self getCardString:cardColor andvalue:cardValue];
  NSLog(@"%@", string);
}

-(NSString*)getCardString:(enum Color)c andvalue:(enum Value)v
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
    default:
      NSLog(@"Unknown card value");
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
    default:
      NSLog(@"Unknown card color");
      break;
  }

  return s;
}

@end
