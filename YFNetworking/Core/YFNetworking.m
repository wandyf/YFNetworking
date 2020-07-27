//
//  YFNetworking.m
//  YFNetworking_Example
//
//  Created by 王云峰 on 2020/7/27.
//  Copyright © 2020 wandyf. All rights reserved.
//

#import "YFNetworking.h"

#import "YFHTTPManager.h"

@implementation YFNetworking

#pragma mark - Public Method

+ (NSURLSessionDataTask *)GETURL:(NSString *)url param:(NSDictionary *)param success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    return [self GETURL:url param:param progress:NULL success:success failure:failure];
}

+ (NSURLSessionDataTask *)GETURL:(NSString *)url param:(NSDictionary *)param progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSMutableDictionary *parameters = [self baseParams];
    if (param.count) {
        [parameters setValuesForKeysWithDictionary:param];
    }
    if ([self needEncryptParam]) {
        parameters = [self encryptParam:parameters];
    }
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", [self hostUrl], url];
    NSURLSessionDataTask *dataTask = [[YFHTTPManager sharedManager] GET:fullURL params:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self handleResponseObject:responseObject withTask:task success:success failure:failure];
    } faulure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self handleError:error withTask:task failure:failure];
    }];
    return dataTask;
}

+ (NSURLSessionDataTask *)POSTURL:(NSString *)url param:(NSDictionary *)param success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    return [self POSTURL:url param:param progress:NULL success:success failure:failure];
}

+ (NSURLSessionDataTask *)POSTURL:(NSString *)url param:(NSDictionary *)param progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSMutableDictionary *parameters = [self baseParams];
    if (param.count) {
        [parameters setValuesForKeysWithDictionary:param];
    }
    if ([self needEncryptParam]) {
        parameters = [self encryptParam:parameters];
    }
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", [self hostUrl], url];
    NSURLSessionDataTask *dataTask = [[YFHTTPManager sharedManager] POST:fullURL params:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self handleResponseObject:responseObject withTask:task success:success failure:failure];
    } faulure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self handleError:error withTask:task failure:failure];
    }];
    return dataTask;
}

#pragma mark - Private Method

+ (void)handleResponseObject:(id)responseObject withTask:(NSURLSessionDataTask *)task success:(void(^)(id))success failure:(void(^)(NSError *error))failure {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSDictionary *responseDict = (NSDictionary *)responseObject;
    if (!httpResponse || !responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
        NSError *myError = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:1 userInfo:@{NSLocalizedDescriptionKey:@"数据错误"}];
        if (failure) {
            failure(myError);
        }
        return;
    }
    if (httpResponse.statusCode == 200) {
        if (success) {
            success(responseDict);
        }
        return;
    } else {
        NSError *myError = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:httpResponse.statusCode userInfo:@{NSLocalizedDescriptionKey:@"网络请求错误"}];
        if (failure) {
            failure(myError);
        }
        return;
    }
}

+ (void)handleError:(NSError *)error withTask:(NSURLSessionDataTask *)task failure:(void(^)(NSError *error))failure {
    NSError *myError = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:error.code userInfo:error.userInfo];
    if (failure) {
        failure(myError);
    }
}

#pragma mark - Other

+ (NSString *)hostUrl {
    return @"";
}

+ (NSMutableDictionary *)baseParams {
    return [NSMutableDictionary dictionary];
}

+ (BOOL)needEncryptParam {
    return NO;
}

+ (NSMutableDictionary *)encryptParam:(NSMutableDictionary *)param {
    return [NSMutableDictionary dictionaryWithDictionary:param];
}

@end
