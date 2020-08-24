//
//  YFParameter.m
//  YFNetworking_Example
//
//  Created by 王云峰 on 2020/8/24.
//  Copyright © 2020 wandyf. All rights reserved.
//

#import "YFParameter.h"

@interface YFParameter ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation YFParameter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timeout = 15.0;
    }
    return self;
}

- (NSString *)fullPath {
    if (!_fullPath) {
        _fullPath = [self.base stringByAppendingString:self.path];
    }
    return _fullPath;
}

- (BOOL)hasParametrs {
    return [self.parameters allKeys].count > 0;
}

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}

- (void)setValue:(NSObject *)value forName:(NSString *)name {
    [[self parameters] setValue:value forKey:name];
}

@end
