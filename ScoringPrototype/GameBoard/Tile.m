//
//  Tile.m
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright 2013 Tim Gostony. All rights reserved.
//

#import "Tile.h"

#import "DictionaryLogic.h"

@interface Tile ()

@property (nonatomic, retain) CCSprite* sprite;
@property (nonatomic, retain) CCLabelTTF* label;

@end

@implementation Tile


-(id)init
{
    if(self = [super init])
    {
        _letter = [[[DictionaryLogic sharedDictionaryLogic] randomLetter] retain];
        _owner = -1;
        _state = TileStateNeutral;
        
    
        position_ = ccp(160, 240);
        
        _sprite = [CCSprite spriteWithFile:@"tile.png"];
        [self addChild:_sprite];
        
        _label = [[CCLabelTTF labelWithString:_letter fontName:@"Marker Felt" fontSize:32] retain];
        _label.color = ccBLACK;
        [self addChild:_label];
        
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [self scheduleUpdate];
}

-(int)points
{
    return [[DictionaryLogic sharedDictionaryLogic] pointsForLetter:self.letter];
}

#pragma mark - debug values
-(NSString*)description
{
	return [NSString stringWithFormat:@"<Tile = %p | \t%@ \trow: %d \tcol: %d \tstate: %@ \towner: %d>", self,self.letter,self.row,self.col, [self stateDebugDescription], self.owner ];
}
-(NSString*)stateDebugDescription
{
    switch(self.state)
    {
        case TileStateLocked:
            return @"locked";
        case TileStateNeutral:
            return @"neutral";
        case TileStateOwned:
            return @"owned";
    }
}



-(void)update:(ccTime)delta
{
    CGPoint destination;
    
    // move into position
    switch (self.mode) {
        case TileModeBoard:
            destination = ccp(32 + self.col * 64, 80 + 32 + self.row * 64);
            break;
        case TileModeDragging:
            break;
        case TileModeStaged:
            
        default:
            break;
    }
    

    CGPoint velocity = ccpMult(ccpSub(destination, self.position), 0.1);
    
    if(ccpLengthSQ(velocity) > 10*10)
        velocity = ccpMult(ccpNormalize(velocity), 10);
    
    self.position = ccpAdd(self.position, velocity);
    
        
}


@end
