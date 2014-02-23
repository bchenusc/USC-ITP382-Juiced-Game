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

// HelloWorldLayer
@interface GameplayLayer : CCLayer {
    NSMutableArray* objects;
    NSMutableArray* quadrants;
    CCSprite* selectedSprite;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)selectObjectForTouch:(CGPoint)touchLocation;

-(void)panForTranslation:(CGPoint)translation;

-(void)update:(ccTime)delta;

// Go through all the quadarnts and return the qudarnt at the given rect, if there is one
-(CornerQuadrant*)getQuadrantAtRect:(CGRect)rect;

@end
