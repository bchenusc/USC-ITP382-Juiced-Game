//
//  BMath.m
//  Juiced
//
//  Created by Brian Chen on 3/7/14.
//  Copyright (c) 2014 Silly Landmine Studios. All rights reserved.
//

#import "BMath.h"

@implementation BMath
+(float) Lerp : (float) start : (float) end : (float) lerpFactor{
    return start + (end-start) * lerpFactor;
}

@end
