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

- (NSArray<NSValue *> *)detectMotion:(NSArray<UIImage *> *)images {
    //이진화 사용될 임계값
    int thresh = 25;
    //thresh 값 이상인 차이 값 중 가장 큰 값
    int max_diff = 5;
    int width = images[0].size.width;
    int height = images[0].size.height;
    
    cv::Mat bImageMat, cImageMat;
    
    UIImageToMat(images[1].copy, bImageMat);
    UIImageToMat(images[2].copy, cImageMat);
    
    cv::Mat bGray, cGray;
    
    cv::cvtColor(bImageMat, bGray, cv::COLOR_BGR2GRAY);
    cv::cvtColor(cImageMat, cGray, cv::COLOR_BGR2GRAY);
    
    cv::Mat diff2;
    
    cv::absdiff(bGray, cGray, diff2);
    
    cv::Mat diff2_t, dst, diff;
    cv::Mat kernel = cv::Mat::ones(100, 100, CV_8U);

    // 팽창한 결과 (작은 차이를 크게)
    cv::dilate(diff2, dst, kernel);
    
    // 외부 윤곽선을 검출 -> 이외의 작은 영역은 무시, 찾은 두 개 이항의 윤곽선이 반환
    cv::threshold(dst, diff2_t, thresh, max_diff, cv::THRESH_BINARY);
    
    std::vector<cv::Mat> results;
    
    cv::findContours(diff2_t, results, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    
    NSMutableArray *cgRects = [NSMutableArray array];
    std::vector<cv::Rect> rectList;

    for (const auto& result: results) {
        auto area = cv::contourArea(result);
        if (area < 2000) {
            continue;
        }
        auto rect = cv::boundingRect(result);
        rectList.push_back(rect);
        
    }
    NSLog(@"%lu size",(unsigned long)rectList.size());
    
    //cv::groupRectangles(rectList, 1, 0.1);
    std::vector<int> indices;
    std::vector<float> scores;
    cv::dnn::NMSBoxes(rectList, scores, 0.2f, 1, indices);
    
    NSLog(@"%lu size",(unsigned long)rectList.size());
    
    for (int i = 0; i < indices.size(); i++) {
        cv::Rect rect = rectList[indices[i]];
        NSLog(@"%d %d %d %d",rect.x, rect.y, rect.width, rect.height);
        CGRect cgRect = CGRectMake(rect.x, rect.y, rect.width, rect.height);
        [cgRects addObject:[NSValue valueWithCGRect:cgRect]];
    }
    NSLog(@"%lu",(unsigned long)cgRects.count);

    return [NSArray arrayWithArray:cgRects];
    
    if (false) {
        
    }
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
        if (pt2.x > width) {pt2.x = width - 0.1;}
        if (pt2.y > height) {pt2.y = height - 0.1;}

        //return rect = CGRectMake(pt1.x, pt1.y,pt2.x - pt1.x, pt2.y - pt1.y);
    }

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
