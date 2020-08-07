//
//  DownloadViewController.m
//  万能下载器
//
//  Created by 许明洋 on 2020/7/17.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "DownloadViewController.h"
#import "Masonry.h"
#import "DownloadManager.h"
#import "FCFileManager.h"

@interface DownloadViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *instructLabel;
//@property (nonatomic, strong) UITextField *urlTextField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) NSURL *url;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"万能下载器";
    
    [self.view addSubview:self.instructLabel];
    [self.instructLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(60);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@30);
    }];

//    [self.view addSubview:self.urlTextField];
//    [self.urlTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.instructLabel.mas_right).offset(20);
//        make.centerY.equalTo(self.instructLabel);
//        make.width.greaterThanOrEqualTo(@0);
//        make.height.equalTo(@30);
//    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.instructLabel);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.instructLabel.mas_bottom).offset(20);
        make.height.equalTo(@100);
    }];
    
    [self.view addSubview:self.startButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    [self.view addSubview:self.pauseButton];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.startButton);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    [self.view addSubview:self.finishButton];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.pauseButton);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    [self.view addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startButton);
        make.width.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(self.startButton.mas_top).offset(-20);
        make.height.equalTo(@20);
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger length = textView.text.length;
    if (length == 0) {
        self.startButton.enabled = NO;
        [self.startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.clearButton.enabled = NO;
        
    } else {
        self.url = [NSURL URLWithString:textView.text];
        self.startButton.enabled = YES;
        [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.clearButton.enabled = YES;
        [self.clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

//#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self.urlTextField resignFirstResponder];
//    return YES;
//}

#pragma mark - 下载、暂停和结束

- (void)startDownlaod {
    NSLog(@"开始下载");
    if (!self.url) {
        return;
    }
    [[DownloadManager sharedInstance] downloadVideoByURl:self.url];
}

- (void)pauseDownload {
    NSLog(@"暂停下载");
}

- (void)finishDownload {
    AppLog(@"终止下载");
    NSLog(@"开始合并ts文件");
    NSString *path = [[DownloadManager saveFilePath] stringByAppendingPathComponent:@"m3u8"];
    NSString *fileName = @"许明洋.ts";
    NSString *filePath = [[DownloadManager saveFilePath] stringByAppendingPathComponent:fileName];
    if ([FCFileManager existsItemAtPath:filePath]) {
        NSLog(@"已经合并过该文件");
        [self showAlertIfComibineFileIsExist:fileName];
        return;
    }
    [[DownloadManager sharedInstance] combineTsToVideo];
}

- (void)clearUrl {
    AppLog(@"清除文本框中的url");
//    self.urlTextField.text = @"";
    self.textView.text = @"";
    [self.clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.clearButton.enabled = NO;
}

//- (void)textFieldDidChange:(UITextField *)textField {
//    NSString *text = textField.text;
//    if (text.length == 0) {
//        self.startButton.enabled = NO;
//        [self.startButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        self.clearButton.enabled = NO;
//        
//    } else {
//        self.url = [NSURL URLWithString:text];
//        self.startButton.enabled = YES;
//        [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        self.clearButton.enabled = YES;
//        [self.clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
//}

#pragma mark - lazy load
- (UILabel *)instructLabel {
    if (_instructLabel) {
        return _instructLabel;
    }
    _instructLabel = [[UILabel alloc] init];
    _instructLabel.font = [UIFont systemFontOfSize:18];
    _instructLabel.textColor = [UIColor blackColor];
    _instructLabel.text = @"请输入URL";
    _instructLabel.textAlignment = NSTextAlignmentCenter;
    return _instructLabel;
}

//- (UITextField *)urlTextField {
//    if (_urlTextField) {
//        return _urlTextField;
//    }
//    _urlTextField = [[UITextField alloc] init];
//    _urlTextField.font = [UIFont systemFontOfSize:14];
//    _urlTextField.textColor = [UIColor blackColor];
//    _urlTextField.placeholder = @"请输入你要下载的URL";
//    _urlTextField.delegate = self;
//    [_urlTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    return _urlTextField;
//}

- (UITextView *)textView {
    if (_textView) {
        return _textView;
    }
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.textColor = [UIColor blackColor];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.layer.borderColor = [UIColor colorWithRGB:0xcccccc].CGColor;
    _textView.layer.borderWidth = 0.5;
    return _textView;
}

- (UIButton *)startButton {
    if (_startButton) {
        return _startButton;
    }
    _startButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _startButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startButton setTitle:@"开始下载" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startDownlaod) forControlEvents:UIControlEventTouchUpInside];
    _startButton.backgroundColor = [UIColor whiteColor];
    _startButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _startButton.layer.borderWidth = 1.0f;
    _startButton.layer.cornerRadius = 10;
    _startButton.clipsToBounds = YES;
    _startButton.enabled = NO;//初始不可点击
    return _startButton;
}

- (UIButton *)pauseButton {
    if (_pauseButton) {
        return _pauseButton;
    }
    _pauseButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _pauseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pauseButton setTitle:@"暂停下载" forState:UIControlStateNormal];
    [_pauseButton addTarget:self action:@selector(pauseDownload) forControlEvents:UIControlEventTouchUpInside];
    _pauseButton.layer.cornerRadius = 10;
    _pauseButton.clipsToBounds = YES;
    _pauseButton.backgroundColor = [UIColor whiteColor];
    _pauseButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pauseButton.layer.borderWidth = 1.0f;
    return _pauseButton;
}

- (UIButton *)finishButton {
    if (_finishButton) {
        return _finishButton;
    }
    _finishButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _finishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_finishButton setTitle:@"终止下载" forState:UIControlStateNormal];
    [_finishButton addTarget:self action:@selector(finishDownload) forControlEvents:UIControlEventTouchUpInside];
    _finishButton.layer.cornerRadius = 10;
    _pauseButton.clipsToBounds = YES;
    return _finishButton;
}

- (UIButton *)clearButton {
    if (_clearButton) {
        return _clearButton;
    }
    _clearButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_clearButton setTitle:@"清空文本框url" forState:UIControlStateNormal];
    [_clearButton addTarget:self action:@selector(clearUrl) forControlEvents:UIControlEventTouchUpInside];
    _clearButton.layer.cornerRadius = 10;
    _clearButton.clipsToBounds = YES;
    _clearButton.enabled = NO;//初始url为空，不允许点击
    return _clearButton;
}

- (void)showAlertIfComibineFileIsExist:(NSString *)fileName {
    NSString *message = [NSString stringWithFormat:@"%@文件已经存在，是否替换原有的文件?",fileName];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"合并文件" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"合并文件并替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DownloadManager sharedInstance] combineTsToVideo];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        AppLog(@"文件已存在，取消合并文件");
        return;
    }];
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
