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

// HelloWorldLayer
@interface MainLayer : CCLayer {
    NSMutableArray* objects;
    CCSprite* selectedSprite;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)selectObjectForTouch:(CGPoint)touchLocation;

-(void)panForTranslation:(CGPoint)translation;

@end
