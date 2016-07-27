//
//  GAWrapper.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/27.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "GAWrapper.h"
#import <GAIDictionaryBuilder.h>
#import <GAIFields.h>

@implementation GAWrapper

+ (void)sendReport:(NSString *)action
       andProperty:(NSString *)property
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:action
                                                           label:property
                                                           value:nil] build]];
}

@end
