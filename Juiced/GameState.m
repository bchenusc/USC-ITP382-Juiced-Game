//
//  GameState.m
//  Juiced
//
//  Created by Matthew Pohlmann on 3/1/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "GameState.h"
#import "GameplayLayer.h"

@implementation GameState

@synthesize manager = m_manager;

-(void) update:(ccTime)delta {
    __MUST_OVERRIDE;
}

-(void) enter {
    __MUST_OVERRIDE;
}

-(void) exit {
    __MUST_OVERRIDE;
}

@end
