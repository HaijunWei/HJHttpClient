//
//  HJHTTPRequest+Decoder.m
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHTTPRequest+Decoder.h"

static NSString * const kResponseDataCls = @"responseDataCls";
static NSString * const kDeserializationPath = @"deserializationPath";

@implementation HJHTTPRequest (Decoder)

+ (instancetype)GET:(NSString *)path responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHTTPMethodGET deserializationPath:nil responseDataCls:responseDataCls];
}

+ (instancetype)GET:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHTTPMethodGET deserializationPath:deserializationPath responseDataCls:responseDataCls];
}

+ (instancetype)POST:(NSString *)path responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHTTPMethodPOST deserializationPath:nil responseDataCls:responseDataCls];
}

+ (instancetype)POST:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHTTPMethodPOST deserializationPath:deserializationPath responseDataCls:responseDataCls];
}

+ (instancetype)PUT:(NSString *)path responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHTTPMethodPUT deserializationPath:nil responseDataCls:responseDataCls];
}

+ (instancetype)PUT:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHTTPMethodPUT deserializationPath:deserializationPath responseDataCls:responseDataCls];
}

+ (instancetype)DELETE:(NSString *)path responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHTTPMethodDELETE deserializationPath:nil responseDataCls:responseDataCls];
}

+ (instancetype)DELETE:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    return [self request:path method:HJHTTPMethodDELETE deserializationPath:deserializationPath responseDataCls:responseDataCls];
}

+ (instancetype)request:(NSString *)path method:(HJHTTPMethod)method deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls {
    HJHTTPRequest *req = [self request:path method:method];
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

@end
