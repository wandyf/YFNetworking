//
//  YFNetworking.h
//  YFNetworking_Example
//
//  Created by 王云峰 on 2020/7/27.
//  Copyright © 2020 wandyf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFNetworking : NSObject


/// GET请求
/// @param url 请求地址
/// @param param 请求参数
/// @param success 成功回调
/// @param failure 失败回调
+ (NSURLSessionDataTask *)GETURL:(NSString *)url
                           param:(NSDictionary *)param
                         success:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;

/// GET请求(有进度)
/// @param url 请求地址
/// @param param 请求参数
/// @param progress 请求进度
/// @param success 成功回调
/// @param failure 失败回调
+ (NSURLSessionDataTask *)GETURL:(NSString *)url
                           param:(NSDictionary *)param
                        progress:( void(^ _Nullable)(NSProgress *p))progress
                         success:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;

/// POST请求
/// @param url 请求地址
/// @param param 请求参数
/// @param success 成功回调
/// @param failure 失败回调
+ (NSURLSessionDataTask *)POSTURL:(NSString *)url
                            param:(NSDictionary *)param
                          success:(void(^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

/// POST请求(带进度)
/// @param url 请求地址
/// @param param 请求参数
/// @param progress 请求进度
/// @param success 成功回调
/// @param failure 失败回调
+ (NSURLSessionDataTask *)POSTURL:(NSString *)url
                            param:(NSDictionary *)param
                         progress:(void(^ _Nullable)(NSProgress *p))progress
                          success:(void(^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

#pragma mark - Required Method

/// 服务器地址
+ (NSString *)hostUrl;

/// 基础参数
+ (NSMutableDictionary *)baseParams;

/// 参数加密
+ (BOOL)needEncryptParam;
+ (NSMutableDictionary *)encryptParam:(NSMutableDictionary *)param;

@end

NS_ASSUME_NONNULL_END
