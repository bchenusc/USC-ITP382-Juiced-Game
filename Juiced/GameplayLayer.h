//
//  HelloWorldLayer.h
//  Juiced
//
//  Created by Matthew Pohlmann on 2/10/14.
//  Copyright Silly Landmine Studios 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "CornerQuadrant.h"
#import "UILayer.h"

// HelloWorldLayer
@interface GameplayLayer : CCLayer {
    NSMutableArray* objects;
    NSMutableArray* quadrants;
    CCSprite* selectedSprite;
    
    int i_Score;
    int i_Time;
    
    UILayer* uiLayer;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)selectObjectForTouch:(CGPoint)touchLocation;

-(void)panForTranslation:(CGPoint)translation;

-(void)update:(ccTime)delta;

-(CornerQuadrant*)getQuadrantAtRect:(CGRect)rect;

@end
