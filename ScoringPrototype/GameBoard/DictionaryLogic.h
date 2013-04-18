//
//  DictionaryLogic.h
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryLogic : NSObject

-(int)pointsForLetter:(NSString*)letter;

+(id)sharedDictionaryLogic;

-(NSString*)randomLetter;

-(BOOL)isWord:(NSString*)word;

@end
