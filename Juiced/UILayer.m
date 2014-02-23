//
//  UILayer.m
//  duckhunt
//
//  Created by ITP Student on 1/27/14.
//
//

// Import the interfaces
#import "UILayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// HelloWorldLayer implementation
@implementation UILayer


// on "init" you need to initialize your instance
-(id) init
{
    self = [super init];
    
    
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        
        m_TitleLabel = [CCLabelTTF labelWithString:@"JUICED" fontName: @"Marker Felt" fontSize:30];
        m_TitleLabel.position = ccp(size.width/2, size.height/2 + 10);
        m_TitleLabel.visible = NO;
        [self addChild : m_TitleLabel];
        
        m_ScoreLabel = [CCLabelTTF labelWithString:@"Score" fontName: @"Marker Felt" fontSize:12];
        m_ScoreLabel.position = ccp(size.width/2, size.height - 10);
        m_ScoreLabel.visible = NO;
        [self addChild:m_ScoreLabel];
        
        m_TimeLabel =[CCLabelTTF labelWithString:@"Time: " fontName: @"Marker Felt" fontSize:12];
        m_TimeLabel.position = ccp(size.width/2, 10);
        m_TimeLabel.visible = NO;
        [self addChild : m_TimeLabel];
        
        b_TitleCanTransition = true;
        
    }
    return self;
}

- (void) showDemoButton : (GameplayLayer*) game Size: (CGSize) size
{
    m_GameplayLayer = game;
    
    // Achievement Menu Item using blocks
    CCLabelTTF* mylabel = [CCLabelTTF labelWithString:@"Demo"  fontName:@"Marker Felt" fontSize:10];
    
    m_itemNewGame = [CCMenuItemLabel itemWithLabel:mylabel target:self selector:@selector(StartAGame)];
    
    //CCMenuItemLabel *itemNewGame = [CCMenuItemFont itemWithString:@"DEMO" block:^(id sender) {
        
    //}];
    
    m_itemNewGame.position = ccp(size.width/2, size.height/2 -20);
    
    
    
    CCMenu *menu = [CCMenu menuWithItems:m_itemNewGame, nil];
    
    [menu alignItemsVerticallyWithPadding:20];
    if (size.height > size.width){
        [menu setPosition:ccp( size.height/2, size.width/2 - 125)];
    }
    else
    {
        [menu setPosition:ccp(size.width/2, size.height/2 - 125 )];
    }
    
    // Add the menu to the layer
    [self addChild:menu];
    
}

- (void) StartAGame{
    
    [m_itemNewGame runAction: [CCFadeOut actionWithDuration:0.1]];
    
    [m_TitleLabel runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(Ready)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      
      [CCFadeOut actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(Set)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      
      
      [CCFadeOut actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(Begin)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      [CCFadeOut actionWithDuration:0.2],
      [CCCallFunc actionWithTarget:m_GameplayLayer selector:@selector(gameStart)],
      nil
      ]
     ];
}

- (void) Ready{
    m_TitleLabel.string = @"Ready";
}
- (void) Set{
    m_TitleLabel.string = @"Set";
}
- (void) Begin{
    m_TitleLabel.string = @"Begin";
}

- (void) showTitleLabel{
    m_TitleLabel.visible = YES;
}
- (void) hideTitleLabel{
    m_TitleLabel.visible = NO;
}
- (void) showScoreLabel : (int) score{
    m_ScoreLabel.string = [NSString stringWithFormat:@"%d pts", score];
    m_ScoreLabel.visible = YES;
}
- (void) hideScoreLabel{
    m_ScoreLabel.visible = NO;
}
- (void) showTimeLabel: (int) time{
    m_TimeLabel.string = [NSString stringWithFormat:@"%d s", time];
    m_TimeLabel.visible = YES;
}
- (void) hideTimeLabel{
    m_TimeLabel.visible = YES;
}

- (void) showGameOver{
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
