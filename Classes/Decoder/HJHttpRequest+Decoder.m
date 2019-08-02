//
//  HJHttpRequest+Decoder.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHttpRequest+Decoder.h"

static NSString * const kResponseDataCls = @"responseDataCls";
static NSString * const kDeserializationPath = @"deserializationPath";
static NSString * const kReformBlock = @"reformBlock";

@implementation HJHttpRequest (Decoder)

+ (instancetype)GET:(NSString *)path responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHttpMethodGET deserializationPath:nil responseDataCls:responseDataCls];
}

+ (instancetype)GET:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHttpMethodGET deserializationPath:deserializationPath responseDataCls:responseDataCls];
}

+ (instancetype)POST:(NSString *)path responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHttpMethodPOST deserializationPath:nil responseDataCls:responseDataCls];
}

+ (instancetype)POST:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHttpMethodPOST deserializationPath:deserializationPath responseDataCls:responseDataCls];
}

+ (instancetype)PUT:(NSString *)path responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHttpMethodPUT deserializationPath:nil responseDataCls:responseDataCls];
}

+ (instancetype)PUT:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHttpMethodPUT deserializationPath:deserializationPath responseDataCls:responseDataCls];
}

+ (instancetype)DELETE:(NSString *)path responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHttpMethodDELETE deserializationPath:nil responseDataCls:responseDataCls];
}

+ (instancetype)DELETE:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHttpMethodDELETE deserializationPath:deserializationPath responseDataCls:responseDataCls];
}

+ (instancetype)request:(NSString *)path method:(HJHttpMethod)method deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    HJHttpRequest *req = [self request:path method:method];
    req.responseDataCls = responseDataCls;
    req.deserializationPath = deserializationPath;
    return req;
}

#pragma mark - Setter & Getter

- (void)setResponseDataCls:(Class)responseDataCls {
    self.userInfo[kResponseDataCls] = responseDataCls;
}

- (Class)responseDataCls {
    return self.userInfo[kResponseDataCls];
}

- (void)setDeserializationPath:(NSString *)deserializationPath {
    self.userInfo[kDeserializationPath] = deserializationPath;
}

- (NSString *)deserializationPath {
    return self.userInfo[kDeserializationPath];
}

- (void)setReformBlock:(id  _Nonnull (^)(id _Nonnull))reformBlock {
    self.userInfo[kReformBlock] = reformBlock;
}

- (id  _Nonnull (^)(id _Nonnull))reformBlock {
    return self.userInfo[kReformBlock];
}

@end
