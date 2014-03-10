//
//  Disk.h
//  Juiced
//
//  Created by Matthew Pohlmann on 2/11/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "CCSprite.h"
#import "CCParticleSystemQuad.h"
#import "CCTouchDelegateProtocol.h"

@class GameplayLayer;

static const float EXPAND_SHRINK_SPEED = 10.0f; // This is in seconds^-1

typedef NS_ENUM(NSInteger, Color) {
    white,
    red,
    blue,
    green,
    yellow
};

typedef NS_ENUM(NSInteger, DiskState) {
    EXPANDING,
    SHRINKING,
    NONE
};

struct Touch {
    CGPoint location;
    NSTimeInterval timeStamp;
};

@interface Disk : CCSprite <CCTouchOneByOneDelegate> {
    enum Color iColor;
    enum DiskState iState;
    float iRadius;
    CGSize winSize;
    double iVelocity;
    CGPoint iDirection;
    struct Touch touchStart;
    CCParticleSystemQuad* emitter;
    GameplayLayer* iGameplayLayer;
    BOOL iIsSelected;
}

@property (readonly) enum Color color;
@property (assign) GameplayLayer* gameplayLayer;
@property double velocity;
@property CGPoint direction;
@property float radius;
@property BOOL isSelected;

-(id) initWithParticlesInBatchNode:(CCParticleBatchNode*)node;

-(void) removeDisk;

-(CGRect) rect;

-(void) update:(ccTime)delta;

-(void) setColor:(enum Color)color;

@end
