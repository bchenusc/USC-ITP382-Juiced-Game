//
//  StateSurvivalGame.h
//  Juiced
//
//  Created by Jeffrey on 3/7/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "GameMode.h"

@interface StateSurvivalGame : GameMode {
    int m_decrement;
    int m_increment;
    
    int m_gameTime;
    int m_multiplier;
    int m_timeScore;
}

@end
