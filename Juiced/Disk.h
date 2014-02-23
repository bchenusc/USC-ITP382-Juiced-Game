//
//  Disk.h
//  Juiced
//
//  Created by Matthew Pohlmann on 2/11/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "CCSprite.h"

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
    float radius;
    CGSize winSize;
    double iVelocity;
    CGPoint iDirection;
    struct Touch touchStart;
}

@property enum Color color;
@property double velocity;
@property CGPoint direction;

-(CGRect) rect;

-(void) update:(ccTime)delta;

-(void) setStartTouch:(CGPoint)loc Timestamp:(NSTimeInterval) time;

-(struct Touch) getStartTouch;

@end
