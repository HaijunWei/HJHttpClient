//
//  HJHttpRequestFormFile.h
//
//  Created by Haijun on 2019/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJHttpRequestFormFile : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mineType;

+ (instancetype)fileWithData:(NSData *)data
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType;


@end

NS_ASSUME_NONNULL_END
