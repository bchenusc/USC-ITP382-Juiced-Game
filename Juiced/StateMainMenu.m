//
//  StateMainMenu.m
//  Juiced
//
//  Created by Matthew Pohlmann on 3/1/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "StateMainMenu.h"
#import "StateTimeAttackGame.h"

@implementation StateMainMenu

-(void) update:(ccTime)delta {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for(int i = 0; i < m_manager.disks.count; i++) {
        Disk* d = m_manager.disks[i];
        
        // Check if the disc goes to a corner
        CGFloat radius = d.rect.size.width / 2;
        if(d.position.x <= radius || d.position.x >= winSize.width - radius || d.position.y <= radius || d.position.y >= winSize.height - radius) {
            
            // Get the quadrant the disc is at, if there is one
            CornerQuadrant* intersectedCQ = [m_manager getQuadrantAtRect:d.rect];
            if(intersectedCQ != NULL) {
                // Handle menu selection
                [self handleMenuSelection:d Quadrant:intersectedCQ];
            }
        }
        
        /*if (m_manager.disks.count != 0) {
            [d update:delta];
        }*/
    }
}

-(void) handleMenuSelection : (Disk*) disk Quadrant : (CornerQuadrant*) quad{
    //Handle collisions here.
    if(quad.color == disk.color) {
        disk.velocity = 0;
        [m_manager SetGameState:[[StateTimeAttackGame alloc] init]];
    }
}

-(void) enter {
    [m_manager scheduleOnce:@selector(SpawnFourDisks) delay:2.0];
}

-(void) exit {
    [m_manager clearAllDisks];
}

@end
