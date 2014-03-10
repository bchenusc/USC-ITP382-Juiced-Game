//
//  UILayer.h
//  Juiced
//
//  Created by Brian Chen on 2/22/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class GameplayLayer;

@interface UILayer : CCLayer {
    CCLabelTTF* m_TitleLabel;
    CCSprite* m_TitleSprite;
    CCLabelTTF* m_ScoreLabel;
    CCLabelTTF* m_TimeLabel;
    CCLabelTTF* m_IntroLabel;
    CCLabelTTF* m_MultLabel;
    
    CCLabelTTF* m_TimeAttackLabel;
    CCLabelTTF* m_SurvivalLabel;
    CCLabelTTF* m_EliminationLabel;
    CCLabelTTF* m_HighScoreLabel;
    
    
    CCLabelTTF* m_HighScoreTitleLabel;
    CCLabelTTF* m_HighScoreTimeAttack;
    CCLabelTTF* m_HighScoreSurvival;
    CCLabelTTF* m_HighScoreElimination;
    
    GameplayLayer* m_GameplayLayer;
    
    //Transition variables
    CGPoint score_go_to;
    CGSize  score_size_to;
    
    //Particle Systems
    CCParticleSystemQuad* m_MultParticleL;
    CCParticleSystemQuad* m_MultParticleR;
    
    int mc_maxMultiplier;
    
}

-(void) startAGame;
-(void) startARound : (int)roundNumber;
-(void) showTitleLabel : (NSString*) text;
-(void) hideIntroLabel;
-(void) hideTitleLabel;
-(void) showScoreLabel : (int) score;
-(void) hideScoreLabel;
-(void) showTimeLabel: (int) time;
-(void) hideTimeLabel;
-(void) showMultiplierLabel: (int) multiplier;
-(void) multiplierEmphasize;
-(void) hideMultiplierLabel;
-(void) showGameOver;
-(void) showAchievements;
-(void) hideAchievements;
-(void) assignGameplayLayer : (GameplayLayer*) layer;

@end



