//
//  YFConstant.h
//  YFNetworking_Example
//
//  Created by 王云峰 on 2020/8/24.
//  Copyright © 2020 wandyf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Callback

typedef void (^YFProgress)(NSProgress *p);
typedef void (^YFSuccess)(id responseObject);
typedef void (^YFFailure)(NSError *error);

extern NSString * const YFErrorCodeKey;
extern NSString * const YFErrorMessageKey;

@interface YFConstant : NSObject

@end

NS_ASSUME_NONNULL_END
