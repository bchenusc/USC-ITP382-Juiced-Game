//
//  StateTimeAttackGame.m
//  Juiced
//
//  Created by Matthew Pohlmann on 3/1/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "StateTimeAttackGame.h"
#import "SimpleAudioEngine.h"

@implementation StateTimeAttackGame

- (id)init
{
    self = [super init];
    if (self) {
        // Scoring Variables
        i_DiskScore = 100;
        i_DiskComboMultiplier = 1;
        i_Time = 0;
    }
    return self;
}

-(void) startGame {
    m_manager.score = 0;
    i_DiskComboMultiplier = 1;
    i_Time = 60;
    [self schedule:@selector(timeDecrease) interval:1.0f];
    [m_manager.UI showScoreLabel: m_manager.score];
    [m_manager.UI showTimeLabel: i_Time];
    [self schedule:@selector(createDisks) interval:1];
    [m_manager scheduleOnce:@selector(blinkQuadrants) delay:8];
}

-(void) gameOver{
    [self unschedule:@selector(createDisks)];
    [m_manager unschedule:@selector(blinkQuadrants)];
    [m_manager unschedule:@selector(changeColorOfAllQuadrants)];
    
    [m_manager clearAllDisks];
    
    [m_manager.UI showGameOver];
    
    [m_manager SetGameState:[[StateMainMenu alloc] init]];
}

-(void) update:(ccTime)delta {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for(int i = 0; i < m_manager.disks.count; i++) {
        Disk* d = m_manager.disks[i];
        
        // Check if the disc goes to a corner
        CGFloat radius = d.rect.size.width / 2 * 1.1;
        if(d.position.x <= radius || d.position.x >= winSize.width - radius || d.position.y <= radius || d.position.y >= winSize.height - radius) {
            
            // Get the quadrant the disc is at, if there is one
            CornerQuadrant* intersectedCQ = [m_manager getQuadrantAtRect:d.rect];
            if(intersectedCQ != NULL) {
                // Check if the colors are the same, remove the disc if they are
                if(intersectedCQ.color == d.color) {
                    [m_manager scoreParticlesAtLocation:d.position];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"score_goal.mp3"];
                    // If it's the selected sprite, make sure to set it to null or bad things will happen
                    if(d == m_manager.selectedDisk) {
                        [m_manager clearSelectedDisk];
                    }
                    [m_manager.disks removeObject:d];
                    [m_manager shrinkDisk:d];
                    d = NULL;
                    
                    // Scoring stuff
                    m_manager.score += i_DiskScore * i_DiskComboMultiplier;
                    if (++i_DiskComboMultiplier > 5) {
                        i_DiskComboMultiplier = 5;
                    }
                    [m_manager.UI showScoreLabel:m_manager.score];
                    i--;
                } else { // Wrong color quadrant, delete the disk and decrement score
                    [[SimpleAudioEngine sharedEngine] playEffect:@"error.mp3"];
                    i_DiskComboMultiplier = 1;
                    if(d == m_manager.selectedDisk) {
                        [m_manager clearSelectedDisk];
                    }
                    m_manager.score -= 50;
                    if(m_manager.score < 0) {
                        m_manager.score = 0;
                    }
                    [m_manager.UI showScoreLabel:m_manager.score];
                    [m_manager.disks removeObject:d];
                    [m_manager shrinkDisk:d];
                    d = NULL;
                    i--;
                }
            }
        }
        
        if (d) {
            [d update:delta];
        }
    }
}


-(void) timeDecrease{
    i_Time -= 1;
    [m_manager.UI showTimeLabel:i_Time];
    if (i_Time <= 0){
        [self unschedule:@selector(timeDecrease)];
        [self gameOver];
    }
}


-(void)createDisks {
    int timesToSpawnDisk = arc4random() % (i_Time / 30 + 1) + 1;
    if(i_Time == 10) {
        [self unschedule:@selector(createDisks)];
        [self schedule:@selector(createDisks) interval:0.5];
    } else if(i_Time == 25) {
        [self unschedule:@selector(createDisks)];
        [self schedule:@selector(createDisks) interval:0.75];
    } else if(i_Time == 40) {
        [self unschedule:@selector(createDisks)];
        [self schedule:@selector(createDisks) interval:1.00];
    }
    
    for(int i = 0; i < timesToSpawnDisk; i++) {
        [m_manager spawnDiskAtRandomLocation];
    }
    
    [self deleteOverflowDisks];
}

-(void)deleteOverflowDisks {
    // Always move the selected disk to the back of the objects list so it won't be deleted
    if (m_manager.selectedDisk != NULL) {
        for (int i = m_manager.disks.count - 1; i >= 0; i--) {
            if ([m_manager.disks objectAtIndex:i] == m_manager.selectedDisk) {
                Disk* temp = [m_manager.disks objectAtIndex:i];
                [m_manager.disks removeObjectAtIndex:i];
                [m_manager.disks addObject:temp];
                break;
            }
        }
    }
    
    while(m_manager.disks.count > 10) {
        [m_manager shrinkDisk:[m_manager.disks objectAtIndex:0]];
        [m_manager.disks removeObjectAtIndex:0];
        m_manager.score -= 20;
        if(m_manager.score < 0) {
            m_manager.score = 0;
        }
        [m_manager.UI showScoreLabel:m_manager.score];
    }
}

-(void) enter {
    [m_manager.UI StartAGame];
}

-(void) exit {
    
}

@end
