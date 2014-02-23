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
        
        //Title
        m_TitleLabel = [CCLabelTTF labelWithString:@"JUICED" fontName: @"Marker Felt" fontSize:30];
        m_TitleLabel.position = ccp(size.width/2, size.height/2 + 20);
        m_TitleLabel.visible = NO;
        [self addChild : m_TitleLabel];
        
        //Score
        m_ScoreLabel = [CCLabelTTF labelWithString:@"Score" fontName: @"Marker Felt" fontSize:12];
        m_ScoreLabel.position = ccp(size.width/2, 10);
        m_ScoreLabel.visible = NO;
        [self addChild:m_ScoreLabel];
        
        //Timer
        m_TimeLabel =[CCLabelTTF labelWithString:@"Time: " fontName: @"Marker Felt" fontSize:12];
        m_TimeLabel.position = ccp(size.width/2, size.height - 10);
        m_TimeLabel.visible = NO;
        [self addChild : m_TimeLabel];
        
    }
    return self;
}

- (void) showDemoButton : (GameplayLayer*) game Size: (CGSize) size
{
    m_GameplayLayer = game;
    
    //Menu Items
    CCLabelTTF* mylabel = [CCLabelTTF labelWithString:@"Play Demo"  fontName:@"Marker Felt" fontSize:10];
    m_itemNewGame = [CCMenuItemLabel itemWithLabel:mylabel target:self selector:@selector(StartAGame)];
    m_Menu = [CCMenu menuWithItems:m_itemNewGame, nil];
    
    [m_Menu alignItemsVerticallyWithPadding:20];
    if (size.height > size.width){
        [m_Menu setPosition:ccp( size.height/2, size.width/2-5)];
    }
    else
    {
        [m_Menu setPosition:ccp(size.width/2, size.height/2 -5)];
    }
    
    // Add the menu to the layer
    [self addChild: m_Menu];
    
}

- (void) StartAGame{
    [m_itemNewGame setIsEnabled:FALSE];
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
      [CCCallFunc actionWithTarget:self selector:@selector(hideTitleLabel)],
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

- (void) showTitleLabel : (NSString*) text{
    m_TitleLabel.string = text;
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
    CGSize size = [[CCDirector sharedDirector] winSize];
    score_go_to= ccp(size.width/2, size.height/2 - 10);
    [self schedule:@selector(SlideToEffect) interval:0.01];
}

- (void) SlideToEffect
{
    m_ScoreLabel.position = ccpAdd(m_ScoreLabel.position,
                                   ccpMult(ccpNormalize(ccpSub(score_go_to, m_ScoreLabel.position)),
                                   5));
    m_ScoreLabel.fontSize += 0.5;
    
    if (ccpDistanceSQ(m_ScoreLabel.position, score_go_to) <= 2){
        [self unschedule:@selector(SlideToEffect)];
        
        //When the game is actually over:
        [self showTitleLabel:@"Your Score:"];
        [m_TitleLabel runAction:[CCFadeIn actionWithDuration:0.2]];
        [m_itemNewGame setIsEnabled:TRUE];
        CGSize size = [[CCDirector sharedDirector] winSize];
        m_Menu.position = ccp(size.width/2, size.height/2 - 40);
        [m_itemNewGame runAction: [CCFadeIn actionWithDuration: 2]];
    }
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
