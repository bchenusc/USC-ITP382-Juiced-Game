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

#import "GameplayLayer.h"
#import "BMath.h"

// HelloWorldLayer implementation
@implementation UILayer


// on "init" you need to initialize your instance
-(id) init {
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
        m_ScoreLabel = [CCLabelTTF labelWithString:@"Score" fontName: @"Fatsans" fontSize:150];
        m_ScoreLabel.opacity = 60;
        m_ScoreLabel.position = ccp(size.width/2, size.height/2);
        m_ScoreLabel.visible = NO;
        
        [self addChild:m_ScoreLabel];
        
        //Timer
        m_TimeLabel =[CCLabelTTF labelWithString:@"Time: " fontName: @"Fatsans" fontSize:12];
        m_TimeLabel.position = ccp(size.width/2, size.height - 20);
        m_TimeLabel.visible = NO;
        [self addChild : m_TimeLabel];
        
        //Labels for what goes where.
        m_TimeAttackLabel = [CCLabelTTF labelWithString:@"Time Attack" fontName: @"Fatsans" fontSize:12];
        m_TimeAttackLabel.position = ccp(55, 20);
        m_TimeAttackLabel.visible = YES;
        [self addChild : m_TimeAttackLabel];
        
        m_SurvivalLabel = [CCLabelTTF labelWithString:@"Survival" fontName: @"Fatsans" fontSize:12];
        m_SurvivalLabel.position = ccp(size.width - 43, size.height - 20);
        m_SurvivalLabel.visible = YES;
        [self addChild : m_SurvivalLabel];
        
        m_EliminationLabel = [CCLabelTTF labelWithString:@"Elimination" fontName: @"Fatsans" fontSize:12];
        m_EliminationLabel.position = ccp(50, size.height - 20);
        m_EliminationLabel.visible = YES;
        [self addChild : m_EliminationLabel];
        
        m_AchievementLabel = [CCLabelTTF labelWithString:@"Achievements" fontName: @"Fatsans" fontSize:12];
        m_AchievementLabel.position = ccp(size.width - 65, 20);
        m_AchievementLabel.visible = YES;
        [self addChild : m_AchievementLabel];
        
        
        //Instructions label
        m_IntroLabel =[CCLabelTTF labelWithString:@"Slide A Disk To Play " fontName: @"Fatsans" fontSize:12];
        m_IntroLabel.position = ccp(size.width/2, size.height/2 - 10);
        m_IntroLabel.visible = YES;
        [self addChild : m_IntroLabel];
        
        //Score Multiplier
        m_MultLabel = [CCLabelTTF labelWithString:@"Placeholder" fontName:@"Fatsans" fontSize:12];
        m_MultLabel.position = ccp(size.width/2, 10);
        m_MultLabel.visible = NO;
        //m_MultLabel.opacity = 50;
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

-(void) assignGameplayLayer : (GameplayLayer* ) layer {
    m_GameplayLayer = layer;
}

-(void) flashALabel : (CCLabelTTF*) label {
    if (label.opacity == 0){
        [label runAction:[CCFadeIn actionWithDuration:0.1]];
    }
    else{
        [label runAction:[CCFadeOut actionWithDuration:0.1]];
    }
}

-(void) startAGame {
    //Make sure to send the points system back down to where it belongs.
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    score_go_to = ccp(size.width/2, size.height/2);
    if (ccpDistanceSQ(m_ScoreLabel.position, score_go_to) > 4){
        [self schedule:@selector(slideScoreDown) interval:0.01];
    }
    [m_ScoreLabel runAction:[CCFadeOut  actionWithDuration:0.1]];
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
      [CCCallFunc actionWithTarget:self selector:@selector(FadeOutGameModeLabels)],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(iReady)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      
      [CCFadeOut actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(iSet)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      
      
      [CCFadeOut actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(iBegin)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      [CCFadeOut actionWithDuration:0.2],
      [CCCallFunc actionWithTarget:self selector:@selector(hideTitleLabel)],
      [CCCallFunc actionWithTarget:self selector:@selector(showZeroLabel)],
      [CCCallFunc actionWithTarget:m_GameplayLayer selector:@selector(gameStart)],
      nil
      ]
     ];
}

-(void)startARound:(int)roundNumber {
    [m_TitleLabel setVisible:YES];
    m_TitleLabel.string = [NSString stringWithFormat:@"Round %d", roundNumber];
    
    [m_TitleLabel runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:.2],
      [CCDelayTime actionWithDuration:.1],
      [CCFadeIn actionWithDuration:.2],
      [CCDelayTime actionWithDuration:.5],
     
      [CCFadeOut actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(iReady)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      
      [CCFadeOut actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(iSet)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      
      
      [CCFadeOut actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.1],
      [CCCallFunc actionWithTarget:self selector:@selector(iBegin)],
      [CCFadeIn actionWithDuration:0.2],
      [CCDelayTime actionWithDuration:0.5],
      [CCFadeOut actionWithDuration:0.2],
      [CCCallFunc actionWithTarget:self selector:@selector(hideTitleLabel)],
      nil
      ]
     ];
}

-(void) hideIntroLabel {
    m_IntroLabel.visible = NO;
}

-(void) FadeOutGameModeLabels{
    [m_TimeAttackLabel runAction:[CCFadeOut actionWithDuration:0.1]];
    [m_AchievementLabel runAction:[CCFadeOut actionWithDuration:0.1]];
    [m_SurvivalLabel runAction:[CCFadeOut actionWithDuration:0.1]];
    [m_EliminationLabel runAction:[CCFadeOut actionWithDuration:0.1]];
}

-(void) FadeInGameModeLabels{
    [m_TimeAttackLabel runAction:[CCFadeIn actionWithDuration:0.1]];
    [m_AchievementLabel runAction:[CCFadeIn actionWithDuration:0.1]];
    [m_SurvivalLabel runAction:[CCFadeIn actionWithDuration:0.1]];
    [m_EliminationLabel runAction:[CCFadeIn actionWithDuration:0.1]];
}

-(void) iReady {
    m_TitleLabel.string = @"Ready";
}

-(void) iSet {
    m_TitleLabel.string = @"Set";
}

-(void) iBegin {
    m_TitleLabel.string = @"Begin";
}

-(void) showTitleLabel : (NSString*) text {
    m_TitleLabel.string = text;
    m_TitleLabel.visible = YES;
}

-(void) hideTitleLabel {
    m_TitleLabel.visible = NO;
}

-(void) showZeroLabel{
    m_ScoreLabel.opacity = 80;
    [self showScoreLabel:0];
}

-(void) showScoreLabel : (int) score {
    if (m_ScoreLabel.opacity == 0){
        [m_ScoreLabel runAction:[CCFadeIn actionWithDuration:0.1]];
    }
    m_ScoreLabel.string = [NSString stringWithFormat:@"%d", score];
    m_ScoreLabel.fontSize = 300 / powf((floorf(log10f(score)) + 1 ), 0.5f);
    m_ScoreLabel.visible = YES;
}

-(void) hideScoreLabel{
    m_ScoreLabel.visible = NO;
}

-(void) showTimeLabel: (int) time {
    m_TimeLabel.string = [NSString stringWithFormat:@"%d s", time];
    m_TimeLabel.visible = YES;
}

-(void) hideTimeLabel {
    m_TimeLabel.visible = NO;
}

-(void) showMultiplierLabel: (int) multiplier {
    if (multiplier == 1){
        [self hideMultiplierLabel];
        return;
    }else
    {
        m_MultLabel.string = [NSString stringWithFormat:@"%d", multiplier];
    }
    m_MultLabel.visible = YES;
    m_MultParticleL.visible = YES;
    [m_MultParticleL resetSystem];
    m_MultParticleR.visible = YES;
    [m_MultParticleR resetSystem];
}

-(void) multiplierEmphasize{
    id grow = [CCScaleTo actionWithDuration:0.2f scale:1.5f];
    id shrink = [CCScaleTo actionWithDuration:0.2f scale:1.0f];
    id sequence = [CCSequence actions:grow, shrink, nil];
    
    [m_MultLabel runAction:sequence];
}

-(void) hideMultiplierLabel {
    m_MultLabel.visible = NO;
    m_MultParticleL.visible = NO;
    m_MultParticleR.visible = NO;
}

-(void) showGameOver {
    CGSize size = [[CCDirector sharedDirector] winSize];
    score_go_to= ccp(size.width/2, size.height/2 - 10);
    [self hideMultiplierLabel];
    //[self slideScoreUp];
    
    [self schedule:@selector(slideScoreUp) interval:0.01];
}

-(void) slideScoreUp {
    m_ScoreLabel.position = ccpAdd(m_ScoreLabel.position,
                                   ccpMult(ccpNormalize(ccpSub(score_go_to, m_ScoreLabel.position)),
                                   2));
    m_ScoreLabel.fontSize = clampf(m_ScoreLabel.fontSize-50, 50, 100);
    m_ScoreLabel.opacity = clampf(m_ScoreLabel.opacity + 50, 0, 255);
    
    if (ccpDistanceSQ(m_ScoreLabel.position, score_go_to) <= 2){
        m_ScoreLabel.fontSize = 50;
        [self unschedule:@selector(slideScoreUp)];
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //When the game is actually over:
        [self showTitleLabel:@"Your Score:"];
        [m_TitleLabel runAction:[CCFadeIn actionWithDuration:0.2]];
        m_IntroLabel.position = ccp(size.width/2, size.height/2 - 40);
        [m_IntroLabel runAction:[CCFadeIn actionWithDuration:0.1]];
        [self FadeInGameModeLabels];
        [self hideTimeLabel];
        
        //[m_itemNewGame setIsEnabled:TRUE];
        /*<!--New Game Button -->
        CGSize size = [[CCDirector sharedDirector] winSize];
        m_Menu.position = ccp(size.width/2, size.height/2 - 40);
        [m_itemNewGame runAction: [CCFadeIn actionWithDuration: 2]];*/
    }
}

-(void) slideScoreDown {
    
    m_ScoreLabel.position = ccpAdd(m_ScoreLabel.position,
                                   ccpMult(ccpNormalize(ccpSub(score_go_to, m_ScoreLabel.position)),
                                        5));
    m_ScoreLabel.visible = NO;
    
    //m_ScoreLabel.fontSize = clampf(m_ScoreLabel.fontSize+30, 50, 150);

    if (ccpDistanceSQ(m_ScoreLabel.position, score_go_to) <= 2){
        m_GameplayLayer.score = 0;
        CGSize size = [[CCDirector sharedDirector] winSize];
        [self unschedule:@selector(slideScoreDown)];
        m_ScoreLabel.fontSize = 150;
        m_ScoreLabel.position = ccp(size.width/2, size.height/2);
        m_ScoreLabel.opacity = 80;
    }
}


// on "dealloc" you need to release all your retained objects
-(void) dealloc {
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
