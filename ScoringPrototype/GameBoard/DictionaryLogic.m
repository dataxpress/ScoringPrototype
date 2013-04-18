//
//  DictionaryLogic.m
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "DictionaryLogic.h"

@interface DictionaryLogic ()

@property (nonatomic, retain) NSMutableSet* playedWords;
@property (nonatomic, retain) NSArray* allWords;

@end

@implementation DictionaryLogic

#pragma mark - set up

+(id)sharedDictionaryLogic
{
    static DictionaryLogic* sharedDictionaryLogic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDictionaryLogic = [[DictionaryLogic alloc] init];
    });
    return sharedDictionaryLogic;
}

-(id)init
{
    if(self = [super init])
    {
        _playedWords = [[NSMutableSet alloc] init];
    }
    return self;
}

-(void)setupDictionary
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"master_dictionary" ofType:@"txt"];
    NSString* dict = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (dict) {
        // do something useful
        self.allWords = [dict componentsSeparatedByString:@"\r\n"];
    }
}

#pragma mark - score handling

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

#pragma mark - content generation

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

#pragma mark - word playing history

-(BOOL)isWord:(NSString *)word
{
    // lazy load the dictionary
    if(self.allWords == nil)
    {
        [self setupDictionary];
    }
    
    return [self.allWords containsObject:[word lowercaseString]];
    
}

-(BOOL)isWordPlayed:(NSString *)word
{
    // find out if any word has been played which contains this word
    for(NSString* playedWord in self.playedWords)
    {
        if([playedWord hasPrefix:word])
        {
            return YES;
        }
    }
    return NO;
}

-(void)playWord:(NSString *)word
{
    [self.playedWords addObject:word];
}

@end
