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

// Create a corner quad with these values. You should use this if you want glowing effects to work properly
-(id) initWithPosition:(CGPoint)position width:(float)width height:(float)height color:(enum Color)color;

// Returns an array with two rects that make up this cornerquadrant
-(NSMutableArray*) getCollidableArea;

// Set color of quadrant
-(void) setColorOfQuad:(enum Color)color;

// Set height of quadrant
-(void) setQuadHeight:(CGFloat)height;

// Set width of quadrant
-(void) setQuadWidth:(CGFloat)width;

@property (readonly) enum Color color;
@property (readonly) CGFloat width;
@property (readonly) CGFloat height;
@property CGPoint position;
@property int thickness;

@end
