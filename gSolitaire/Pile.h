//
//  Pile.h
//  gSolitaire
//
//  Created by Björn Hall on 21/09/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

enum pileType {
  TABLEAU_PILE,
  DECK_PILE,
  WASTE_PILE,
  HOME_PILE
};

@interface Pile : NSObject

-(void)addCard:(Card*)c;
-(void)removeCard:(Card*)c;
-(id)initWithPosition:(CGPoint) p;
-(void)setPilePosition:(CGPoint)p;
-(NSMutableArray*)getCardArray;
-(CGPoint)getPosition;
-(BOOL)isCardInPile:(Card*)c;
-(Pile*)getCardsBelow:(Card*)c;
-(void)setPileType:(enum pileType)pt;
-(enum pileType)getPileType;
-(void)updatePilePositions;

@end
