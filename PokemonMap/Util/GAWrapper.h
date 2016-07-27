//
//  GAWrapper.h
//  PokemonMap
//
//  Created by LinYiting on 2016/7/27.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleAnalytics/GAI.h>

@interface GAWrapper : NSObject

+ (void)sendReport:(NSString *)action
       andProperty:(NSString *)property;

@end
