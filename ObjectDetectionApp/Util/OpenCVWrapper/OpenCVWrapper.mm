//
//  OpenCVWrapper.m
//  ObjectDetectionApp
//
//  Created by 이재훈 on 2023/04/18.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation OpenCVWrapper

//Here we can use C++ code

- (CGRect)detectMotion:(NSArray<UIImage *> *)images {
    int thresh = 25;
    int max_diff = 5;
    
    cv::Mat aImageMat, bImageMat, cImageMat;
    
    UIImageToMat(images[0].copy, aImageMat);
    UIImageToMat(images[1].copy, bImageMat);
    UIImageToMat(images[2].copy, cImageMat);
    
    cv::Mat aGray, bGray, cGray;
    
    cv::cvtColor(aImageMat, aGray, cv::COLOR_BGR2GRAY);
    cv::cvtColor(bImageMat, bGray, cv::COLOR_BGR2GRAY);
    cv::cvtColor(cImageMat, cGray, cv::COLOR_BGR2GRAY);
    
    cv::Mat diff1, diff2;
    
    cv::absdiff(aGray, bGray, diff1);
    cv::absdiff(bGray, cGray, diff2);
    
    cv::Mat diff1_t, diff2_t, diff;
    
    cv::threshold(diff1, diff1_t, thresh, max_diff, cv::THRESH_BINARY);
    cv::threshold(diff2, diff2_t, thresh, max_diff, cv::THRESH_BINARY);
    
    cv::bitwise_and(diff1_t, diff2_t, diff);
    
    cv::Mat difff;
    [self morphologyExWithInput:diff output:difff];
    
    int diff_cnt = [self countNonZeroWithMat:difff];
    
    CGRect rect;
    
    if (diff_cnt > max_diff) {
        NSArray<NSValue *> *nzero = [self nonZeroIndicesFromArray: difff];
        CGPoint pt1 = CGPointMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT));
        CGPoint pt2 = CGPointMake(CGFloat(0), CGFloat(0));
        for (NSValue *value in nzero) {
            CGPoint point = [value CGPointValue];
            pt1.x = MIN(pt1.x, point.x);
            pt1.y = MIN(pt1.y, point.y);
            pt2.x = MAX(pt2.x, point.x);
            pt2.y = MAX(pt2.y, point.y);
        }
        pt1.x -= 50.0;
        pt1.y -= 50.0;
        pt2.x += 50.0;
        pt2.y += 50.0;
        
        if (pt1.x < 0.0) {pt1.x = 0.0;}
        if (pt1.y < 0.0) {pt1.y = 0.0;}
        if (pt1.x > 719.0) {pt1.x = 719.0;}
        if (pt1.y > 719.0) {pt1.y = 719.0;}
        
        return rect = CGRectMake(pt1.x, pt1.y, pt2.x - pt1.x, pt2.y - pt1.y);
    }
    
    return CGRectMake(0.0, 0.0, 0.0, 0.0);
    
}

- (void)morphologyExWithInput:(cv::Mat)input output:(cv::Mat &)output {
    cv::Mat element = cv::getStructuringElement(cv::MORPH_CROSS, cv::Size(3, 3));
    cv::morphologyEx(input, output, cv::MORPH_OPEN, element);
}

- (int)countNonZeroWithMat:(cv::Mat)mat {
    int count = 0;
    for (int i = 0; i < mat.rows; i++) {
        for (int j = 0; j < mat.cols; j++) {
            uchar value = mat.at<uchar>(i, j);
            if (value != 0) {
                count++;
            }
        }
    }
    return count;
}


- (NSArray<NSValue *> *)nonZeroIndicesFromArray:(cv::Mat)diff {
    NSMutableArray<NSValue *> *nonZeroIndices = [NSMutableArray array];
    for (int i = 0; i < diff.rows; i++) {
        for (int j = 0; j < diff.cols; j++) {
            uchar value = diff.at<uchar>(i, j);
            if (value != 0) {
                NSValue *indexValue = [NSValue valueWithCGPoint:CGPointMake(j, i)];
                [nonZeroIndices addObject:indexValue];
            }
        }
    }
    return [nonZeroIndices copy];
}

@end
