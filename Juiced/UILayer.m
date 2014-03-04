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
        m_TitleLabel = [CCLabelTTF labelWithString:@"" fontName: @"Fatsans" fontSize:30];
        m_TitleLabel.position = ccp(size.width/2, size.height/2 + 20);
        m_TitleLabel.visible = NO;
        [self addChild : m_TitleLabel];
        
        m_TitleSprite = [CCSprite spriteWithFile:@"juiced.png"];
        m_TitleSprite.position = ccp(size.width/2, size.height/2 + 20);
        [self addChild:m_TitleSprite];
        
        //Score
        m_ScoreLabel = [CCLabelTTF labelWithString:@"Score" fontName: @"Fatsans" fontSize:12];
        m_ScoreLabel.position = ccp(size.width/2, 10);
        m_ScoreLabel.visible = NO;
        [self addChild:m_ScoreLabel];
        
        //Timer
        m_TimeLabel =[CCLabelTTF labelWithString:@"Time: " fontName: @"Fatsans" fontSize:12];
        m_TimeLabel.position = ccp(size.width/2, size.height - 10);
        m_TimeLabel.visible = NO;
        [self addChild : m_TimeLabel];
        
        //Instructions label
        m_IntroLabel =[CCLabelTTF labelWithString:@"Slide A Disk To Play " fontName: @"Fatsans" fontSize:12];
        //[self performSelector:@selector(FlashALabel) withObject:m_IntroLabel];
        m_IntroLabel.position = ccp(size.width/2, size.height/2 - 10);
        m_IntroLabel.visible = YES;
        [self addChild : m_IntroLabel];
        
        //Score Multiplier
        m_MultLabel = [CCLabelTTF labelWithString:@"Placeholder" fontName:@"Fatsans" fontSize:72];
        m_MultLabel.position = ccp(size.width/2, size.height/2);
        m_MultLabel.visible = NO;
        [self addChild:m_MultLabel];
        
        //Particle Systems
        m_MultParticleL = [CCParticleSystemQuad particleWithFile:@"Score_Mult_L.plist"];
        m_MultParticleL.position = ccp(size.width/2 - 100, 3*size.height/4);
        m_MultParticleL.visible = NO;
        [self addChild:m_MultParticleL];
        
        m_MultParticleR = [CCParticleSystemQuad particleWithFile:@"Score_Mult_R.plist"];
        m_MultParticleR.position = ccp(size.width/2 + 100, 3*size.height/4);
        m_MultParticleR.visible = NO;
        [self addChild:m_MultParticleR];
        
    }
    return self;
}

-(void) AssignGameplayLayer : (GameplayLayer* ) layer{
    m_GameplayLayer = layer;
}

-(void)FlashALabel : (CCLabelTTF*) label{
    if (label.opacity == 0){
        [label runAction:[CCFadeIn actionWithDuration:0.1]];
    }
    else{
        [label runAction:[CCFadeOut actionWithDuration:0.1]];
    }
}

- (void) StartAGame{
    //Make sure to send the points system back down to where it belongs.
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    score_go_to = ccp(size.width/2, 10);
    if (ccpDistanceSQ(m_ScoreLabel.position, score_go_to) > 4){
        [self schedule:@selector(SlideScoreDown) interval:0.01];
    }
    [m_IntroLabel runAction:[CCFadeOut actionWithDuration:0.1]];
    if (m_TitleSprite.opacity != 0) {
        [m_TitleSprite runAction:[CCFadeOut actionWithDuration:0.1]];
    } else {
        m_TitleSprite.visible = NO;
    }
    //<!--New Game Button -->
    //[m_itemNewGame setIsEnabled:FALSE];
    //[m_itemNewGame runAction: [CCFadeOut actionWithDuration:0.1]];
    
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

- (void) hideIntroLabel{
    m_IntroLabel.visible = NO;
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
    m_TimeLabel.visible = NO;
}
- (void) showMultiplierLabel: (int) multiplier{
    m_MultLabel.string = [NSString stringWithFormat:@"x%d!!", multiplier];
    m_MultLabel.visible = YES;
    m_MultParticleL.visible = YES;
    [m_MultParticleL resetSystem];
    m_MultParticleR.visible = YES;
    [m_MultParticleR resetSystem];
}
- (void) hideMultiplierLabel {
    m_MultLabel.visible = NO;
    m_MultParticleL.visible = NO;
    m_MultParticleR.visible = NO;
}

- (void) showGameOver{
    CGSize size = [[CCDirector sharedDirector] winSize];
    score_go_to= ccp(size.width/2, size.height/2 - 10);
    [self schedule:@selector(SlideScoreUp) interval:0.01];
}

- (void) SlideScoreUp
{
    m_ScoreLabel.position = ccpAdd(m_ScoreLabel.position,
                                   ccpMult(ccpNormalize(ccpSub(score_go_to, m_ScoreLabel.position)),
                                   5));
    m_ScoreLabel.fontSize += 0.5;
    
    if (ccpDistanceSQ(m_ScoreLabel.position, score_go_to) <= 2){
        [self unschedule:@selector(SlideScoreUp)];
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //When the game is actually over:
        [self showTitleLabel:@"Your Score:"];
        [m_TitleLabel runAction:[CCFadeIn actionWithDuration:0.2]];
        m_IntroLabel.position = ccp(size.width/2, size.height/2 - 40);
        [m_IntroLabel runAction:[CCFadeIn actionWithDuration:0.1]];
        [self hideTimeLabel];
        
        //[m_itemNewGame setIsEnabled:TRUE];
        /*<!--New Game Button -->
        CGSize size = [[CCDirector sharedDirector] winSize];
        m_Menu.position = ccp(size.width/2, size.height/2 - 40);
        [m_itemNewGame runAction: [CCFadeIn actionWithDuration: 2]];*/
    }
}

- (void) SlideScoreDown
{
    
    m_ScoreLabel.position = ccpAdd(m_ScoreLabel.position,
                                   ccpMult(ccpNormalize(ccpSub(score_go_to, m_ScoreLabel.position)),
                                           5));
    m_ScoreLabel.fontSize -= 0.5;
    
    if (ccpDistanceSQ(m_ScoreLabel.position, score_go_to) <= 2){
        CGSize size = [[CCDirector sharedDirector] winSize];
        [self unschedule:@selector(SlideScoreDown)];
        m_ScoreLabel.fontSize = 12;
        m_ScoreLabel.position = ccp(size.width/2, 10);
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
