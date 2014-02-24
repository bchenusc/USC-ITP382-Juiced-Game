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
        
        particle_set = NO;
        
        //TODO possible memory leak. no dealloc function
        //emitter = [CCParticleSystemQuad particleWithFile:@"Red_Sparks.plist"];
        //emitter.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        //[self addChild:emitter];
    }
    return self;
}

- (CGRect) rect {
    return CGRectMake(self.position.x - self.contentSize.width * self.anchorPoint.x,
                      self.position.y - self.contentSize.height * self.anchorPoint.y,
                      self.contentSize.width,
                      self.contentSize.height);
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

- (void)draw {
    //Need to initialize particle emitter here because this is where iColor is set
    
    
    
    glLineWidth(4);
    switch (iColor) {
        case blue:
            ccDrawColor4B(0, 0, 255, 255);
            particleColor = @"Blue_Sparks.plist";
            super.color = ccc3(0, 0, 255);
            break;
        case red:
            ccDrawColor4B(255, 0, 0, 255);
            particleColor = @"Red_Sparks.plist";
            super.color = ccc3(255, 0, 0);
            break;
        case green:
            ccDrawColor4B(52, 199, 52, 255);
            particleColor = @"Green_Sparks.plist";
            super.color = ccc3(52, 199, 52);
            break;
        case yellow:
            ccDrawColor4B(255, 255, 0, 255);
            particleColor = @"Yellow_Sparks.plist";
            super.color = ccc3(255, 255, 0);
            break;
        default:
            break;
    }
    
    //Super hacky but no other way to set particle atm
    if (!particle_set) {
        particle_set = YES;
        emitter = [CCParticleSystemQuad particleWithFile:particleColor];
        emitter.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:emitter];
    }
    
    // Next line is really hacky, I dont't know why the translation is opposite in the y direction....
    //CGPoint toDraw = ccp(self.position.x, winSize.height-self.position.y);
    //ccDrawSolidCircle([[CCDirector sharedDirector] convertToGL:toDraw], iRadius, 256);
    //ccDrawColor4B(255, 255, 255, 255);
    //ccDrawCircle([[CCDirector sharedDirector] convertToGL:toDraw], iRadius, 360, 360, false);
    
    [super draw];
}

@end
