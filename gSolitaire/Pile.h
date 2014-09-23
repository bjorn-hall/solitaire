//
//  Pile.h
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Pile : NSObject

-(void)addCard:(Card*)c;
-(id)initWithPosition:(CGPoint) p;
-(NSMutableArray*)getCardArray;
-(CGPoint)getPosition;

@end