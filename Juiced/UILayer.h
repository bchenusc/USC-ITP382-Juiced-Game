//
//  UILayer.h
//  Juiced
//
//  Created by Brian Chen on 2/22/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameplayLayer.h"
@class GameplayLayer;

@interface UILayer : CCLayer
{
    CCLabelTTF* m_TitleLabel;
    CCLabelTTF* m_ScoreLabel;
    CCLabelTTF* m_TimeLabel;
    
}

- (void) showTitleLabel;
- (void) hideTitleLabel;
- (void) showScoreLabel : (int) score;
- (void) hideScoreLabel;
- (void) showTimeLabel: (int) time;
- (void) hideTimeLabel;
- (void) showGameOver;
- (void) showDemoButton : (GameplayLayer*) game Size: (CGSize) size;
@end



