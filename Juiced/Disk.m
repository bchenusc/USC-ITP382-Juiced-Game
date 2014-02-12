//
//  Disk.m
//  Juiced
//
//  Created by Matthew Pohlmann on 2/11/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "Disk.h"
#import "cocos2d.h"

#pragma mark - Disk

@implementation Disk

- (id)init
{
    self = [super init];
    if (self) {
        self.position = ccp(30, 60);
        radius = 30;
        
        CGSize c_size;
        c_size.width = 2 * radius;
        c_size.height = 2 * radius;
        self.contentSize = c_size;
        self.anchorPoint = ccp(0.5, 0.5);
    }
    return self;
}

- (CGRect) rect {
    return CGRectMake(self.position.x - self.contentSize.width * self.anchorPoint.x,
                      self.position.y - self.contentSize.height * self.anchorPoint.y,
                      self.contentSize.width,
                      self.contentSize.height);
}

- (void)draw {
    glLineWidth(4);
    ccDrawColor4B(0, 0, 255, 255);
    
    ccDrawSolidCircle([[CCDirector sharedDirector] convertToGL:self.position], radius, 256);
    //ccDrawSolidCircle(self.position, radius, 256);
}

@end
