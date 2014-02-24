//
//  Disk.m
//  Juiced
//
//  Created by Matthew Pohlmann on 2/11/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "Disk.h"
#import "cocos2d.h"

#pragma mark - Disk

@implementation Disk

@synthesize color = iColor;
@synthesize velocity = iVelocity;
@synthesize direction = iDirection;
@synthesize radius = iRadius;

- (id)init
{
    self = [super initWithFile:@"Disk.png"];
    if (self) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        self.position = ccp(winSize.width/2, winSize.height/2);
        touchStart.location = ccp(0, 0);
        touchStart.timeStamp = NSTimeIntervalSince1970;
        
        iDirection = ccp(0, 0);
        iVelocity = 0;
        iRadius = 30;
        
        CGSize c_size;
        c_size.width = 2 * iRadius;
        c_size.height = 2 * iRadius;
        self.contentSize = c_size;
        self.anchorPoint = ccp(0.5, 0.5);
        
        iColor = blue;
        emitter = [CCParticleSystemQuad particleWithFile:@"Blue_Sparks.plist"];
        [self addChild:emitter];
    }
    return self;
}

- (CGRect) rect {
    return CGRectMake(self.position.x - self.contentSize.width * self.anchorPoint.x,
                      self.position.y - self.contentSize.height * self.anchorPoint.y,
                      self.contentSize.width,
                      self.contentSize.height);
}

-(void) setColor:(enum Color)color; {
    iColor = color;
    
    if (emitter) {
        [self removeChild:emitter cleanup:YES];
        emitter = NULL;
    }
    
    switch (color) {
        case blue:
            emitter = [CCParticleSystemQuad particleWithFile:@"Blue_Sparks.plist"];
            super.color = ccc3(0, 0, 255);
            break;
        case red:
            emitter = [CCParticleSystemQuad particleWithFile:@"Red_Sparks.plist"];
            super.color = ccc3(255, 0, 0);
            break;
        case green:
            emitter = [CCParticleSystemQuad particleWithFile:@"Green_Sparks.plist"];
            super.color = ccc3(52, 199, 52);
            break;
        case yellow:
            emitter = [CCParticleSystemQuad particleWithFile:@"Yellow_Sparks.plist"];
            super.color = ccc3(255, 255, 0);
            break;
    }
    
    emitter.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:emitter];
}

-(void) setStartTouch:(CGPoint)loc Timestamp:(NSTimeInterval) time {
    touchStart.location = loc;
    touchStart.timeStamp = time;
}

-(struct Touch) getStartTouch {
    return touchStart;
}

-(void)update:(ccTime)delta {
    self.position = ccp(self.position.x + iDirection.x * iVelocity * delta, self.position.y + iDirection.y * iVelocity * delta);
    iVelocity *= (1 - 0.85 * delta);
    
    if (self.position.x - iRadius < 0 || self.position.x + iRadius > winSize.width) {
        iDirection.x *= -1;
    }
    if (self.position.y - iRadius < 0 || self.position.y + iRadius > winSize.height) {
        iDirection.y *= -1;
    }
}

@end
