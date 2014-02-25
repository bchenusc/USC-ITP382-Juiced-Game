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

#import "SimpleAudioEngine.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameplayLayer

@synthesize DiskScore = i_DiskScore;
@synthesize ParticleEmitter = emitter;

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
        
        //Sound
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgmusic.mp3" loop: YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.25f];
        
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
        
        [self SpawnFourDisks];
        
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
        
        // This layer can receive touches
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:INT_MIN+2 swallowsTouches:YES];
        [self scheduleUpdate];
        
        //Layers
        uiLayer = [UILayer node];
        [self addChild:uiLayer];
        [uiLayer showTitleLabel: @"JUICED"];
        [uiLayer AssignGameplayLayer:self];
        //[uiLayer showDemoButton: self Size: winSize];
        
        //Gameplay Variable initialization
        m_GameState = SelectMode;
        
        
        
        //Particle System Initialization
        emitter = [CCParticleSystemQuad particleWithFile:@"White_Starburst.plist"];
        emitter.position = ccp(winSize.width/2, winSize.height/2);
        emitter.visible = NO;
        [self addChild:emitter];
        
	}
	return self;
}

-(void) SpawnFourDisks{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // Add a some disks for testing
    Disk* disk1 = [Disk node];
    disk1.position = ccp(winSize.width/4, winSize.height/4);
    //disk1.color = blue;
    [disk1 setColor:blue];
    disk1.zOrder = diskZOrder++;
    [objects addObject:disk1];
    [self addChild:disk1];
    
    Disk* disk2 = [Disk node];
    disk2.position = ccp(winSize.width*3/4, winSize.height/4);
    //disk2.color = red;
    [disk2 setColor:red];
    disk2.zOrder = diskZOrder++;
    [objects addObject:disk2];
    [self addChild:disk2];
    
    Disk* disk3 = [Disk node];
    disk3.position = ccp(winSize.width/4, winSize.height*3/4);
    //disk3.color = yellow;
    [disk3 setColor:yellow];
    disk3.zOrder = diskZOrder++;
    [objects addObject:disk3];
    [self addChild:disk3];
    
    Disk* disk4 = [Disk node];
    disk4.position = ccp(winSize.width*3/4, winSize.height*3/4);
    //disk4.color = green;
    [disk4 setColor:green];
    disk4.zOrder = diskZOrder++;
    [objects addObject:disk4];
    [self addChild:disk4];
}

-(void) selectObjectForTouch:(UITouch*)touch {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    for(int i = objects.count - 1; i >= 0; i--) {
        Disk* d = objects[i];
        CGPoint distanceFromDisk = ccpSub(d.position, touchLocation);
        if((pow(distanceFromDisk.x, 2) + pow(distanceFromDisk.y, 2)) <= pow([d rect].size.width / 2, 2)) {
            selectedSprite = d;
            [d setStartTouch:touchLocation Timestamp:touch.timestamp];
            d.velocity = 0;
            return;
        }
    }
}

-(void) panForTranslation:(CGPoint)translation {
    if (selectedSprite) {
        CGPoint newPos = ccpAdd(selectedSprite.position, translation);
        selectedSprite.position = newPos;
    }
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self selectObjectForTouch:touch];
    
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
    // If there's a selected sprite, and it's a disk
    if (selectedSprite && [selectedSprite isKindOfClass:[Disk class]]) {
        // Cast to a Disk
        Disk* disk = (Disk*) selectedSprite;
        
        // Determine how long the touch/drag lasted on the disk
        double dt = touch.timestamp - [disk getStartTouch].timeStamp;
        
        // Determine the vector of the touch and normalize it
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        CGPoint dir = ccp(touchLocation.x - [disk getStartTouch].location.x, touchLocation.y - [disk getStartTouch].location.y);
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
        
        disk.velocity = velocity;
        disk.direction = dir;
        
        selectedSprite = NULL;
    }
}

-(void)update:(ccTime)delta {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    switch (m_GameState) {
        case SelectMode:
            [self updateMainMenu:delta withWindowSize:winSize];
            break;
        case InGame:
            [self updateGameplay:delta withWindowSize:winSize];
            break;
        default:
            break;
    }
}

