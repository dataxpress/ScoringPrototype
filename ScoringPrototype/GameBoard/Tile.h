//
//  Tile.h
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright 2013 Tim Gostony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


#import "Enums.h"

typedef enum {
    TileStateNeutral,
    TileStateOwned,
    TileStateLocked
} TileState;

typedef enum {
    TileModeBoard,
    TileModeDragging,
    TileModeStaged
} TileMode;

@interface Tile : CCNode {
    
}

@property (nonatomic) int row;
@property (nonatomic) int col;
@property (nonatomic) TileState state;
@property (nonatomic) TileMode mode;
@property (nonatomic, retain) NSString* letter;
@property (nonatomic) int owner;
@property (nonatomic) int order;

@property (nonatomic, readonly) CGRect rect;

-(void)setStageCount:(int)stageCount;

-(int)pointsWithScoringMode:(ScoringMode)scoringMode;

-(id)initWithScoringMode:(ScoringMode)scoringMode;


@end
