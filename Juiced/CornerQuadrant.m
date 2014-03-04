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
        self.color = blue;
        self.width = winSize.width / 4;
        self.height = winSize.height / 2;
        self.thickness = round(0.025 * winSize.height);
    }
    return self;
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
            color = ccc4FFromccc3B(ccc3(0, 0, 255));
            break;
        case red:
            color = ccc4FFromccc3B(ccc3(255, 0, 0));
            break;
        case green:
            color = ccc4FFromccc3B(ccc3(52, 199, 52));
            break;
        case yellow:
            color = ccc4FFromccc3B(ccc3(255, 255, 0));
            break;
        default:
            return;
    }
    
    ccDrawSolidRect(m_Position, ccp(m_Position.x + m_Width, m_Position.y + m_Thickness * ((self.height > 0) ? 1 : -1)), color);
    ccDrawSolidRect(m_Position, ccp(m_Position.x + m_Thickness * ((self.width > 0) ? 1 : -1), m_Position.y + m_Height), color);
}

@end
