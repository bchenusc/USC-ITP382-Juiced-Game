//
//  StateSurvivalGame.m
//  Juiced
//
//  Created by Jeffrey on 3/7/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "StateSurvivalGame.h"
#import "SimpleAudioEngine.h"

@implementation StateSurvivalGame

- (id)init
{
    self = [super init];
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        m_gameTime = 0;
        m_multiplier = 4;
        m_discScore = 1;
        m_timeScore = 10;
        
        //Set the vertical decrement/increment
        m_decrement = size.height/20;
        m_increment = size.height/8;
        
        m_maxWidth = size.width/4;
        m_maxHeight = size.height/2;
        
    }
    return self;
}


- (void) startGame {
    m_gameTime = 0;
    m_multiplier = 4;
    
    for (CornerQuadrant* cq in m_manager.quads) {
        if (cq.width > 0) {
            cq.width = m_maxWidth;
        } else {
            cq.width = -m_maxWidth;
        }
        if (cq.height > 0) {
            cq.height = m_maxHeight;
        } else {
            cq.height = -m_maxHeight;
        }
    }
    
    [self schedule:@selector(increaseScore) interval:1.0f];
    [self schedule:@selector(shrinkQuadrants) interval:1.0f];
    [self createDisks];
}

- (void) enter {
    [m_manager.UI startAGame];
}

- (void) update:(ccTime)delta {
    //Cannibalized from Time Attack
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for(int i = 0; i < m_manager.disks.count; i++) {
        Disk* d = m_manager.disks[i];
        
        // Check if the disc goes to a corner
        CGFloat radius = d.rect.size.width / 2 * 1.1;
        if(d.position.x <= radius || d.position.x >= winSize.width - radius || d.position.y <= radius || d.position.y >= winSize.height - radius) {
            
            // Get the quadrant the disc is at, if there is one
            CornerQuadrant* intersectedCQ = [m_manager getQuadrantAtRect:d.rect];
            if(intersectedCQ != NULL) {
                // Check if the colors are the same
                if(intersectedCQ.color == d.color) {
                    [m_manager scoreParticlesAtLocation:d.position];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"score_goal.mp3"];
                    
                    // Scoring stuff
                    [self growQuadrants:intersectedCQ];
                    m_manager.score += m_discScore;
                    
                } else { // Wrong color quadrant
                    [self shrinkSpecificQuadrant:intersectedCQ];
                }
                
                [m_manager removeDisk:d retainVelocity:NO];
                d = NULL;
                [m_manager.UI showScoreLabel:m_manager.score];
                i--;
            }
        }
    }
}

- (void) shrinkSpecificQuadrant: (CornerQuadrant*) cq {
    if (cq.width > 0) {
        cq.width -= m_decrement;
        if (cq.width < 0) {
            cq.width = 0; //Zero out the quadrant size
        }
    } else {
        cq.width += m_decrement;
        if (cq.width > 0) {
            cq.width = 0;
        }
    }
    if (cq.height > 0) {
        cq.height -= m_decrement;
        if (cq.height < 0) {
            cq.height = 0;
        }
    } else {
        cq.height += m_decrement;
        if (cq.height > 0) {
            cq.height = 0;
        }
    }
}

- (void) shrinkQuadrants {
    int im_multiiplier = 4;
    //Shrink each quadrant
    for (CornerQuadrant* c in m_manager.quads) {
        //Shrink the quadrant
        if (c.width > 0) {
            c.width -= m_decrement;
            if (c.width < 0) {
                c.width = 0; //Zero out the quadrant size
            }
        } else {
            c.width += m_decrement;
            if (c.width > 0) {
                c.width = 0;
            }
        }
        if (c.height > 0) {
            c.height -= m_decrement;
            if (c.height < 0) {
                c.height = 0;
            }
        } else {
            c.height += m_decrement;
            if (c.height > 0) {
                c.height = 0;
            }
        }
        //Manage the quadrant score multiplier
        if (c.height == 0 && c.width == 0) {
            im_multiiplier--;
        }
    }
    [m_manager.UI showScoreLabel:m_manager.score];
    m_multiplier = im_multiiplier;
    
    if (im_multiiplier == 0) {
        [self unschedule:@selector(shrinkQuadrants)];
        [self gameOver];
    }
}

- (void) growQuadrants:(CornerQuadrant*) quad {
    if (quad.width > 0) {
        quad.width += m_increment;
    } else {
        quad.width -= m_increment;
    }
    if (quad.height > 0) {
        quad.height += m_increment;
    } else {
        quad.height -= m_increment;
    }
    //Reset if over the max
    if (quad.width > m_maxWidth) {
        quad.width = m_maxWidth;
    } else if (quad.width < -m_maxWidth) {
        quad.width = -m_maxWidth;
    }
    if (quad.height > m_maxHeight) {
        quad.height = m_maxHeight;
    } else if (quad.height < -m_maxHeight) {
        quad.height = -m_maxHeight;
    }
}

-(void) createDisks {
    int timesToSpawnDisk = arc4random() % (m_gameTime / 5 + 1) + 2;
    for(int i = 0; i < timesToSpawnDisk; i++) {
        [m_manager spawnDiskAtRandomLocation];
    }
    [self unschedule:@selector(createDisks)];
    [self schedule:@selector(createDisks) interval:0.5f + .5f / (m_gameTime / 5 + 1)];
    [self deleteOverflowDisks];
}

-(void) deleteOverflowDisks {
    // Always move selected disks to the back of the objects list so they won't be deleted
    for (int i = m_manager.disks.count - 1; i >= 0; i--) {
        Disk* d = [m_manager.disks objectAtIndex:i];
        
        if (d.isSelected) {
            [m_manager.disks removeObjectAtIndex:i];
            [m_manager.disks addObject:d];
        }
    }
    
    // Delete overflow
    while(m_manager.disks.count > 10) {
        [m_manager removeDisk:[m_manager.disks objectAtIndex:0] retainVelocity: YES];
    }
}

- (void) increaseScore {
    //Remember to unschedule when the game ends
    m_manager.score += m_timeScore * m_multiplier;
    m_gameTime++;
}

- (void) gameOver {
    [self unschedule:@selector(createDisks)];
    [self unschedule:@selector(increaseScore)];
    
    [m_manager setGameState:[[StateMainMenu alloc] init]];
    
//    NSMutableArray* achievementValues = [NSMutableArray arrayWithObjects:
//                                         [NSNumber numberWithInt:i_DisksDestroyed],
//                                         [NSNumber numberWithInt:m_manager.score],
//                                         [NSNumber numberWithInt:0],
//                                         [NSNumber numberWithInt:0],
//                                         nil];
//    [m_manager setAchievementValues:achievementValues];
}

- (void) exit {
    [m_manager clearAllDisks];
    [m_manager.UI showScoreLabel:m_manager.score];
    [m_manager.UI showGameOver];
}

@end
