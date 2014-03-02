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
#import "GameState.h"

@class UILayer;
@class GameState;

// HelloWorldLayer
@interface GameplayLayer : CCLayer {
    NSMutableArray* objects;
    NSMutableArray* quadrants;
    CCSprite* selectedSprite;
    
    int i_Score;
    int diskZOrder;
    
    GameState* m_GameState;
    GameState* m_NextGameState;
    
    UILayer* uiLayer;
    CCParticleSystemQuad* emitter;
}

@property int score;
@property (readonly) UILayer* UI;
@property (readonly) NSMutableArray* disks;
@property (readonly) NSMutableArray* quads;
@property (readonly) CCSprite* selectedDisk;

@property(nonatomic, retain) CCParticleSystemQuad* ParticleEmitter;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene*) scene;

-(void) clearSelectedDisk;

-(void) SpawnFourDisks;

-(void) selectObjectForTouch:(UITouch*)touch;

-(void) panForTranslation:(CGPoint)translation;

-(void) SetGameState:(GameState*)newState;

-(void) update:(ccTime)delta;

-(void) clearAllDisks;

// Spawns one disk at a random location
-(void) spawnDiskAtRandomLocation;

// Makes the disk expand by incrementing its radius
-(void) expandDisk:(Disk*)d;

// Makes a disk active
-(void) activateDisk:(Disk*)d;

// Shrinks a disk
-(void) shrinkDisk:(Disk*)d;

// Destroys a disk
-(void) deleteDisk:(Disk*)d;

// Switches the color of all quadrants
-(void) changeColorOfAllQuadrants;

// Blinks all quadrants
-(void) blinkQuadrants;

// Go through all the quadarnts and return the qudarnt at the given rect, if there is one
-(CornerQuadrant*) getQuadrantAtRect:(CGRect)rect;

-(void) scoreParticlesAtLocation:(CGPoint)location;

-(void) gameStart;

@end
