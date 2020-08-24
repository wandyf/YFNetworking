//
//  YFHTTPManager.h
//  YFNetworking_Example
//
//  Created by 王云峰 on 2020/7/23.
//  Copyright © 2020 wandyf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YFConstant.h"
#import "YFParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFHTTPManager : NSObject

+ (instancetype)sharedManager;

/// 是否允许在控制台打印日志,DEBUG模式下默认为YES
@property (nonatomic, assign) BOOL enableLog;

/// 取消当前所有请求
+ (void)cancelAllRequest;


/// 发送GET请求
/// @param param 参数
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
- (NSURLSessionDataTask *)GET:(YFParameter *)param
                     progress:(YFProgress)progress
                      success:(YFSuccess)success
                      failure:(YFFailure)failure;

/// 发送POST请求
/// @param param 参数
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
- (NSURLSessionDataTask *)POST:(YFParameter *)param
                      progress:(YFProgress)progress
                       success:(YFSuccess)success
                       failure:(YFFailure)failure;

/// 发送PUT请求
/// @param param 参数
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
- (NSURLSessionDataTask *)PUT:(YFParameter *)param
                     progress:(YFProgress)progress
                      success:(YFSuccess)success
                      failure:(YFFailure)failure;

/// 发送DELETE请求
/// @param param 参数
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
- (NSURLSessionDataTask *)DELETE:(YFParameter *)param
                        progress:(YFProgress)progress
                         success:(YFSuccess)success
                         failure:(YFFailure)failure;

/// 上传单张图片
/// @param param 参数
/// @param image 图片
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
- (NSURLSessionDataTask *)POSTFILE:(YFParameter *)param
                             image:(UIImage *)image
                          progress:(YFProgress)progress
                           success:(YFSuccess)success
                           failure:(YFFailure)failure;

@end

NS_ASSUME_NONNULL_END
