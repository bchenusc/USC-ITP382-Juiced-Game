//
//  CornerQuadrant.h
//  Juiced
//
//  Created by David Zhang on 2/18/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "CCSprite.h"

#import "cocos2d.h"
#import "Disk.h"

@interface CornerQuadrant : CCSprite {
    enum Color m_Color;
    CGSize winSize;
    CGFloat m_Width;
    CGFloat m_Height;
    CGPoint m_Position;
    int m_Thickness;
}

// Returns an array with two rects that make up this cornerquadrant
-(NSMutableArray*) getCollidableArea;

@property enum Color color;
@property CGFloat width;
@property CGFloat height;
@property CGPoint position;
@property int thickness;

@end
