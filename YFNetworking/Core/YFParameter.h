//
//  YFParameter.h
//  YFNetworking_Example
//
//  Created by 王云峰 on 2020/8/24.
//  Copyright © 2020 wandyf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFParameter : NSObject

@property (nonatomic, copy) NSString *base;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *fullPath;

@property (nonatomic, assign) NSTimeInterval timeout;

- (BOOL)hasParametrs;

- (NSMutableDictionary *)parameters;

- (void)setValue:(NSObject *)value forName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
