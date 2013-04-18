//
//  GameBoardLayer.h
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright 2013 Tim Gostony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Enums.h"

typedef enum
{
    TileDirectionNorth,
    TileDirectionEast,
    TileDirectionWest,
    TileDirectionSouth
} TileDirection;


@interface GameBoardLayer : CCLayer {
    
}
@property (nonatomic) ScoringMode scoringMode;

@property (nonatomic, retain) NSMutableSet* tiles;

@property (nonatomic, retain) NSMutableArray* stage;
+(CCScene*)sceneWithScoringMode:(ScoringMode)scoringMode;

@property (nonatomic) int playerTurn;

@end
