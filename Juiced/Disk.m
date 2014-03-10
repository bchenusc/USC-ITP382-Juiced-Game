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

-(id) init {
    self = [super initWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"Disk.png"]];
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
        self.anchorPoint = ccp(0.5f, 0.5f);
        
        iColor = white;
        emitter = NULL;
        
        iIsSelected = NO;
        iState = NONE;
    }
    return self;
}

-(id) initWithParticlesInBatchNode:(CCParticleBatchNode*)node {
    emitter = [CCParticleSystemQuad particleWithFile:@"Disc_Sparks.plist"];
    emitter.startSize = iRadius * 2 * 0.95f;
    emitter.endSize = iRadius * 2 * 1.05f;
    emitter.position = ccp(-100, -100);
    emitter.startSizeVar = 2;
    emitter.endSizeVar = 2;
    emitter.scale = 0;
    [node addChild:emitter];
    
    [self setDiskScale:0.0001f];
    iState = EXPANDING;
    
    return self;
}

-(void) removeDisk {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    iIsSelected = NO;
    iState = SHRINKING;
}

-(CGRect) rect {
    return CGRectMake(self.position.x - self.contentSize.width * self.anchorPoint.x,
                      self.position.y - self.contentSize.height * self.anchorPoint.y,
                      self.contentSize.width,
                      self.contentSize.height);
}

-(void) setDiskScale:(float)scale {
    if (scale <= 0.0001f) {
        scale = 0.0001f;
    }
    self.scale = scale;
    emitter.scale = scale;
}

-(void) setColor:(enum Color)color; {
    iColor = color;
    
    switch (color) {
        case white:
            emitter.startColor = ccc4FFromccc4B(ccc4(255, 255, 255, 102));
            emitter.endColor = ccc4FFromccc4B(ccc4(255, 255, 255, 0));
            super.color = ccc3(255, 255, 255);
            break;
        case blue:
            emitter.startColor = ccc4FFromccc4B(ccc4(0, 0, 255, 102));
            emitter.endColor = ccc4FFromccc4B(ccc4(0, 0, 255, 0));
            super.color = ccc3(0, 0, 255);
            break;
        case red:
            emitter.startColor = ccc4FFromccc4B(ccc4(255, 0, 0, 102));
            emitter.endColor = ccc4FFromccc4B(ccc4(255, 0, 0, 0));
            super.color = ccc3(255, 0, 0);
            break;
        case green:
            emitter.startColor = ccc4FFromccc4B(ccc4(52, 199, 52, 102));
            emitter.endColor = ccc4FFromccc4B(ccc4(52, 199, 52, 0));
            super.color = ccc3(52, 199, 52);
            break;
        case yellow:
            emitter.startColor = ccc4FFromccc4B(ccc4(255, 255, 0, 102));
            emitter.endColor = ccc4FFromccc4B(ccc4(255, 255, 0, 0));
            super.color = ccc3(255, 255, 0);
            break;
    }
}

-(void) update:(ccTime)delta {
    if (iState == EXPANDING) {
        float scale = self.scale;
        scale += delta * EXPAND_SHRINK_SPEED;
        if (scale >= 1.0f) {
            scale = 1.0f;
            iState = NONE;
        }
        [self setDiskScale:scale];
    } else if (iState == SHRINKING) {
        float scale = self.scale;
        scale -= delta * EXPAND_SHRINK_SPEED;
        if (scale <= 0.001f) {
            scale = 0.001f;
            iState = NONE;
            [emitter removeFromParentAndCleanup:YES];
            emitter = NULL;
            [iGameplayLayer.disksToBeRemoved removeObject:self];
            [self removeFromParentAndCleanup:YES];
            return;
        }
        [self setDiskScale:scale];
    }
    
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
    if (emitter) {
        emitter.position = newPos;
    }
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
    double ds = sqrt(dir.x * dir.x + dir.y * dir.y);
    if (ds == 0) {
        dir = ccp(0, 0);
    } else {
        dir = ccp(dir.x / ds, dir.y / ds);
    }
    
    // Determine the velocity
    double velocity = ds/dt;
    
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

@end
