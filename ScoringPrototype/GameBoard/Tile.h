//
//  Tile.h
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright 2013 Tim Gostony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    TileStateNeutral,
    TileStateOwned,
    TileStateLocked
} TileState;

@interface Tile : CCNode {
    
}

@property (nonatomic) int row;
@property (nonatomic) int col;
@property (nonatomic) TileState state;
@property (nonatomic, retain) NSString* letter;

-(int)points;

@end
