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

@interface GameBoardLayer ()

@property (nonatomic, retain) CCLabelTTF* turnLabel;

@end

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
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(200, 200, 200, 255)];
        [self addChild:colorLayer z:-1];

        
        [CCMenuItemFont setFontSize:24];
		
		CCMenuItem *itemPlay = [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
			[self playMove];
		} ];
        
		CCMenu *menu = [CCMenu menuWithItems:itemPlay, nil];
		menu.position = ccp(200,500);
		// Add the menu to the layer
		[self addChild:menu];
        
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
            if(tile.state != TileStateLocked || tile.owner == self.playerTurn)
            {
                [self addTileToStage:tile];
            }
            break;
        case TileModeStaged:
            [self removeTileFromStage:tile];
            break;
        default:
            break;
    }
}

#pragma mark - stage management

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
        [tile setStageCount:self.stage.count];
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

#pragma mark - move playing

-(void)playMove
{
    // build the NSString for our word
    NSMutableString* word = [[[NSMutableString alloc] init] autorelease];
    for(Tile* tile in self.stage)
    {
        [word appendString:tile.letter];
    }
    
    // don't allow the move
    if([[DictionaryLogic sharedDictionaryLogic] isWord:word] == NO)
    {
       return;
    }
    
    NSArray* newWord = [self.stage copy];
    
    // set the new tile ownership and state
    for(Tile* tile in newWord)
    {
        tile.owner = self.playerTurn;
        [self removeTileFromStage:tile];
    }
    
    [newWord release];
    
    // switch player turn
    self.playerTurn = (self.playerTurn == 1)?0:1;
    
    // update locked states
    [self updateLockedTiles];
}

-(void)updateLockedTiles
{
    // loop through all tiles
    for(Tile* tile in self.tiles)
    {
        NSSet* neighbors = [self allNeighborsOfTile:tile];
        BOOL locked = YES;
        for(Tile* neighbor in neighbors)
        {
            if(neighbor.owner != tile.owner)
            {
                locked = NO;
            }
        }
        if(locked && tile.owner != -1)
        {
            tile.state = TileStateLocked;
        }
        else if(tile.owner != -1)
        {
            tile.state = TileStateOwned;
        }
        else
        {
            tile.state = TileStateNeutral;
        }
    }
}

-(NSSet*)allNeighborsOfTile:(Tile*)tile
{
    NSMutableSet* neighbors = [[NSMutableSet alloc] init];
    for(int direction=0; direction<4; direction++)
    {
        Tile* neighbor = [self neighborOfTile:tile inDirection:direction];
        if(neighbor != nil)
            [neighbors addObject:neighbor];
    }
    return [neighbors autorelease];
    
}

-(Tile*)neighborOfTile:(Tile*)tile inDirection:(TileDirection)direction
{
    switch(direction)
    {
        case TileDirectionNorth:
            return [self tileAtRow:tile.row-1 andColumn:tile.col];
        case TileDirectionEast:
            return [self tileAtRow:tile.row andColumn:tile.col-1];
        case TileDirectionSouth:
            return [self tileAtRow:tile.row+1 andColumn:tile.col];
        case TileDirectionWest:
            return [self tileAtRow:tile.row andColumn:tile.col+1];
    }
}

-(Tile*)tileAtRow:(int)row andColumn:(int)col
{
    for(Tile* tile in self.tiles)
    {
        if(tile.row == row && tile.col == col)
        {
            return tile;
        }
    }
    return nil;
}


#pragma mark - memory management

-(void)dealloc
{
    [_tiles release];
    [super dealloc];
}



@end
