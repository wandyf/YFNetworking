//
//  YFHTTPManager.m
//  YFNetworking_Example
//
//  Created by 王云峰 on 2020/7/23.
//  Copyright © 2020 wandyf. All rights reserved.
//

#import "YFHTTPManager.h"

#import "AFNetworking.h"

@interface YFHTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation YFHTTPManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static YFHTTPManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
#if DEBUG
        self.enableLog = YES;
#endif
        
        self.httpManager = [AFHTTPSessionManager manager];
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = 15.0;
        self.httpManager.requestSerializer = requestSerializer;
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                     @"application/json",
                                                     @"text/json",
                                                     @"text/javascript",
                                                     @"text/plain",
                                                     @"text/html", nil];
        self.httpManager.responseSerializer = responseSerializer;
    }
    return self;
}

#pragma mark - Public Method

+ (void)cancelAllRequest {
    YFHTTPManager *manager = [self sharedManager];
    [manager.httpManager.operationQueue cancelAllOperations];
}

- (NSURLSessionDataTask *)GET:(YFParameter *)param progress:(YFProgress)progress success:(YFSuccess)success failure:(YFFailure)failure {
    NSURLSessionDataTask *dataTask = [self.httpManager GET:param.fullPath parameters:param.parameters headers:param.headers progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self logSuccess:param response:responseObject];
        [self handleResponseObject:responseObject withTask:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self logError:param error:error];
        [self handleError:error withTask:task failure:failure];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(YFParameter *)param progress:(YFProgress)progress success:(YFSuccess)success failure:(YFFailure)failure {
    NSURLSessionDataTask *dataTask = [self.httpManager POST:param.fullPath parameters:param.parameters headers:param.headers progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self logSuccess:param response:responseObject];
        [self handleResponseObject:responseObject withTask:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self logError:param error:error];
        [self handleError:error withTask:task failure:failure];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)PUT:(YFParameter *)param progress:(YFProgress)progress success:(YFSuccess)success failure:(YFFailure)failure {
    NSURLSessionDataTask *dataTask = [self.httpManager PUT:param.fullPath parameters:param.parameters headers:param.headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponseObject:responseObject withTask:task success:success failure:failure];
        [self logSuccess:param response:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error withTask:task failure:failure];
        [self logError:param error:error];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)DELETE:(YFParameter *)param progress:(YFProgress)progress success:(YFSuccess)success failure:(YFFailure)failure {
    NSURLSessionDataTask *dataTask = [self.httpManager DELETE:param.fullPath parameters:param.parameters headers:param.headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self logSuccess:param response:responseObject];
        [self handleResponseObject:responseObject withTask:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self logError:param error:error];
        [self handleError:error withTask:task failure:failure];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)POSTFILE:(YFParameter *)param image:(UIImage *)image progress:(YFProgress)progress success:(YFSuccess)success failure:(YFFailure)failure {
    NSURLSessionDataTask *dataTask = [self.httpManager POST:param.fullPath parameters:param.parameters headers:param.headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *ext = @"png";
        NSData *imageData = UIImagePNGRepresentation(image);
        if (imageData == nil) {
            ext = @"jpeg";
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        NSDateFormatter *formatter = [NSDateFormatter.alloc init];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", [formatter stringFromDate:[NSDate date]], ext];
        [formData appendPartWithFileData:imageData name:param.name fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@", ext]];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self logSuccess:param response:responseObject];
        [self handleResponseObject:responseObject withTask:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self logError:param error:error];
        [self handleError:error withTask:task failure:failure];
    }];
    return dataTask;
}

#pragma mark - Private Method

- (void)handleResponseObject:(id)responseObject withTask:(NSURLSessionDataTask *)task success:(YFSuccess)success failure:(YFFailure)failure {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSDictionary *responseDict;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        responseDict = (NSDictionary *)responseObject;
    } else {
        responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    }
    if (!httpResponse || !responseDict || ![responseDict isKindOfClass:[NSDictionary class]]) {
        NSError *myError = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:-1 userInfo:@{YFErrorCodeKey:@"-1", YFErrorMessageKey:@"数据结构错误"}];
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
        NSError *myError = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:httpResponse.statusCode userInfo:@{YFErrorCodeKey:@"-1", YFErrorMessageKey:@"网络请求错误"}];
        if (failure) {
            failure(myError);
        }
        return;
    }
}

- (void)handleError:(NSError *)error withTask:(NSURLSessionDataTask *)task failure:(YFFailure)failure {
    NSError *myError = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:error.code userInfo:@{YFErrorCodeKey:@"-1", YFErrorMessageKey:@"网络请求错误"}];
    if (failure) {
        failure(myError);
    }
}

- (void)logSuccess:(YFParameter *)param response:(id)responseObject {
    if (!self.enableLog) { return; }
    NSDictionary *responseDict;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        responseDict = (NSDictionary *)responseObject;
    } else {
        responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    }
    NSLog(@"\n>>>>>%@\n>>>>>%@\n>>>>>%@\n>>>>>%@\n>>>>>%@\n", param.base, param.path, param.parameters, param.headers, responseDict);
}

- (void)logError:(YFParameter *)param error:(NSError *)error {
    if (!self.enableLog) { return; }
    NSLog(@"\n>>>>>%@\n>>>>>%@\n>>>>>%@\n>>>>>%@\n>>>>>%@\n", param.base, param.path, param.parameters, param.headers, error);
}

@end
