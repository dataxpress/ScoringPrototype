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
        pointsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@(1),@"S",@(1),@"U",@(1),@"N",@(1),@"R",@(1),@"T",@(1),@"O",@(1),@"A",@(1),@"I",@(1),@"E",@(1),@"L",@(2),@"G",@(2),@"D",@(3),@"B",@(3),@"C",@(3),@"M",@(3),@"P",@(4),@"F",@(4),@"H",@(4),@"V",@(4),@"W",@(4),@"Y",@(5),@"K",@(8),@"J",@(8),@"X",@(10),@"Z",@(10),@"Q",nil];
        NSLog(@"Made points dictionary: %@",pointsDictionary);
    });
    return pointsDictionary;
}

-(int)pointsForLetter:(NSString*)letter
{
    return [[[self pointsDictionary] objectForKey:letter] intValue];
}

-(NSString*)randomLetter
{
    static NSMutableArray* letterbag;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        letterbag = [[NSMutableArray alloc] init];
        NSDictionary* frequencyDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@(4),@"S",@(4),@"U",@(6),@"N",@(6),@"R",@(6),@"T",@(8),@"O",@(9),@"A",@(9),@"I",@(12),@"E",@(4),@"L",@(3),@"G",@(4),@"D",@(2),@"B",@(2),@"C",@(2),@"M",@(2),@"P",@(2),@"F",@(2),@"H",@(2),@"V",@(2),@"W",@(2),@"Y",@(1),@"K",@(1),@"J",@(1),@"X",@(1),@"Z",@(1),@"Q",nil];
        for(NSString* letter in frequencyDictionary)
        {
            int occurrences = [[frequencyDictionary objectForKey:letter] intValue];
            for(int i=0; i<occurrences; i++)
            {
                [letterbag addObject:letter];
            }
        }
        
    });
    int index = arc4random()%letterbag.count;
    return letterbag[index];
}

-(BOOL)isWord:(NSString *)word
{
    return YES;
}

@end
