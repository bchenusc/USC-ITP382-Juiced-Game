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

- (id)init
{
    self = [super init];
    if (self) {
        winSize = [[CCDirector sharedDirector] winSize];
        self.position = ccp(winSize.width / 2, winSize.height / 2);
        self.color = blue;
        self.width = winSize.width / 4;
        self.height = winSize.height / 2;
        self.thickness = 20;
    }
    return self;
}

-(NSMutableArray*)getCollidableArea {
    NSMutableArray* returnArray = [NSMutableArray new];
    CGRect firstRect = CGRectMake(m_Position.x, m_Position.y, m_Width, m_Thickness * ((self.height > 0) ? 1 : -1));
    CGRect secondRect = CGRectMake(m_Position.x, m_Position.y, m_Thickness * ((self.width > 0) ? 1 : -1), m_Height);
    [returnArray addObject:[NSValue valueWithCGRect:firstRect]];
    [returnArray addObject:[NSValue valueWithCGRect:secondRect]];
    return returnArray;
}

- (void)draw {
    glLineWidth(m_Thickness);
    switch (m_Color) {
        case blue:
            ccDrawColor4B(0, 0, 255, 255);
            break;
        case red:
            ccDrawColor4B(255, 0, 0, 255);
            break;
        case green:
            ccDrawColor4B(52, 199, 52, 255);
            break;
        case yellow:
            ccDrawColor4B(255, 255, 0, 255);
            break;
        default:
            break;
    }
    
    ccDrawLine(m_Position, ccp(m_Position.x + m_Width, m_Position.y));
    ccDrawLine(m_Position, ccp(m_Position.x, m_Position.y + m_Height));
}

@end
