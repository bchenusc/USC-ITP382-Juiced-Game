//
//  Disk.m
//  Juiced
//
//  Created by Matthew Pohlmann on 2/11/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "Disk.h"
#import "cocos2d.h"
#import "GameplayLayer.h"

#pragma mark - Disk

@implementation Disk

@synthesize color = iColor;
@synthesize velocity = iVelocity;
@synthesize direction = iDirection;
@synthesize radius = iRadius;
@synthesize gameplayLayer = iGameplayLayer;
@synthesize isSelected = iIsSelected;

- (id) init {
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
        emitter.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
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
    
    switch (color) {
        case blue:
            emitter.startColor = ccc4FFromccc4B(ccc4(0, 0, 255, 255));
            emitter.endColor = ccc4FFromccc4B(ccc4(0, 0, 255, 0));
            super.color = ccc3(0, 0, 255);
            break;
        case red:
            emitter.startColor = ccc4FFromccc4B(ccc4(255, 0, 0, 255));
            emitter.endColor = ccc4FFromccc4B(ccc4(255, 0, 0, 0));
            super.color = ccc3(255, 0, 0);
            break;
        case green:
            emitter.startColor = ccc4FFromccc4B(ccc4(52, 199, 52, 255));
            emitter.endColor = ccc4FFromccc4B(ccc4(52, 199, 52, 0));
            super.color = ccc3(52, 199, 52);
            break;
        case yellow:
            emitter.startColor = ccc4FFromccc4B(ccc4(255, 255, 0, 255));
            emitter.endColor = ccc4FFromccc4B(ccc4(255, 255, 0, 0));
            super.color = ccc3(255, 255, 0);
            break;
    }
}

-(void) update:(ccTime)delta {
    CGPoint newPos = ccp(self.position.x + iDirection.x * iVelocity * delta, self.position.y + iDirection.y * iVelocity * delta);
    iVelocity *= (1 - 0.85 * delta);
    
    if (newPos.x - iRadius <= 0 || newPos.x + iRadius >= winSize.width) {
        iDirection.x *= -1;
        if (newPos.x - iRadius < 0) {
            newPos.x = iRadius;
        } else if (newPos.x + iRadius > winSize.width) {
            newPos.x = winSize.width - iRadius;
        }
    }
    if (newPos.y - iRadius <= 0 || newPos.y + iRadius >= winSize.height) {
        iDirection.y *= -1;
        if (newPos.y - iRadius < 0) {
            newPos.y = iRadius;
        } else if (newPos.y + iRadius > winSize.height) {
            newPos.y = winSize.height - iRadius;
        }
    }
    
    self.position = newPos;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpaceAR:touch];
    CGPoint layerLocation = [iGameplayLayer convertTouchToNodeSpace:touch];
    
    if ((pow(touchLocation.x, 2) + pow(touchLocation.y, 2)) <= pow(iRadius, 2)) {
        touchStart.location = layerLocation;
        touchStart.timeStamp = touch.timestamp;
        self.velocity = 0;
        self.isSelected = YES;
        return YES;
    }
    
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [iGameplayLayer convertTouchToNodeSpace:touch];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [iGameplayLayer convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    CGPoint newPos = ccpAdd(self.position, translation);
    
    self.position = newPos;
    
    touchStart.location = oldTouchLocation;
    touchStart.timeStamp = touch.timestamp;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // Determine how long the touch/drag lasted on the disk
    double dt = touch.timestamp - touchStart.timeStamp;
    
    // Determine the vector of the touch and normalize it
    CGPoint touchLocation = [iGameplayLayer convertTouchToNodeSpace:touch];
    CGPoint dir = ccp(touchLocation.x - touchStart.location.x, touchLocation.y - touchStart.location.y);
    double dx = sqrt(dir.x * dir.x + dir.y * dir.y);
    if (dx == 0) {
        dir = ccp(0, 0);
    } else {
        dir = ccp(dir.x / dx, dir.y / dx);
    }
    
    // Determine the velocity
    double velocity = dx/dt;
    
    // Cap max velocity
    if (velocity > 3000) {
        velocity = 3000;
    }
    
    self.velocity = velocity;
    self.direction = dir;
    
    self.isSelected = NO;
}

- (void) onEnter {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit {
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

@end
