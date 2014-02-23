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
@class UILayer;
#import "UILayer.h"


// HelloWorldLayer
@interface GameplayLayer : CCLayer {
    NSMutableArray* objects;
    NSMutableArray* quadrants;
    CCSprite* selectedSprite;
    
    int i_Score;
    int i_Time;
    int i_DiskScore;
    int i_DiskComboMultiplier;
    int diskZOrder;
    
    UILayer* uiLayer;
}

@property int DiskScore;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)selectObjectForTouch:(CGPoint)touchLocation;

-(void)panForTranslation:(CGPoint)translation;

-(void)update:(ccTime)delta;

-(void)spawnDisk;

// Go through all the quadarnts and return the qudarnt at the given rect, if there is one
-(CornerQuadrant*)getQuadrantAtRect:(CGRect)rect;

- (void)gameStart;

@end
