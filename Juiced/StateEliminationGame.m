//
//  StateEliminationGame.m
//  Juiced
//
//  Created by David on 3/7/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import "StateEliminationGame.h"

@implementation StateEliminationGame

- (id)init {
    self = [super init];
    if(self) {
        b_TransitioningToNextRound = YES;
    }
    return self;
}

-(void) startGame {
    m_manager.score = 10000;
    i_Round = 1;
    [m_manager.UI showScoreLabel: m_manager.score];
    [m_manager.UI hideTimeLabel];
    [m_manager scheduleOnce:@selector(blinkQuadrants) delay:8];
    [self schedule:@selector(decrementScore) interval:1.0f];
    [self createDisks:5];
}

-(void) gameOver {
    [self unschedule:@selector(createDisks)];
    [self unschedule:@selector(decrementScore)];
    [m_manager unschedule:@selector(blinkQuadrants)];
    [m_manager unschedule:@selector(changeColorOfAllQuadrants)];
    
    [m_manager setGameState:[[StateMainMenu alloc] init]];
}

-(void) update:(ccTime)delta {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    if(m_manager.disks.count <= 0 && !b_TransitioningToNextRound) {
        [self unschedule:@selector(decrementScore)];
        i_Round++;
        if(i_Round > 5) {
            [self gameOver];
            return;
        }
        b_TransitioningToNextRound = YES;
        [m_manager.UI startARound:i_Round];
        [self scheduleOnce:@selector(startNextRound) delay:4];
    }
    
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
                } else { // Wrong color quadrant
                    [[SimpleAudioEngine sharedEngine] playEffect:@"error.mp3"];
                    
                    m_manager.score -= i_Round * 10;
                    
                    if(m_manager.score < 0) {
                        m_manager.score = 0;
                        [m_manager.UI showScoreLabel:m_manager.score];
                        [self gameOver];
                        return;
                    }
                }
                
                [m_manager removeDisk:d retainVelocity:NO];
                d = NULL;
                [m_manager.UI showScoreLabel:m_manager.score];
                i--;
                
                if(m_manager.disks.count <= 0) {
                    b_TransitioningToNextRound = NO;
                }
            }
        }
    }
}

-(void) startNextRound {
    [self createDisks:i_Round * 5];
    b_TransitioningToNextRound = YES;
    [self schedule:@selector(decrementScore) interval: 1.0 / (double)i_Round];
}

-(void) decrementScore {
    m_manager.score -= i_Round * 1000;
    [m_manager.UI showScoreLabel:m_manager.score];
    if(m_manager.score < 0) {
        m_manager.score = 0;
        [m_manager.UI showScoreLabel:m_manager.score];
        [self gameOver];
        return;
    }
}

-(void) createDisks:(int)numberOfDisks {
    for(int i = 0; i < numberOfDisks; i++) {
        [m_manager spawnDiskAtRandomLocation];
    }
}

-(void) enter {
    [m_manager.UI startAGame];
    b_TransitioningToNextRound = YES;
}

-(void) exit {
    [m_manager clearAllDisks];
    [m_manager.UI showGameOver];
}

@end
