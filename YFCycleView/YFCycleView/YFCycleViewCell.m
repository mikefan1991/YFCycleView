//
//  YFCycleViewCell.m
//  YFCycleView
//
//  Created by Yingwei Fan on 7/19/17.
//  Copyright © 2017 YF. All rights reserved.
//

#import "YFCycleViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YFCycleViewCell ()


@end

@implementation YFCycleViewCell

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"bundle"];
    UIImage *placeholderImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"placeholder.jpg"]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:placeholderImage];
}

+ (NSString *)cellIdentifier {
    return @"CycleViewCell";
}

@end
