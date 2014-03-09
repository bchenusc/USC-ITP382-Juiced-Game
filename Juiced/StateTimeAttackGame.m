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

-(id) init {
    self = [super init];
    if (self) {
        // Scoring Variables
        i_DiskScore = 10;
        i_DiskComboMultiplier = 1;
        i_Time = 0;
        i_TotalTime = 0;
    }
    return self;
}

-(void) startGame {
    m_manager.score = 0;
    i_DiskComboMultiplier = 1;
    i_Time = 5;
    i_DisksDestroyed = 0;
    [self schedule:@selector(timeDecrease) interval:1.0f];
    [m_manager.UI showScoreLabel: m_manager.score];
    [m_manager.UI showTimeLabel: i_Time];
    [m_manager scheduleOnce:@selector(blinkQuadrants) delay:8];
    [self createDisks];
}

-(void) gameOver {
    [self unschedule:@selector(createDisks)];
    [m_manager unschedule:@selector(blinkQuadrants)];
    [m_manager unschedule:@selector(changeColorOfAllQuadrants)];
    
    [m_manager setGameState:[[StateMainMenu alloc] init]];
    
    NSMutableArray* achievementValues = [NSMutableArray arrayWithObjects:
                                         [NSNumber numberWithInt:i_DisksDestroyed],
                                         [NSNumber numberWithInt:m_manager.score],
                                         [NSNumber numberWithInt:0],
                                         [NSNumber numberWithInt:0],
                                         nil];
    [m_manager setAchievementValues:achievementValues];
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
                // Check if the colors are the same
                if(intersectedCQ.color == d.color) {
                    [m_manager scoreParticlesAtLocation:d.position];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"score_goal.mp3"];
                    
                    // Scoring stuff
                    m_manager.score += i_DiskScore * i_DiskComboMultiplier;
                    if (++i_DiskComboMultiplier > 5) {
                        i_DiskComboMultiplier = 5;
                    }
                    
                    i_DisksDestroyed++;
                    
                    i_Time++;
                    [m_manager.UI showTimeLabel:i_Time];
                    
                } else { // Wrong color quadrant
                    [[SimpleAudioEngine sharedEngine] playEffect:@"error.mp3"];
                    i_DiskComboMultiplier = 1;
                    
                    
                    m_manager.score -= 50;
                    if(m_manager.score < 0) {
                        m_manager.score = 0;
                    }
                }
                //Combo show in the background
                [m_manager.UI showMultiplierLabel:i_DiskComboMultiplier];
                [m_manager.UI multiplierEmphasize];
                
                [m_manager removeDisk:d retainVelocity:NO];
                d = NULL;
                [m_manager.UI showScoreLabel:m_manager.score];
                i--;
            }
        }
    }
}


-(void) timeDecrease{
    i_Time -= 1;
    i_TotalTime++;
    if(i_Time <= 0) {
        i_Time = 0;
    }
    [m_manager.UI showTimeLabel:i_Time];
    if (i_Time <= 0){
        [self unschedule:@selector(timeDecrease)];
        [self gameOver];
    }
}


-(void) createDisks {
    int timesToSpawnDisk = arc4random() % (i_TotalTime / 5 + 1) + 2;
    for(int i = 0; i < timesToSpawnDisk; i++) {
        [m_manager spawnDiskAtRandomLocation];
    }
    [self unschedule:@selector(createDisks)];
    [self schedule:@selector(createDisks) interval:0.5f + .5f / (i_TotalTime / 5 + 1)];
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
        m_manager.score -= 20;
        i_Time -= 0.25;
        [m_manager.UI showTimeLabel:i_Time];
        if(m_manager.score < 0) {
            m_manager.score = 0;
        }
        [m_manager.UI showScoreLabel:m_manager.score];
    }
}

-(void) enter {
    [m_manager.UI startAGame];
}

-(void) exit {
    [m_manager clearAllDisks];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    m_manager.score = [[defaults objectForKey:@"disksDestroyed"] intValue];
    [m_manager.UI showScoreLabel:m_manager.score];
    [m_manager.UI showGameOver];
}

@end
