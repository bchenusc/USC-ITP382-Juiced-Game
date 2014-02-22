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

#pragma mark - UILayer

// HelloWorldLayer implementation
@implementation UILayer

// on "init" you need to initialize your instance
-(id) init
{
    self = [super init];
    
    
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        m_TitleLabel = [CCLabelTTF labelWithString:@"JUICED" fontName: @"Marker Felt" fontSize:30];
        m_TitleLabel.position = ccp(size.width/2, size.height/2);
        m_TitleLabel.visible = NO;
        [self addChild : m_TitleLabel];
        
        m_ScoreLabel = [CCLabelTTF labelWithString:@"Score" fontName: @"Marker Felt" fontSize:30];
        m_ScoreLabel.position = ccp(size.width/2, -size.height/2 + 10);
        m_ScoreLabel.visible = NO;
        [self addChild:m_ScoreLabel];
        
        m_TimeLabel =[CCLabelTTF labelWithString:@"Time: " fontName: @"Marker Felt" fontSize:26];
        m_TimeLabel.position = ccp(size.width/2, size.height/2 + 10);
        m_TimeLabel.visible = NO;
        [self addChild : m_TimeLabel];
    }
    return self;
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