-(void) updateMainMenu:(ccTime)delta withWindowSize:(CGSize)winSize {
    for(int i = 0; i < objects.count; i++) {
        Disk* d = objects[i];
        
        // Check if the disc goes to a corner
        CGFloat radius = d.rect.size.width / 2;
        if(d.position.x <= radius || d.position.x >= winSize.width - radius || d.position.y <= radius || d.position.y >= winSize.height - radius) {
            
            // Get the quadrant the disc is at, if there is one
            CornerQuadrant* intersectedCQ = [self getQuadrantAtRect:d.rect];
            if(intersectedCQ != NULL) {
                // Handle menu selection
                [self handleMenuSelection:d Quadrant:intersectedCQ];
            }
        }
        
        if (objects.count != 0) {
            [d update:delta];
        }
    }

}

-(void) updateGameplay:(ccTime)delta withWindowSize:(CGSize)winSize {
    for(int i = 0; i < objects.count; i++) {
        Disk* d = objects[i];
        
        // Check if the disc goes to a corner
        CGFloat radius = d.rect.size.width / 2;
        if(d.position.x <= radius || d.position.x >= winSize.width - radius || d.position.y <= radius || d.position.y >= winSize.height - radius) {
            
            // Get the quadrant the disc is at, if there is one
            CornerQuadrant* intersectedCQ = [self getQuadrantAtRect:d.rect];
            if(intersectedCQ != NULL) {
                // Check if the colors are the same, remove the disc if they are
                if(intersectedCQ.color == d.color) {
                    [self scoreParticlesAtLocation:d.position];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"score_goal.mp3"];
                    // If it's the selected sprite, make sure to set it to null or bad things will happen
                    if(d == selectedSprite) {
                        selectedSprite = nil;
                    }
                    [objects removeObject:d];
                    //[self removeChild:d cleanup:YES];
                    [self shrinkDisk:d];
                    d = nil;
                    
                    // Scoring stuff
                    i_Score += i_DiskScore * i_DiskComboMultiplier;
                    if (++i_DiskComboMultiplier > 5) {
                        i_DiskComboMultiplier = 5;
                    }
                    [uiLayer showScoreLabel:i_Score];
                    i--;
                } else { // Wrong color quadrant, delete the disk and decrement score
                    [[SimpleAudioEngine sharedEngine] playEffect:@"error.mp3"];
                    i_DiskComboMultiplier = 1;
                    if(d == selectedSprite) {
                        selectedSprite = NULL;
                    }
                    i_Score -= 50;
                    if(i_Score < 0) {
                        i_Score = 0;
                    }
                    [uiLayer showScoreLabel:i_Score];
                    [objects removeObject:d];
                    //[self removeChild:d cleanup:YES];
                    [self shrinkDisk:d];
                    d = NULL;
                    i--;
                }
            }
        }
        
        if (d) {
            [d update:delta];
        }
    }

}

