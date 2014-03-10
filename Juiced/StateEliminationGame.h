//
//  StateEliminationGame.h
//  Juiced
//
//  Created by David on 3/7/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "GameMode.h"

@interface StateEliminationGame : GameMode {
    int i_Round;
    BOOL b_TransitioningToNextRound;
    int i_DisksDestroyed;
}

@end
