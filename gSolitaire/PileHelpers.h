//
//  PileHelpers.h
//  gSolitaire
//
//  Created by Björn Hall on 01/10/14.
//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pile.h"

@interface PileHelpers : NSObject

+(void)makePileOnTop:(Pile*)pile;
+(Pile*)getPileOfType:(enum pileType)pt inPiles:(NSMutableArray*)array;
+(Pile *)getPileWithCard:(Card *)c from:(NSMutableArray*)array;
+(void)restoreZPosition:(NSMutableArray*)array;
+(void)calculateZPosition:(Pile*)p;
+(Pile*)pileFromLocation:(CGPoint) point andPiles:(NSMutableArray*)array;
+(void)positionPile:(Pile*)pile at:(CGPoint)point;
+(NSMutableArray*)dealCardsFromDeck:(NSMutableArray*)array;
+(BOOL)isMoveAllowedFrom:(Pile *)fromPile toPile:(Pile*)toPile;
+(void)moveCardsFrom:(NSUInteger)nbrCards fromPile:(Pile *)fromPile toPile:(Pile*)toPile withDelay:(float)delay andDuration:(float)duration;
+(Pile*)getAllowedHomePile:(Card*)card inPiles:(NSMutableArray*)array;
+(void)shufflePile:(Pile*)pile;

@end
