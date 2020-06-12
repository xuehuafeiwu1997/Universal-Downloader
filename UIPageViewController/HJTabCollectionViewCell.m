//
//  HJTabCollectionViewCell.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/11.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "HJTabCollectionViewCell.h"
#import "UIColor+Utils.h"
#import "Masonry.h"

@interface HJTabCollectionViewCell()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *seperatorLine;

@end

@implementation HJTabCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@20);
    }];
    [self addSubview:self.seperatorLine];
    [self.seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@2);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    self.seperatorLine.hidden = selected ? NO : YES;
    self.titleLabel.textColor = selected ? [UIColor colorWithRGB:0xff5593] : [UIColor blackColor];
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"标题";
    return _titleLabel;
}

- (UIView *)seperatorLine {
    if (_seperatorLine) {
        return _seperatorLine;
    }
    _seperatorLine = [[UIView alloc] init];
    _seperatorLine.backgroundColor = [UIColor colorWithRGB:0xff5593];
    _seperatorLine.hidden = YES;
    return _seperatorLine;
}

@end
