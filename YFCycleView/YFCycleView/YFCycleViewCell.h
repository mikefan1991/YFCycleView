//
//  YFCycleViewCell.h
//  YFCycleView
//
//  Created by Yingwei Fan on 7/19/17.
//  Copyright © 2017 YF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFCycleViewCell : UICollectionViewCell

/** imageView */
@property (nonatomic, strong) UIImageView *imageView;

/** 图像的下载地址 */
@property (nonatomic, strong) NSString *imageURL;

/** 图像 */
@property (nonatomic, strong) UIImage *image;

/** Cell的Identifier */
+ (NSString *)cellIdentifier;

@end
