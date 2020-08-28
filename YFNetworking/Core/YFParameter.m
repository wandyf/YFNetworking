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

@property (nonatomic, strong) NSMutableDictionary *headers;

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

#pragma mark - parameter

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

#pragma mark - header

- (BOOL)hasHeaders {
    return [self.headers allKeys].count > 0;
}

- (NSMutableDictionary *)headers {
    if (!_headers) {
        _headers = [NSMutableDictionary dictionary];
    }
    return _headers;
}

- (void)setValue:(NSObject *)value forHeader:(NSString *)header {
    [[self headers] setValue:value forKey:header];
}

@end
