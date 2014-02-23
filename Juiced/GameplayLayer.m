//
//  HelloWorldLayer.m
//  Juiced
//
//  Created by Matthew Pohlmann on 2/10/14.
//  Copyright Silly Landmine Studios 2014. All rights reserved.
//


// Import the interfaces
#import "GameplayLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "Disk.h"
#import "CornerQuadrant.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameplayLayer

@synthesize DiskScore = i_DiskScore;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameplayLayer *layer = [GameplayLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Scoring Variables
        i_DiskScore = 100;
        i_DiskComboMultiplier = 1;
        
        // All user-interactable objects
        objects = [[NSMutableArray alloc] init];
        diskZOrder = 0;
        
        // Quadrants
        quadrants = [[NSMutableArray alloc] init];
        
        // No selected sprite initially
        selectedSprite = NULL;
        
        // Add a some disks for testing
        Disk* disk1 = [Disk node];
        disk1.position = ccp(winSize.width/2 + 90, winSize.height/2);
        disk1.color = blue;
        disk1.zOrder = diskZOrder++;
        [objects addObject:disk1];
        [self addChild:disk1];
        
        Disk* disk2 = [Disk node];
        disk2.position = ccp(winSize.width/2 - 90, winSize.height/2);
        disk2.color = red;
        disk2.zOrder = diskZOrder++;
        [objects addObject:disk2];
        [self addChild:disk2];
        
        Disk* disk3 = [Disk node];
        disk3.position = ccp(winSize.width/2, winSize.height/2 + 90);
        disk3.color = yellow;
        disk3.zOrder = diskZOrder++;
        [objects addObject:disk3];
        [self addChild:disk3];
        
        Disk* disk4 = [Disk node];
        disk4.position = ccp(winSize.width/2, winSize.height/2 - 90);
        disk4.color = green;
        disk4.zOrder = diskZOrder++;
        [objects addObject:disk4];
        [self addChild:disk4];
        
        // Add some corner quadrants for testing
        CornerQuadrant* quad1 = [CornerQuadrant node];
        quad1.position = ccp(0, 0);
        quad1.width = winSize.width / 4;
        quad1.height = winSize.height / 2;
        quad1.color = red;
        [quadrants addObject:quad1];
        [self addChild:quad1];
        
        CornerQuadrant* quad2 = [CornerQuadrant node];
        quad2.position = ccp(0, winSize.height);
        quad2.width = winSize.width / 4;
        quad2.height = -winSize.height / 2;
        quad2.color = yellow;
        [quadrants addObject:quad2];
        [self addChild:quad2];
        
        CornerQuadrant* quad3 = [CornerQuadrant node];
        quad3.position = ccp(winSize.width, 0);
        quad3.width = -winSize.width / 4;
        quad3.height = winSize.height / 2;
        quad3.color = blue;
        [quadrants addObject:quad3];
        [self addChild:quad3];
        
        CornerQuadrant* quad4 = [CornerQuadrant node];
        quad4.position = ccp(winSize.width, winSize.height);
        quad4.width = -winSize.width / 4;
        quad4.height = -winSize.height / 2;
        quad4.color = green;
        [quadrants addObject:quad4];
        [self addChild:quad4];
        
        // Schedule this layer for update
        [self scheduleUpdate];
        [self schedule:@selector(spawnDisk) interval:.5];
        
        // This layer can receive touches
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
        
        
        //Layers
        uiLayer = [UILayer node];
        [self addChild:uiLayer];
        
        //Gameplay Variable initialization
        [self gameStart];
        [uiLayer showScoreLabel:0];
        
        
	}
	return self;
}

-(void)selectObjectForTouch:(CGPoint)touchLocation {
    for (Disk *d in objects) {
        if (CGRectContainsPoint([d rect], touchLocation)) {
            selectedSprite = d;
        }
    }
}

-(void)panForTranslation:(CGPoint)translation {
    if (selectedSprite) {
        CGPoint newPos = ccpAdd(selectedSprite.position, translation);
        selectedSprite.position = newPos;
    }
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectObjectForTouch:touchLocation];
    
    return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    selectedSprite = NULL;
}

