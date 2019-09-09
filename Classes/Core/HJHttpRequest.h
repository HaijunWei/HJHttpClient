//
//  HJNetworkRequest.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "HJHttpRequestFormFile.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HJHttpMethod) {
    HJHttpMethodGET,
    HJHttpMethodPOST,
    HJHttpMethodPUT,
    HJHttpMethodDELETE,
};

typedef NS_ENUM(NSInteger, HJHttpContentType) {
    HJHttpContentTypeFormData,
    HJHttpContentTypeJSON
};

@interface HJHttpRequest : NSObject

/// 请求路径
@property (nonatomic, strong) NSString *path;
/// 请求方式
@property (nonatomic, assign) HJHttpMethod method;
/// 超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 参数传递方式
@property (nonatomic, assign) HJHttpContentType contentType;
/// 参数
@property (nonatomic, strong) id params;
/// 上传的文件
@property (nonatomic, strong) NSArray<HJHttpRequestFormFile *> *files;
/// 附加请求头
@property (nonatomic, strong) NSDictionary *headerFields;
/// 附加参数，用于支持扩展功能
@property (nonatomic, strong) NSMutableDictionary *userInfo;

+ (instancetype)request:(NSString *)path method:(HJHttpMethod)method;

@end

NS_ASSUME_NONNULL_END
