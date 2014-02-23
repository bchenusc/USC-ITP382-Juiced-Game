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
    CCParticleSystemQuad* emitter;
}

@property int DiskScore;
@property(nonatomic, retain) CCParticleSystemQuad* ParticleEmitter;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)selectObjectForTouch:(CGPoint)touchLocation;

-(void)panForTranslation:(CGPoint)translation;

-(void)update:(ccTime)delta;

// Updater calls this one to create disks in case we want to spawn more than one disk
-(void)createDisks;

// Spawns one disk at a random location
-(void)spawnDisk;

// Switches the color of all quadrants
-(void)changeColorOfAllQuadrants;

// Blinks all quadrants
-(void)blinkQuadrants;

// Go through all the quadarnts and return the qudarnt at the given rect, if there is one
-(CornerQuadrant*)getQuadrantAtRect:(CGRect)rect;

- (void)gameStart;

@end
