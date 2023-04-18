//
//  OpenCVWrapper.h
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/18.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

- (CGRect)detectMotion:(NSArray<UIImage *> *)images;

@end

NS_ASSUME_NONNULL_END
