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
@property (nonatomic, retain) CCLabelTTF* scoreLabel;

@property (nonatomic) int stageCount;

@end

@implementation Tile


-(id)initWithScoringMode:(ScoringMode)scoringMode
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
        
        
        int points = [self pointsWithScoringMode:scoringMode] ;
        if(points > 1){
            _scoreLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",points] fontName:@"Marker Felt" fontSize:16] retain];
           _scoreLabel.position = ccp(16, -16);
           _scoreLabel.color = ccBLACK;
           [self addChild:_scoreLabel];
       }
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [self scheduleUpdate];
}

-(int)pointsWithScoringMode:(ScoringMode)mode
{
    switch(mode)
    {
        case ScoringModeOnes:
            return 1;
        case ScoringModeScrabble:
            return [[DictionaryLogic sharedDictionaryLogic] pointsForLetter:self.letter];
        default:
            return 0;
    }
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
    float destScale = 1.0f;
    
    // move into position
    switch (self.mode) {
        case TileModeBoard:
            destination = ccp(32 + self.col * 64, 75 + 32 + self.row * 64);;

            break;
        case TileModeDragging:
            break;
        case TileModeStaged:
            if(self.stageCount > 5)
            {
                destScale = 320.0f / (64.0f * self.stageCount);
                
            }
            destination = ccp((self.scale * 32.0f) + self.order * (64*self.scale), 450);
        default:
            break;
    }
    
    self.scale += (destScale - self.scale) / 5.0f;

    CGPoint velocity = ccpMult(ccpSub(destination, self.position), 0.25);
    
#define MAXSPEED 18.0f
    
    if(ccpLengthSQ(velocity) > MAXSPEED * MAXSPEED)
        velocity = ccpMult(ccpNormalize(velocity), MAXSPEED);
    
    
    self.position = ccpAdd(self.position, velocity);
    
}

-(void)setState:(TileState)state
{
    _state = state;
    [self updateTileColor];
}

-(void)setOwner:(int)owner
{
    _owner = owner;
    [self updateTileColor];
}

-(void)updateTileColor
{
    ccColor3B color = ccWHITE;
    switch(self.state)
    {
        case TileStateLocked:
            color = (self.owner == 1)?ccRED:ccBLUE;
            break;
        case TileStateOwned:
            color = (self.owner == 1)?(ccColor3B){255,125,125}:(ccColor3B){125,125,255};
            break;
        default:
            break;
    }
    self.sprite.color = color;
}

-(CGRect)rect
{
    return CGRectMake(position_.x-32, position_.y-32, 64, 64);
}


@end
