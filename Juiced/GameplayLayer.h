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
    
    CCSpriteBatchNode* iSpriteBatch;
    CCParticleBatchNode* iParticleBatch;
    CCTexture2D* diskTexture;
    
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

@property(nonatomic, retain) CCParticleSystemQuad* ParticleEmitter;

// Returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene*) scene;

// Spawns four disks in the corners, i.e. for a menu
-(void) spawnFourDisks;

// Sets the game state to a new state
-(void) setGameState:(GameState*)newState;

// Update the layer
-(void) update:(ccTime)delta;

// Clears all active disks by shrinking them
-(void) clearAllDisks;

// Spawns one disk at a random location
-(void) spawnDiskAtRandomLocation;

// Spawns one disk at a given location with random color
-(void) spawnDiskAtLocation:(CGPoint)location;

// Spawns one disk at a given location with a given color
-(void) spawnDiskAtLocation:(CGPoint)location withColor:(enum Color)color;

// Remove a given disk
-(void) removeDisk:(Disk*)d retainVelocity:(BOOL)rv;

// Makes the disk expand by incrementing its radius
-(void) expandDisk:(Disk*)d;

// Shrinks a disk and deletes it
-(void) shrinkDisk:(Disk*)d;

// Switches the color of all quadrants
-(void) changeColorOfAllQuadrants;

// Blinks all quadrants
-(void) blinkQuadrants;

// Go through all the quadrants and returns the quadrant at the given rect, if there is one
-(CornerQuadrant*) getQuadrantAtRect:(CGRect)rect;

// Spawns score particles at a given location
-(void) scoreParticlesAtLocation:(CGPoint)location;

// Starts a game
-(void) gameStart;

// Sets achievement values
-(void) setAchievementValues:(NSMutableArray*)values;

@end
