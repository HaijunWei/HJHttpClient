//
//  HJHTTPResponseDecoder+Protocol.h
//
//  Created by Haijun on 2019/5/10.
//

@protocol HJHTTPResponseDecoder <NSObject>
/*
 解析响应值，
 只支持返回 HJHTTPResponse 或者 NSError
 */
- (id)request:(HJHTTPRequest *)req didGetURLResponse:(NSHTTPURLResponse *)response responseData:(id)responseData error:(NSError *)error;

@end
