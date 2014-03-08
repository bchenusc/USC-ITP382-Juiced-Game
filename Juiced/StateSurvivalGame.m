//
//  StateSurvivalGame.m
//  Juiced
//
//  Created by Jeffrey on 3/7/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "StateSurvivalGame.h"

@implementation StateSurvivalGame

- (id)init
{
    self = [super init];
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        m_gameTime = 0;
        m_multiplier = 4;
        m_timeScore = 10;
        
        //Set the vertical decrement/increment
        m_decrement = size.height/20;
        m_increment = size.height/8;
        
    }
    return self;
}


- (void) startGame {
    m_gameTime = 0;
    m_multiplier = 4;
    
    [self schedule:@selector(increaseScore) interval:1.0f];
    [self schedule:@selector(shrinkQuadrants) interval:1.0f];
}

- (void) enter {
    [m_manager.UI startAGame];
}

- (void) update:(ccTime)delta {
    
    
}

- (void) shrinkQuadrants {
    //Shrink each quadrant
    for (CornerQuadrant* c in m_manager.quads) {
        if (c.width > 0) {
            c.width -= m_decrement;
        } else {
            c.width += m_decrement;
        }
        if (c.height > 0) {
            c.height -= m_decrement;
        } else {
            c.height += m_decrement;
        }
        
    }
}

- (void) increaseScore {
    //Remember to unschedule when the game ends
    m_manager.score += m_timeScore * m_multiplier;
}

- (void) exit {
    
}

@end
