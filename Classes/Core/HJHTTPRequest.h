//
//  HJNetworkRequest.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "HJHTTPRequestFormFile.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HJHTTPMethod) {
    HJHTTPMethodGET,
    HJHTTPMethodPOST,
    HJHTTPMethodPUT,
    HJHTTPMethodDELETE,
};

typedef NS_ENUM(NSInteger, HJHTTPContentType) {
    HJHTTPContentTypeFormData,
    HJHTTPContentTypeJSON
};

@interface HJHTTPRequest : NSObject

/// 请求路径
@property (nonatomic, strong) NSString *path;
/// 请求方式
@property (nonatomic, assign) HJHTTPMethod method;
/// 超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 参数传递方式
@property (nonatomic, assign) HJHTTPContentType contentType;
/// 参数
@property (nonatomic, strong) id params;
/// 上传的文件
@property (nonatomic, strong) NSArray<HJHTTPRequestFormFile *> *files;
/// 附加参数，用于支持扩展功能
@property (nonatomic, strong) NSMutableDictionary *userInfo;

+ (instancetype)request:(NSString *)path method:(HJHTTPMethod)method;

@end

NS_ASSUME_NONNULL_END
