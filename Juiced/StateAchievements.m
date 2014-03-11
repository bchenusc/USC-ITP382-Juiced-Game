//
//  StateAchievements.m
//  Juiced
//
//  Created by David on 3/8/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "StateAchievements.h"
#import "StateTimeAttackGame.h"
#import "StateSurvivalGame.h"
#import "StateEliminationGame.h"
#import "SimpleAudioEngine.h"

@implementation StateAchievements

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
    }
}

-(void) handleMenuSelection : (Disk*) disk Quadrant : (CornerQuadrant*) quad {
    //Handle collisions here.
    if(quad.color == disk.color) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"paching-sound.mp3"];
        disk.velocity = 0;
        switch (disk.color) {
            case blue:
                [m_manager setGameState:[[StateAchievements alloc] init]];
                 break;
            case red:
                [m_manager setGameState:[[StateTimeAttackGame alloc] init]];
                break;
            case green:
                [m_manager setGameState:[[StateSurvivalGame alloc] init]];
                break;
            case yellow:
                [m_manager setGameState:[[StateEliminationGame alloc] init]];
                break;
            default:
                break;
        }
    }
}

-(void) enter {
    [m_manager clearAllDisks];
    [m_manager spawnFourDisks];
    [m_manager.UI showAchievements];
}

-(void) exit {
    [m_manager clearAllDisks];
    [m_manager.UI hideAchievements];
}

@end
