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

enum Color {
    red,
    blue,
    green,
    yellow
};

struct Touch {
    CGPoint location;
    NSTimeInterval timeStamp;
};

@interface Disk : CCSprite <CCTouchOneByOneDelegate> {
    enum Color iColor;
    float iRadius;
    CGSize winSize;
    double iVelocity;
    CGPoint iDirection;
    struct Touch touchStart;
    CCParticleSystemQuad* emitter;
    GameplayLayer* iGameplayLayer;
}

@property (readonly) enum Color color;
@property (assign) GameplayLayer* gameplayLayer;
@property double velocity;
@property CGPoint direction;
@property float radius;

-(CGRect) rect;

-(void) update:(ccTime)delta;

-(void) setColor:(enum Color)color;

@end
