//
//  GameBoardLayer.m
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright 2013 Tim Gostony. All rights reserved.
//

#import "GameBoardLayer.h"
#import "HelloWorldLayer.h"

#import "Tile.h"

#import "DictionaryLogic.h"

@interface GameBoardLayer ()

@property (nonatomic, retain) CCLabelTTF* turnLabel;
@property (nonatomic, retain) CCLabelTTF* p1scoreLabel;
@property (nonatomic, retain) CCLabelTTF* p2scoreLabel;

@property (nonatomic) ScoringMode scoringMode;

@end

@implementation GameBoardLayer

#pragma mark - scene factory

+(CCScene *) sceneWithScoringMode:(ScoringMode)mode
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameBoardLayer *layer = [[GameBoardLayer alloc] initWithScoringMode:mode];
	
    
	// add layer as a child to scene
	[scene addChild: layer];
	[layer release];
    
	// return the scene
	return scene;
}

#pragma mark - init

-(id)initWithScoringMode:(ScoringMode)scoringMode
{
    if(self = [super init])
    {
        _tiles = [[NSMutableSet alloc] init];
        _stage = [[NSMutableArray alloc] init];
        
        _scoringMode = scoringMode;
        
        // set up tiles
        for(int row=0; row<5; row++)
        {
            for(int col=0; col<5; col++)
            {
                Tile* tile = [[Tile alloc] initWithScoringMode:scoringMode];
                tile.row = row;
                tile.col = col;
                [_tiles addObject:tile];
                [self addChild:tile];
                [tile release];
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
		menu.position = ccp(280,40);
		// Add the menu to the layer
		[self addChild:menu];
        
        
		CCMenuItem *itemBack = [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
			[self back];
		} ];
        
		CCMenu *menu2 = [CCMenu menuWithItems:itemBack, nil];
		menu2.position = ccp(50,550);
		// Add the menu to the layer
		[self addChild:menu2];
        
        _turnLabel = [[CCLabelTTF labelWithString:@"Player 1's turn" fontName:@"Marker Felt" fontSize:24] retain];
        _turnLabel.position = ccp(160, 40);
        [self addChild:_turnLabel];
        
        _p1scoreLabel = [[CCLabelTTF labelWithString:@"P1: 0" fontName:@"Marker Felt" fontSize:24] retain];
        _p1scoreLabel.position = ccp(60, 510);
        _p1scoreLabel.color = (ccColor3B){128,128,255};
        [self addChild:_p1scoreLabel];
        
        _p2scoreLabel = [[CCLabelTTF labelWithString:@"P2: 0" fontName:@"Marker Felt" fontSize:24] retain];
        _p2scoreLabel.position = ccp(260, 510);
        _p2scoreLabel.color = (ccColor3B){255,128,128};
        [self addChild:_p2scoreLabel];
        
        [self updateScores];
        
    }
    
    return self;
}

-(void)back
{
    [[DictionaryLogic sharedDictionaryLogic] reset];
    
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];

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
    [self updateScores];
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
    
    if(word.length == 0)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Blank word" message:@"Enter a word" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    if([[DictionaryLogic sharedDictionaryLogic] isWord:word] == NO)
    {
        // not a word - bail out
        [[[[UIAlertView alloc] initWithTitle:@"Not a word" message:[NSString stringWithFormat:@"%@ is not in my dictionary",[word lowercaseString]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
       return;
    }
    
    if([[DictionaryLogic sharedDictionaryLogic] isWordPlayed:word] == YES)
    {
        // word has been played, bail out
        [[[[UIAlertView alloc] initWithTitle:@"Played" message:[NSString stringWithFormat:@"%@, or a word starting with %@, has been played",[word lowercaseString], [word lowercaseString]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
        
    // play the word
    [[DictionaryLogic sharedDictionaryLogic] playWord:word];
    

    
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
    
    // update scores
    [self updateScores];
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

-(void)updateScores
{
    int player1score = 0;
    int player2score = 0;
    for(Tile* tile in self.tiles)
    {
        int tilePoints = [tile pointsWithScoringMode:self.scoringMode];
        if(tile.mode == TileModeBoard)
        {
            if(tile.owner == 0) player1score += tilePoints;
            if(tile.owner == 1) player2score += tilePoints;
        }
        if(tile.mode == TileModeStaged)
        {
            if(self.playerTurn == 0)
            {
                player1score += tilePoints;
            }
            else
            {
                player2score += tilePoints;
            }
        }
    }
    self.p1scoreLabel.string = [NSString stringWithFormat:@"P1: %d",player1score];
    self.p2scoreLabel.string = [NSString stringWithFormat:@"P2: %d",player2score];

    self.turnLabel.string = [NSString stringWithFormat:@"Player %d's turn",self.playerTurn+1];
    self.turnLabel.color = (self.playerTurn)?(ccColor3B){255,125,125}:(ccColor3B){125,125,255};
}

#pragma mark - Tile finding model

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