-(void) handleMenuSelection : (Disk*) disk Quadrant : (CornerQuadrant*) quad{
    //Handle collisions here.
    if(quad.color == disk.color) {
        disk.velocity = 0;
        //[self scoreParticlesAtLocation:disk.position];
        [uiLayer StartAGame];
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

-(void) scoreParticlesAtLocation:(CGPoint) location {
    [emitter resetSystem];
    emitter.position = location;
    emitter.visible = YES;
    [self scheduleOnce:@selector(makeParticlesInvisible) delay:1];
}

-(void) makeParticlesInvisible {
    emitter.visible = NO;
}

-(void)createDisks {
    int timesToSpawnDisk = arc4random() % (i_Time / 30 + 1) + 1;
    if(i_Time == 10) {
        [self unschedule:@selector(createDisks)];
        [self schedule:@selector(createDisks) interval:0.5];
    } else if(i_Time == 25) {
        [self unschedule:@selector(createDisks)];
        [self schedule:@selector(createDisks) interval:0.75];
    } else if(i_Time == 40) {
        [self unschedule:@selector(createDisks)];
        [self schedule:@selector(createDisks) interval:1.00];
    }
    
    for(int i = 0; i < timesToSpawnDisk; i++)
        [self spawnDisk];
}

-(void)spawnDisk {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    Disk* newDisk = [Disk node];
    newDisk.scale = 0;
    newDisk.zOrder = diskZOrder++;
    CGRect newDiskRect = newDisk.rect;
    newDisk.position = ccp(arc4random() % (int)(winSize.width - newDiskRect.size.width) + newDiskRect.size.width, arc4random() % (int)(winSize.height - newDiskRect.size.height * 2) + newDiskRect.size.height);
    
    switch (arc4random() % 4) {
        case 0:
            [newDisk setColor:red];
            break;
        case 1:
            [newDisk setColor:yellow];
            break;
        case 2:
            [newDisk setColor:green];
            break;
        case 3:
            [newDisk setColor:blue];
            break;
        default:
            [newDisk setColor:red];
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
    
    // Grow the disk to the requisite size of 60, in .5 seconds
    [self performSelector:@selector(expandDisk:) withObject:newDisk afterDelay:.01];
    
    [self addChild:newDisk];
    
    [self deleteOverflowDisks];
}

-(void)expandDisk:(Disk *)d {
    d.scale += 1/6.0;
    if(d.scale < 1)
        [self performSelector:@selector(expandDisk:) withObject:d afterDelay:.01];
    else
        [self activateDisk:d];
}

-(void)activateDisk:(Disk *)d {
    [objects addObject:d];
}

-(void)shrinkDisk:(Disk *)d {
    if(d != nil) {
        d.scale -= 1/6.0;
        if(d.scale > 0) {
            [self performSelector:@selector(shrinkDisk:) withObject:d afterDelay:.01];
        } else {
            [self deleteDisk:d];
        }
    }
}

-(void)deleteDisk:(Disk *)d {
    if(d != nil) {
        if(d == selectedSprite) {
            selectedSprite = nil;
        }
        [self removeChild:d cleanup:YES];
        [objects removeObject:d];
    }
}
           
-(void)changeColorOfAllQuadrants {
    // Create an array corresponding with the four colors
    NSMutableArray* randomArray = [NSMutableArray new];
    for(int i = 0; i < quadrants.count; i++) {
        NSNumber* newNumber = [NSNumber numberWithInt:i];
        [randomArray addObject:newNumber];
    }
    // Shuffle the array of random numbers corresponding to colors
    for(int i = 0; i < randomArray.count; i++) {
        int randomIndex = i + arc4random() % (4 - i);
        [randomArray exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
    }
    // Assign it a random color
    for(int i = 0; i < quadrants.count; i++) {
        CornerQuadrant* cq = quadrants[i];
        [cq setVisible:YES];
        switch([randomArray[i] integerValue]) {
            case 0:
                cq.color = blue;
                break;
            case 1:
                cq.color = red;
                break;
            case 2:
                cq.color = yellow;
                break;
            case 3:
                cq.color = green;
                break;
            default:
                cq.color = blue;
                break;
        }
    }
    [self scheduleOnce:@selector(blinkQuadrants) delay:8];
}

-(void) blinkQuadrants {
    for(CornerQuadrant *cq in quadrants) {
        CCBlink* blink = [CCBlink actionWithDuration:1 blinks:5];
        [cq runAction:blink];
    }
    [self scheduleOnce:@selector(changeColorOfAllQuadrants) delay:1];
}

-(void)deleteOverflowDisks {
    while(objects.count > 10) {
        if(objects[0] == selectedSprite) {
            selectedSprite = NULL;
        }
        [self removeChild:objects[0] cleanup:YES];
        [objects removeObjectAtIndex:0];
        i_Score -= 20;
        if(i_Score < 0) {
            i_Score = 0;
        }
        [uiLayer showScoreLabel:i_Score];
    }
}

- (void) selectionModeSelected{
    // Remove all disks
    for(Disk* d in objects) {
        [self removeChild:d cleanup:YES];
        d = NULL;
    }
    [objects removeAllObjects];
    selectedSprite = NULL;
}

-(void) gameStart{
    
    //Enable touching
    //[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
    m_GameState = InGame;
    i_Score = 0;
    i_DiskComboMultiplier = 1;
    i_Time = 60;
    [self schedule:@selector(timeDecrease) interval:1.0f];
    [uiLayer showScoreLabel: i_Score];
    [uiLayer showTimeLabel: i_Time];
    // Schedule this layer for update
    //[self scheduleUpdate];
    [self schedule:@selector(createDisks) interval:1];
    [self scheduleOnce:@selector(blinkQuadrants) delay:8];
    
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
    m_GameState = SelectMode;
    [self unschedule:@selector(createDisks)];
    [self unschedule:@selector(blinkQuadrants)];
    [self unschedule:@selector(changeColorOfAllQuadrants)];
    
    // Remove all disks
    for(Disk* d in objects) {
        [self removeChild:d cleanup:YES];
    }
    [objects removeAllObjects];
    
    // UI Stuff
    //[[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
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
