//
//  YFHTTPManager.h
//  YFNetworking_Example
//
//  Created by 王云峰 on 2020/7/23.
//  Copyright © 2020 wandyf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFHTTPManager : NSObject

+ (instancetype)sharedManager;


/// 是否将参数放在Body中，默认为NO
@property (nonatomic, assign) BOOL bodyRequest;
/// 请求超时时间，默认为15s
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 是否允许在控制台打印日志,DEBUG模式下默认为YES
@property (nonatomic, assign) BOOL enableLog;


/// 取消当前所有请求
+ (void)cancelAllRequest;


/// 发送GET请求
/// @param url 请求地址
/// @param params 请求参数
/// @param progress 请求进度
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionDataTask *)GET:(NSString *)url
                       params:(NSDictionary *)params
                     progress:(void(^)(NSProgress *p))progress
                      success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                      faulure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/// 发送POST请求
/// @param url 请求地址
/// @param params 请求参数
/// @param progress 请求进度
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionDataTask *)POST:(NSString *)url
                        params:(NSDictionary *)params
                      progress:(void(^)(NSProgress *p))progress
                       success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                       faulure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/// 发送PUT请求
/// @param url 请求地址
/// @param params 请求参数
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionDataTask *)PUT:(NSString *)url
                       params:(NSDictionary *)params
                      success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                      faulure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/// 发送DELETE请求
/// @param url 请求地址
/// @param params 请求参数
/// @param progress 请求进度
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionDataTask *)DELETE:(NSString *)url
                          params:(NSDictionary *)params
                        progress:(void(^)(NSProgress *p))progress
                         success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                         faulure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/// 上传单张图片
/// @param url 请求地址
/// @param params 请求参数
/// @param image 图片
/// @param progress 请求进度
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionDataTask *)POSTFILE:(NSString *)url
                            params:(NSDictionary *)params
                             image:(UIImage *)image
                          progress:(void(^)(NSProgress *p))progress
                           success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                           faulure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
