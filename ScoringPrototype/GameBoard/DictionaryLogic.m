//
//  DictionaryLogic.m
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "DictionaryLogic.h"

@implementation DictionaryLogic

+(id)sharedDictionaryLogic
{
    static DictionaryLogic* sharedDictionaryLogic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDictionaryLogic = [[DictionaryLogic alloc] init];
    });
    return sharedDictionaryLogic;
}

-(NSDictionary*)pointsDictionary
{
    static NSDictionary* pointsDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"L",@(1),@"S",@(1),@"U",@(1),@"N",@(1),@"R",@(1),@"T",@(1),@"O",@(1),@"A",@(1),@"I",@(1),@"E",@(1),@"G",@(2),@"D",@(2),@"B",@(3),@"C",@(3),@"M",@(3),@"P",@(3),@"F",@(4),@"H",@(4),@"V",@(4),@"W",@(4),@"Y",@(4),@"K",@(5),@"J",@(8),@"X",@(8),@"Z",@(10),@"Q",@(10),nil];
    });
    return pointsDictionary;
}

-(int)pointsForLetter:(NSString*)letter
{
    return [[[self pointsDictionary] objectForKey:letter] intValue];
}

@end
