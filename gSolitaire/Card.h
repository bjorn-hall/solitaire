//
//  Card.h
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

enum Color {Heart=0, Diamond, Club, Spade};
enum Value {Ace=0, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King};

@interface Card : SKSpriteNode
{
  enum Color cardColor;
  enum Value cardValue;
  CGPoint pos;
}

@property (readwrite) enum Color cardColor;
@property (readwrite) enum Value cardValue;

-(id)initWithCard:(enum Color)c andvalue:(enum Value)v;
-(NSString*)getCardString:(enum Color)c andvalue:(enum Value)v;
-(void)print;
-(void)setCardPosition:(CGPoint) p;
-(CGPoint)getCardPosition;

@end
