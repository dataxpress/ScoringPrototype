//
//  Tile.m
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright 2013 Tim Gostony. All rights reserved.
//

#import "Tile.h"

#import "DictionaryLogic.h"

@implementation Tile



-(int)points
{
    return [[DictionaryLogic sharedDictionaryLogic] pointsForLetter:self.letter];
}

@end
