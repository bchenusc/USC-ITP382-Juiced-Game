//
//  HelloWorldLayer.m
//  Juiced
//
//  Created by Matthew Pohlmann on 2/10/14.
//  Copyright Silly Landmine Studios 2014. All rights reserved.
//


// Import the interfaces
#import "MainLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "Disk.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation MainLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainLayer *layer = [MainLayer node];
	
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
        
        // All user-interactable objects
        objects = [[NSMutableArray alloc] init];
        
        // No selected sprite initially
        selectedSprite = NULL;
        
        // Add a random disk for testing
        Disk* disk = [Disk node];
        [objects addObject:disk];
        [self addChild:disk];
        
        // This layer can receive touches
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
	}
	return self;
}

-(void)selectObjectForTouch:(CGPoint)touchLocation {
    for (Disk *d in objects) {
        if (CGRectContainsPoint([d rect], touchLocation)) {
            NSLog(@"Touched a disk");
            selectedSprite = d;
            break;
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
    NSLog(@"Touched something");
    
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
    //translation.x *= 0.5;
    //translation.y *= 0.5;
    [self panForTranslation:translation];
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    selectedSprite = NULL;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    [objects dealloc];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
