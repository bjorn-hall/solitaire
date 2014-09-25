//
//  GameScene.h
//  gSolitaire
//

//  Copyright (c) 2014 Björn Hall. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Card.h"

@interface GameScene : SKScene

-(void)positionDraggedCards:(CGPoint)point;
-(void)makeStackOnTop:(NSMutableArray*)array;
-(void)restoreZPosition:(NSMutableArray*)array;

@end
