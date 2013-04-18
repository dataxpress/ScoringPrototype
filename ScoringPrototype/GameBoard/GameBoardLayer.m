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
        
    }
    
    NSLog(@"Tiles are %@",_tiles);
    return self;
}

#pragma mark - touch handling

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Tocuhes are %@",touches);
}


#pragma mark - memory management

-(void)dealloc
{
    [_tiles release];
    [super dealloc];
}



@end
