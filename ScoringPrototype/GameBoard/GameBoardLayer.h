//
//  GameBoardLayer.h
//  ScoringPrototype
//
//  Created by Tim Gostony on 4/17/13.
//  Copyright 2013 Tim Gostony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameBoardLayer : CCLayer {
    
}

@property (nonatomic, retain) NSMutableSet* tiles;

@property (nonatomic, retain) NSMutableArray* stage;
+(CCScene*)scene;

@end
