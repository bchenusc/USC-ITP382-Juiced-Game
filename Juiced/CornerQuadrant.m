//
//  CornerQuadrant.m
//  Juiced
//
//  Created by David Zhang on 2/18/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "CornerQuadrant.h"

@implementation CornerQuadrant

@synthesize color = m_Color;
@synthesize width = m_Width;
@synthesize height = m_Height;
@synthesize position = m_Position;
@synthesize thickness = m_Thickness;

- (id)init {
    self = [super init];
    if (self) {
        winSize = [[CCDirector sharedDirector] winSize];
        self.position = ccp(winSize.width / 2, winSize.height / 2);
        m_Color = blue;
        m_Width = winSize.width / 4;
        m_Height = winSize.height / 2;
        self.thickness = round(0.025 * winSize.height);
    }
    return self;
}

-(id) initWithPosition:(CGPoint)position width:(float)width height:(float)height color:(enum Color)color {
    self.position = position;
    m_Color = color;
    m_Width = width;
    m_Height = height;
    
    CCSprite* glowSprite = [CCSprite spriteWithFile:@"GlowSprite.png"];
    glowSprite.scaleX = self.thickness / glowSprite.boundingBox.size.width;
    glowSprite.scaleY = self.height / glowSprite.boundingBox.size.height;
    switch (color) {
        case blue:
            [glowSprite setColor:ccc3(0, 51, 255)];
            break;
        case red:
            [glowSprite setColor:ccc3(255, 51, 0)];
            break;
        case green:
            [glowSprite setColor:ccc3(34, 255, 34)];
            break;
        case yellow:
            [glowSprite setColor:ccc3(255, 204, 0)];
            break;
        default:
            [glowSprite setColor:ccc3(0, 0, 0)];
            break;
    }
    [glowSprite setPosition:ccp(position.x + self.thickness / 2 * ((self.width > 0) ? 1 : -1), position.y + self.height / 2)];
    [glowSprite runAction: [CCRepeatForever actionWithAction: [CCSequence actions:
            [CCScaleTo actionWithDuration:0.10f scaleX:glowSprite.scaleX * 3.50f scaleY:glowSprite.scaleY],
            [CCScaleTo actionWithDuration:0.10f scaleX:glowSprite.scaleX * 3.00f scaleY:glowSprite.scaleY], nil]]];
    [glowSprite runAction: [CCRepeatForever actionWithAction: [CCSequence actions:
            [CCFadeTo actionWithDuration:0.10f opacity:150],
            [CCFadeTo actionWithDuration:0.10f opacity:230], nil]]];
    [self addChild:glowSprite];
    
    CCSprite* glowSprite2 = [CCSprite spriteWithFile:@"GlowSprite.png"];
    glowSprite2.scaleX = self.thickness / glowSprite2.boundingBox.size.width;
    glowSprite2.scaleY = self.width / glowSprite2.boundingBox.size.height;
    switch (color) {
        case blue:
            [glowSprite2 setColor:ccc3(0, 51, 255)];
            break;
        case red:
            [glowSprite2 setColor:ccc3(255, 0, 51)];
            break;
        case green:
            [glowSprite2 setColor:ccc3(34, 255, 34)];
            break;
        case yellow:
            [glowSprite2 setColor:ccc3(255, 204, 0)];
            break;
        default:
            [glowSprite2 setColor:ccc3(0, 0, 0)];
            break;
    }
    [glowSprite2 setPosition:ccp(position.x + self.width / 2, position.y + self.thickness / 2 * ((self.height > 0) ? 1 : -1))];
    [glowSprite2 setRotation:90];
    [glowSprite2 runAction: [CCRepeatForever actionWithAction: [CCSequence actions:
                [CCScaleTo actionWithDuration:0.10f scaleX:glowSprite2.scaleX * 3.50f scaleY:glowSprite2.scaleY],
                [CCScaleTo actionWithDuration:0.10f scaleX:glowSprite2.scaleX * 3.00f scaleY:glowSprite2.scaleY], nil]]];
    [glowSprite2 runAction: [CCRepeatForever actionWithAction: [CCSequence actions:
                [CCFadeTo actionWithDuration:0.10f opacity:150],
                [CCFadeTo actionWithDuration:0.10f opacity:230], nil]]];
    [self addChild:glowSprite2];
    
    return self;
}

-(void) setColorOfQuad:(enum Color)color {
    m_Color = color;
    ccColor3B c;
    
    switch (color) {
        case blue:
            c = ccc3(0, 51, 255);
            break;
        case red:
            c = ccc3(255, 0, 51);
            break;
        case green:
            c = ccc3(34, 255, 34);
            break;
        case yellow:
            c = ccc3(255, 204, 0);
            break;
        default:
            c =ccc3(0, 0, 0);
            break;
    }
    
    for (int i = self.children.count - 1; i >= 0; i--) {
        CCSprite* s = [self.children objectAtIndex:i];
        [s setColor:c];
    }
}

// Set height of quadrant
-(void) setQuadHeight:(CGFloat)height {
    m_Height = height;
    
    CCSprite* vert = [self.children objectAtIndex:0];
    
    vert.scaleY = m_Height / 60;
    [vert setPosition:ccp(m_Position.x + self.thickness / 2 * ((m_Width > 0) ? 1 : -1), m_Position.y + m_Height / 2)];
}

// Set width of quadrant
-(void) setQuadWidth:(CGFloat)width {
    m_Width = width;
    
    CCSprite* hor = [self.children objectAtIndex:1];
    
    hor.scaleY = m_Width / 60;
    [hor setPosition:ccp(m_Position.x + m_Width / 2, m_Position.y + self.thickness / 2 * ((m_Height > 0) ? 1 : -1))];
}

-(NSMutableArray*) getCollidableArea {
    NSMutableArray* returnArray = [NSMutableArray new];
    CGRect firstRect = CGRectMake(m_Position.x, m_Position.y, m_Width, m_Thickness * ((self.height > 0) ? 1 : -1));
    CGRect secondRect = CGRectMake(m_Position.x, m_Position.y, m_Thickness * ((self.width > 0) ? 1 : -1), m_Height);
    [returnArray addObject:[NSValue valueWithCGRect:firstRect]];
    [returnArray addObject:[NSValue valueWithCGRect:secondRect]];
    return returnArray;
}

- (void) draw {
    ccColor4F color;
    switch (m_Color) {
        case blue:
            color = ccc4FFromccc4B(ccc4(0, 51, 255, 255));
            break;
        case red:
            color = ccc4FFromccc4B(ccc4(255, 0, 51, 255));
            break;
        case green:
            color = ccc4FFromccc4B(ccc4(0, 255, 51, 255));
            break;
        case yellow:
            color = ccc4FFromccc4B(ccc4(255, 204, 0, 255));
            break;
        default:
            return;
    }
    
    ccDrawSolidRect(m_Position, ccp(m_Position.x + m_Width, m_Position.y + m_Thickness * ((self.height > 0) ? 1 : -1)), color);
    ccDrawSolidRect(m_Position, ccp(m_Position.x + m_Thickness * ((self.width > 0) ? 1 : -1), m_Position.y + m_Height), color);
}

@end
