//
//  LoclationManagerReactify.h
//  PokemonMap
//
//  Created by LinYiting on 2016/7/25.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface LocationManagerReactify : NSObject

+ (RACSignal *)currentLocationSignal;

@end
