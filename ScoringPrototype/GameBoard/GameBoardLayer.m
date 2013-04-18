//
//  GameBoardLayer.m
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright 2013 Tim Gostony. All rights reserved.
//

#import "GameBoardLayer.h"

#import "Tile.h"

#import "DictionaryLogic.h"

@implementation GameBoardLayer

#pragma mark - scene factory

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameBoardLayer *layer = [GameBoardLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#pragma mark - init

-(id)init
{
    if(self = [super init])
    {
        _tiles = [[NSMutableSet alloc] init];
        _stage = [[NSMutableArray alloc] init];
        
        // set up tiles
        for(int row=0; row<5; row++)
        {
            for(int col=0; col<5; col++)
            {
                Tile* tile = [Tile node];
                tile.row = row;
                tile.col = col;
                [_tiles addObject:tile];
                [self addChild:tile];
            }
            
        }
        
        self.touchEnabled = YES;
        
    }
    
    NSLog(@"Tiles are %@",_tiles);
    return self;
}

#pragma mark - touch handling

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        CGPoint location = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
        NSLog(@"Location of touch is %@",NSStringFromCGPoint(location));
        for(Tile* tile in self.tiles)
        {
            if(CGRectContainsPoint(tile.rect, location))
            {
                [self tileTapped:tile];
                return;
            }
        }
    }
}

-(void)tileTapped:(Tile*)tile
{
    
    switch(tile.mode)
    {
        case TileModeBoard:
            [self addTileToStage:tile];
            break;
        case TileModeStaged:
            [self removeTileFromStage:tile];
            break;
        default:
            break;
    }
}

-(void)addTileToStage:(Tile*)tile
{
    tile.zOrder = 10;
    tile.mode = TileModeStaged;
    [self.stage addObject:tile];
    [self updateStageOrder];
}

-(void)updateStageOrder
{
    for(int i=0; i<self.stage.count; i++)
    {
        Tile* tile = [self.stage objectAtIndex:i];
        tile.order = i;
    }
}

-(void)removeTileFromStage:(Tile*)tile
{
    tile.zOrder = 9;
    if([self.stage containsObject:tile])
    {
        [self.stage removeObject:tile];
        [self updateStageOrder];
    }
    tile.mode = TileModeBoard;
}


#pragma mark - memory management

-(void)dealloc
{
    [_tiles release];
    [super dealloc];
}



@end
