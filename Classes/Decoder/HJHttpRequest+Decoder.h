//
//  HJHttpRequest+Decoder.h
//
//  Created by Haijun on 2019/5/9.
//

#import "HJHttpRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHttpRequest (Decoder)

/// 响应数据类型
@property (nonatomic, assign) Class responseDataCls;
/// 从指定路径开始反序列化（xxx.xxx）
@property (nonatomic, strong) NSString *deserializationPath;

+ (instancetype)GET:(NSString *)path responseDataCls:(Class _Nullable)responseDataCls;
+ (instancetype)GET:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls;

+ (instancetype)POST:(NSString *)path responseDataCls:(Class _Nullable)responseDataCls;
+ (instancetype)POST:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls;

+ (instancetype)PUT:(NSString *)path responseDataCls:(Class _Nullable)responseDataCls;
+ (instancetype)PUT:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls;

+ (instancetype)DELETE:(NSString *)path responseDataCls:(Class _Nullable)responseDataCls;
+ (instancetype)DELETE:(NSString *)path deserializationPath:(NSString *)deserializationPath responseDataCls:(Class)responseDataCls;

@end

NS_ASSUME_NONNULL_END
