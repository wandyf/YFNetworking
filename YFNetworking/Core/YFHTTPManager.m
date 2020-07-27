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

@property (nonatomic, strong) AFURLSessionManager *urlManager;

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
        
        self.bodyRequest = NO;
        self.timeoutInterval = 15.0;
        self.enableLog = NO;
#if DEBUG
        self.enableLog = YES;
#endif
        
        self.httpManager = [AFHTTPSessionManager manager];
        self.urlManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = self.timeoutInterval;
        self.httpManager.requestSerializer = requestSerializer;
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                     @"application/json",
                                                     @"text/json",
                                                     @"text/javascript",
                                                     @"text/plain",
                                                     @"text/html", nil];
        self.httpManager.responseSerializer = responseSerializer;
        self.urlManager.responseSerializer = responseSerializer;
    }
    return self;
}

#pragma mark - Public Method

+ (void)cancelAllRequest {
    YFHTTPManager *manager = [self sharedManager];
    [manager.httpManager.operationQueue cancelAllOperations];
}

- (NSURLSessionDataTask *)GET:(NSString *)url params:(NSDictionary *)params progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success faulure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    if (self.bodyRequest) {
        return [self method:@"GET" url:url params:params success:success failure:failure];
    }
    NSURLSessionDataTask *dataTask = [self.httpManager GET:url parameters:params headers:nil progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self reponseWithTask:task responseObject:responseObject url:url success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorWithTask:task error:error url:url failure:failure];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)url params:(NSDictionary *)params progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success faulure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    if (self.bodyRequest) {
        return [self method:@"POST" url:url params:params success:success failure:failure];
    }
    NSURLSessionDataTask *dataTask = [self.httpManager POST:url parameters:params headers:nil progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self reponseWithTask:task responseObject:responseObject url:url success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorWithTask:task error:error url:url failure:failure];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)PUT:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success faulure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    NSURLSessionDataTask *dataTask = [self.httpManager PUT:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self reponseWithTask:task responseObject:responseObject url:url success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorWithTask:task error:error url:url failure:failure];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)url params:(NSDictionary *)params progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success faulure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    NSURLSessionDataTask *dataTask = [self.httpManager DELETE:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self reponseWithTask:task responseObject:responseObject url:url success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorWithTask:task error:error url:url failure:failure];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)POSTFILE:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image progress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success faulure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    NSURLSessionDataTask *dataTask = [self.httpManager POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *ext = @"png";
        NSData *imageData = UIImagePNGRepresentation(image);
        if (imageData == nil) {
            ext = @"jpeg";
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        NSDateFormatter *formatter = [NSDateFormatter.alloc init];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", [formatter stringFromDate:[NSDate date]], ext];
        [formData appendPartWithFileData:imageData name:@"uploadImage" fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@", ext]];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self reponseWithTask:task responseObject:responseObject url:url success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorWithTask:task error:error url:url failure:failure];
    }];
    return dataTask;
}

#pragma mark - Private Method

- (NSURLSessionDataTask *)method:(NSString *)method
                             url:(NSString *)url
                          params:(NSDictionary *)params
                         success:(void(^)(NSURLSessionDataTask *task, id rsponseObject))success
                         failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:url parameters:nil error:nil];
    request.timeoutInterval = self.timeoutInterval;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *dataTask = [self.urlManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self errorWithTask:nil error:error url:url failure:failure];
        } else {
            [self reponseWithTask:nil responseObject:responseObject url:url success:success];
        }
    }];
    [dataTask resume];
    return dataTask;
}

- (void)reponseWithTask:(NSURLSessionDataTask *)task
         responseObject:(id)responseObject
                    url:(NSString *)url
                success:(void(^)(NSURLSessionDataTask *task, id rsponseObject))success {
    if (self.enableLog) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n[REQUEST URL] >>>>> [%@]\n[RESPONSE OBJECT] >>>>> %@\n\n", url, string);
    }
    if (success) {
        success(task, responseObject);
    }
}

- (void)errorWithTask:(NSURLSessionDataTask *)task
                error:(NSError *)error
                  url:(NSString *)url
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (self.enableLog) {
        NSLog(@"\n\n[REQUEST URL] >>>>> [%@]\n[ERROR] >>>>> %@\n\n", url, error);
    }
    if (failure) {
        failure(task, error);
    }
}

@end
