//
//  CornerQuadrant.h
//  Juiced
//
//  Created by David Zhang on 2/18/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "CCSprite.h"

#import "cocos2d.h"

enum Color {
    red,
    blue,
    yellow,
    green
};

@interface CornerQuadrant : CCSprite {
    enum Color m_Color;
    CGFloat m_Width;
    CGFloat m_Height;
    CGPoint m_Position;
}

@property enum Color color;
@property CGFloat width;
@property CGFloat height;
@property CGPoint position;

@end
