//
//  GameMode.h
//  Juiced
//
//  Created by Matthew Pohlmann on 3/1/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "GameState.h"
#import "StateMainMenu.h"

@interface GameMode : GameState {
    
}

-(void) startGame;

-(void) gameOver;

@end
