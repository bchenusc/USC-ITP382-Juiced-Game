//
//  Disk.h
//  Juiced
//
//  Created by Matthew Pohlmann on 2/11/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "CCSprite.h"
#import "CCParticleSystemQuad.h"

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

@interface Disk : CCSprite {
    enum Color iColor;
    float iRadius;
    CGSize winSize;
    double iVelocity;
    CGPoint iDirection;
    struct Touch touchStart;
    CCParticleSystemQuad* emitter;
    
    NSString* particleColor;
    BOOL particle_set;
}

//@property enum Color color;
@property double velocity;
@property CGPoint direction;
@property float radius;

-(CGRect) rect;

-(void) update:(ccTime)delta;

-(void) setInitialColor:(enum Color)i_color;

-(enum Color) getColor;

-(void) setStartTouch:(CGPoint)loc Timestamp:(NSTimeInterval) time;

-(struct Touch) getStartTouch;

@end
