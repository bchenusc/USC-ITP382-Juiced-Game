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

// Lots of States
#import "StateMainMenu.h"
#import "GameMode.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameplayLayer

@synthesize score = i_Score;
@synthesize UI = uiLayer;
@synthesize disks = objects;
@synthesize disksToBeRemoved = toBeRemoved;
@synthesize quads = quadrants;

@synthesize ParticleEmitter = emitter;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene*) scene {
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
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //Sound
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgmusic.mp3" loop: YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.25f];
        
        // All user-interactable objects
        objects = [[NSMutableArray alloc] init];
        toBeRemoved = [[NSMutableArray alloc] init];
        diskZOrder = 0;
        
        // Quadrants
        quadrants = [[NSMutableArray alloc] init];
        
        // Batching nodes
        diskTexture = [[CCTextureCache sharedTextureCache] addImage:@"Disk.png"];
        particleTexture = [[CCTextureCache sharedTextureCache] addImage:@"DiskCenter.png"];
        iSpriteBatch = [CCSpriteBatchNode batchNodeWithTexture:diskTexture];
        iParticleBatch = [CCParticleBatchNode batchNodeWithTexture:particleTexture];
        [self addChild:iSpriteBatch z:1];
        [self addChild:iParticleBatch z:1];
        
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
        
        // This layer is updated
        [self scheduleUpdate];
        
        //Layers
        uiLayer = [UILayer node];
        [self addChild:uiLayer z:0];
        [uiLayer showTitleLabel: @""];
        [uiLayer assignGameplayLayer:self];
        
        //Particle System Initialization
        emitter = [CCParticleSystemQuad particleWithFile:@"White_Starburst.plist"];
        emitter.position = ccp(winSize.width/2, winSize.height/2);
        emitter.visible = NO;
        [self addChild:emitter];
        
        NSDictionary* defaultPreferences = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:0], @"disksDestroyed",
                                            [NSNumber numberWithInt:0], @"stateTimeAttackGameHighScore",
                                            [NSNumber numberWithInt:0], @"stateEliminationGameHighScore",
                                            [NSNumber numberWithInt:0], @"stateSurvivalGameHighScore",
                                            nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
        
        [self setGameState:[[StateMainMenu alloc] init]];
	}
	return self;
}

-(void) spawnFourDisks {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [self spawnDiskAtLocation:ccp(winSize.width/4, winSize.height/4) withColor:red];
    [self spawnDiskAtLocation:ccp(winSize.width*3/4, winSize.height/4) withColor:blue];
    [self spawnDiskAtLocation:ccp(winSize.width/4, winSize.height*3/4) withColor:yellow];
    [self spawnDiskAtLocation:ccp(winSize.width*3/4, winSize.height*3/4) withColor:green];
    
    ((CornerQuadrant*)[quadrants objectAtIndex:0]).color = red;
    ((CornerQuadrant*)[quadrants objectAtIndex:1]).color = yellow;
    ((CornerQuadrant*)[quadrants objectAtIndex:2]).color = blue;
    ((CornerQuadrant*)[quadrants objectAtIndex:3]).color = green;
}

-(void) setGameState:(GameState*)newState {
    m_NextGameState = newState;
}

-(void) changeState:(GameState*)newState {
    NSLog(@"----STATE TRANSITION----");
    
    if (m_GameState != NULL) {
        NSLog(@"From: %@", [m_GameState class]);
        [m_GameState exit];
        [self removeChild:m_GameState];
        [m_GameState release];
    }
    
    m_GameState = newState;
    NSLog(@"To: %@", [m_GameState class]);
    newState.manager = self;
    
    [self addChild:m_GameState];
    [m_GameState enter];
}

-(void) update:(ccTime)delta {
    // Update to a new state if state should change
    if (m_NextGameState != NULL) {
        [self changeState:m_NextGameState];
        m_NextGameState = NULL;
    }
    
    // Update all objects that need updating
    for (int i = 0; i < objects.count; i++) {
        [objects[i] update:delta];
    }
    
    // Update the current state
    [m_GameState update:delta];
    
    // Update objects that will be removed and no longer effect gameplay
    for (int i = 0; i < toBeRemoved.count; i++) {
        [toBeRemoved[i] update:delta];
    }
}

-(CornerQuadrant*) getQuadrantAtRect:(CGRect)rect {
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
    [self scheduleOnce:@selector(makeParticlesInvisible) delay:0.3f];
}

-(void) makeParticlesInvisible {
    emitter.visible = NO;
}

-(void) removeDisk:(Disk*)d retainVelocity:(BOOL)rv{
    [objects removeObject:d];
    [toBeRemoved addObject:d];
    [d removeDisk];
    
    if (!rv) {
        d.velocity = 0;
    }
}

