//
//  GameState.h
//  Juiced
//
//  Created by Matthew Pohlmann on 3/1/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameplayLayer.h"
#import "CornerQuadrant.h"
#import "Disk.h"

@class GameplayLayer;

@interface GameState : CCNode {
    GameplayLayer* m_manager;
}

@property (assign, readwrite) GameplayLayer* manager;

-(void) update:(ccTime)delta;

-(void) enter;

-(void) exit;

@end
