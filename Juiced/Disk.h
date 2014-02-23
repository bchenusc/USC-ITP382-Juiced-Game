//
//  Disk.h
//  Juiced
//
//  Created by Matthew Pohlmann on 2/11/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "CCSprite.h"

enum Color {
    red,
    blue,
    green,
    yellow
};

@interface Disk : CCSprite {
    enum Color iColor;
    float radius;
    CGSize winSize;
    CGPoint iVelocity;
}

@property enum Color color;
@property CGPoint velocity;

- (CGRect) rect;

-(void)update:(ccTime)delta;

@end
