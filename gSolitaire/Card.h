//
//  Card.h
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

enum Color {Heart, Diamond, Club, Spade};
enum Value {Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King};

@interface Card : SKSpriteNode

-(id)initWithCard:(enum Color) c: (enum Value) v;
-(NSString*)getCardString: (enum Color) c: (enum Value)v;
-(void)print;

@end