-(void)update:(ccTime)delta {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    for(int i = 0; i < objects.count; i++) {
        Disk* d = objects[i];
        // Check if the disc goes to a corner
        CGFloat radius = d.rect.size.width / 2;
        if(d.position.x < radius || d.position.x > winSize.width - radius || d.position.y < radius || d.position.y > winSize.height - radius) {
            // Get the quadrant the disc is at, if there is one
            CornerQuadrant* intersectedCQ = [self getQuadrantAtRect:d.rect];
            if(intersectedCQ != NULL) {
                // Check if the colors are the same, remove the disc if they are
                if(intersectedCQ.color == d.color) {
                    // If it's the selected sprite, make sure to set it to null or bad things will happen
                    if(d == selectedSprite)
                        selectedSprite = NULL;
                    [objects removeObject:d];
                    [self removeChild:d cleanup:YES];
                    i_Score += i_DiskScore * i_DiskComboMultiplier;
                    i_DiskComboMultiplier++;
                    [uiLayer showScoreLabel:i_Score];
                    i--;
                } else {
                    i_DiskComboMultiplier = 1;
                }
            } else {
                // Call update only AFTER collisions are checked for
                [d update:delta];
            }
        }
    }
}

-(CornerQuadrant*)getQuadrantAtRect:(CGRect)rect {
    for(CornerQuadrant* cq in quadrants) {
        // Get the rects the quadrant is made up of, from the array of rects the quadrant returns
        NSMutableArray* collidableRects = [cq getCollidableArea];
        CGRect firstRect = [collidableRects[0] CGRectValue];
        CGRect secondRect = [collidableRects[1] CGRectValue];
        // If the rects intersect, return this quadrant
        if(CGRectIntersectsRect(firstRect, rect) || CGRectIntersectsRect(secondRect, rect)) {
            return cq;
        }
    }
    return NULL;
}

// Spawns a new disk at a random position
-(void)spawnDisk {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    Disk* newDisk = [Disk node];
    newDisk.zOrder = diskZOrder++;
    CGRect newDiskRect = newDisk.rect;
    newDisk.position = ccp(arc4random() % (int)(winSize.width - newDiskRect.size.width) + newDiskRect.size.width, arc4random() % (int)(winSize.height - newDiskRect.size.height * 2) + newDiskRect.size.height);
    
    switch (arc4random() % 4) {
        case 0:
            newDisk.color = red;
            break;
        case 1:
            newDisk.color = yellow;
            break;
        case 2:
            newDisk.color = green;
            break;
        case 3:
            newDisk.color = blue;
            break;
        default:
            newDisk.color = red;
            break;
    }
    
    // Makes sure the new disk isn't too close to others
    for(Disk* d in objects) {
        if(abs(d.position.x - newDisk.position.x) <= newDiskRect.size.width / 10 && abs(d.position.y - newDisk.position.y) <= newDiskRect.size.height / 10) {
            if(newDisk.position.x < d.position.x)
                newDisk.position = ccp(newDisk.position.x - newDiskRect.size.width / 10, newDisk.position.y);
            else
                newDisk.position = ccp(newDisk.position.x + newDiskRect.size.width / 10, newDisk.position.y);
            if(newDisk.position.y < d.position.y)
                newDisk.position = ccp(newDisk.position.y, newDisk.position.y - newDiskRect.size.height / 10);
            else
                newDisk.position = ccp(newDisk.position.y, newDisk.position.y + newDiskRect.size.height / 10);
        }
    }
    
    // Makes sure the new disk isn't too close to borders
    if(newDisk.position.x < newDiskRect.size.width)
        newDisk.position = ccp(newDiskRect.size.width * 3 / 2, newDisk.position.y);
    else if(newDisk.position.x > winSize.width - newDiskRect.size.width)
        newDisk.position = ccp(winSize.width - newDiskRect.size.width * 3 / 2, newDisk.position.y);
    
    if(newDisk.position.y < newDiskRect.size.height)
        newDisk.position = ccp(newDisk.position.x, newDiskRect.size.height * 3 / 2);
    else if(newDisk.position.x > winSize.width - newDiskRect.size.width)
        newDisk.position = ccp(newDisk.position.x, winSize.height - newDiskRect.size.height * 3 / 2);
    
    [objects addObject:newDisk];
    [self addChild:newDisk];
}

-(void) gameStart{
    i_Score = 0;
    i_Time = 60;
    [self schedule:@selector(timeDecrease) interval:1.0f];
    [uiLayer showTitleLabel];
    [uiLayer showScoreLabel: i_Score];
    [uiLayer showTimeLabel: i_Time];
}

-(void) timeDecrease{
    i_Time -= 1;
    [uiLayer showTimeLabel:i_Time];
    if (i_Time <= 0){
        [self unschedule:@selector(timeDecrease)];
        [self gameOver];
    }
}

-(void) gameOver{
    // Remove all disks
    for(Disk* d in objects) {
        [self removeChild:d];
    }
    [objects removeAllObjects];
    
    // UI Stuff
    [uiLayer showGameOver];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    [objects dealloc];
    
    [quadrants dealloc];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
