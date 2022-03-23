//
//  Creator.m
//  Testing-CBTests
//
//  Created by Islom Babaev on 23/03/22.
//

#import <Foundation/Foundation.h>
#import "Creator.h"

@implementation Creator

+(id)create:(NSString*)className {
    return [[NSClassFromString(className) alloc] init];
}

@end