-(void) spawnDiskAtRandomLocation {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    Disk* newDisk = [[Disk node] initWithParticlesInBatchNode:iParticleBatch];
    newDisk.gameplayLayer = self;
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
    for (Disk* d in objects) {
        if (abs(d.position.x - newDisk.position.x) <= newDiskRect.size.width / 10 && abs(d.position.y - newDisk.position.y) <= newDiskRect.size.height / 10) {
            if (newDisk.position.x < d.position.x) {
                newDisk.position = ccp(newDisk.position.x - newDiskRect.size.width / 10, newDisk.position.y);
            } else {
                newDisk.position = ccp(newDisk.position.x + newDiskRect.size.width / 10, newDisk.position.y);
            }
            
            if (newDisk.position.y < d.position.y) {
                newDisk.position = ccp(newDisk.position.y, newDisk.position.y - newDiskRect.size.height / 10);
            } else {
                newDisk.position = ccp(newDisk.position.y, newDisk.position.y + newDiskRect.size.height / 10);
            }
        }
    }
    
    // Makes sure the new disk isn't too close to borders
    if (newDisk.position.x < newDiskRect.size.width) {
        newDisk.position = ccp(newDiskRect.size.width * 3 / 2, newDisk.position.y);
    } else if (newDisk.position.x > winSize.width - newDiskRect.size.width) {
        newDisk.position = ccp(winSize.width - newDiskRect.size.width * 3 / 2, newDisk.position.y);
    }
    
    if (newDisk.position.y < newDiskRect.size.height) {
        newDisk.position = ccp(newDisk.position.x, newDiskRect.size.height * 3 / 2);
    } else if (newDisk.position.x > winSize.width - newDiskRect.size.width) {
        newDisk.position = ccp(newDisk.position.x, winSize.height - newDiskRect.size.height * 3 / 2);
    }
    
    [iSpriteBatch addChild:newDisk];
    [objects addObject:newDisk];
}

// Spawns one disk at a given location with random color
-(void) spawnDiskAtLocation:(CGPoint)location {
    enum Color c;
    
    switch (arc4random() % 4) {
        case 0:
            c = red;
            break;
        case 1:
            c = yellow;
            break;
        case 2:
            c = green;
            break;
        case 3:
            c = blue;
            break;
        default:
            c = blue;
            break;
    }
    
    [self spawnDiskAtLocation:location withColor:c];
}

// Spawns one disk at a given location with a given color
-(void) spawnDiskAtLocation:(CGPoint)location withColor:(enum Color)color {
    Disk* newDisk = [[Disk node] initWithParticlesInBatchNode:iParticleBatch];
    [newDisk setColor:color];
    newDisk.position = location;
    newDisk.gameplayLayer = self;
    newDisk.zOrder = diskZOrder++;
    [iSpriteBatch addChild:newDisk];
    [objects addObject:newDisk];
}

           
-(void) changeColorOfAllQuadrants {
    // Create an array corresponding with the four colors
    NSMutableArray* randomArray = [NSMutableArray new];
    for (int i = 0; i < quadrants.count; i++) {
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

-(void) changeColorOfAllQuadrantsTo:(enum Color)color {
    for(int i = 0; i < quadrants.count; i++) {
        CornerQuadrant* cq = quadrants[i];
        [cq setVisible:YES];
        cq.color = color;
    }
}

-(void) blinkQuadrants {
    for(CornerQuadrant *cq in quadrants) {
        CCBlink* blink = [CCBlink actionWithDuration:1 blinks:5];
        [cq runAction:blink];
    }
    [self scheduleOnce:@selector(changeColorOfAllQuadrants) delay:1];
}

- (void) clearAllDisks {
    // Remove all disks
    for(Disk* d in objects) {
        [toBeRemoved addObject:d];
        [d removeDisk];
        d.velocity = 0;
    }
    
    [objects removeAllObjects];
}

-(void) gameStart {
    // Double check to make sure the current GameState is actually a GameMode
    if ([m_GameState isKindOfClass:[GameMode class]]) {
        GameMode* gm = (GameMode*)m_GameState;
        [gm startGame];
    }
    
}

-(void)setAchievementValues:(NSMutableArray *)values {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber* numDisksDestroyed = [NSNumber numberWithInt:([(NSNumber*)[values objectAtIndex:0] intValue]+ + [(NSNumber*)[defaults objectForKey:@"disksDestroyed"] intValue])];
    
    [[NSUserDefaults standardUserDefaults] setObject:numDisksDestroyed forKey:@"disksDestroyed"];
    
    if((int)values[1] > [(NSNumber*)[defaults objectForKey:@"stateTimeAttackGameHighScore"] intValue]) {
        [defaults setObject:[values objectAtIndex:1] forKey:@"stateTimeAttackGameHighScore"];
    }
    
    if((int)values[2] > [(NSNumber*)(int)[defaults objectForKey:@"stateEliminationGameHighScore"] intValue]) {
        [defaults setObject:[values objectAtIndex:2] forKey:@"stateEliminationGameHighScore"];
    }
    
    if((int)values[3] > [(NSNumber*)(int)[defaults objectForKey:@"stateSurvivalGameHighScore"] intValue]) {
        [defaults setObject:[values objectAtIndex:3] forKey:@"stateSurvivalGameHighScore"];
    }
    
    [defaults synchronize];
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    [objects release];
    
    [toBeRemoved release];
    
    [quadrants release];
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
