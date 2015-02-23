//
//  ViewController.m
//  HPLTagCloudGeneratorSamples
//
//  Created by Erik Midander on 13/02/15.
//  Copyright (c) 2015 Erik Midander. All rights reserved.
//

#import "ViewController.h"
#import "HPLTagCloudGenerator.h"

#define OLD_STYLE 0

@interface ViewController ()
@property (nonatomic) UIButton *refreshButton;
@property (nonatomic) UIView *tagView;
@property (nonatomic) NSDictionary *tagLabelViews;
@end

@implementation ViewController

- (void)viewDidLoad {
  
  _tagView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width) / 2.0, self.view.bounds.size.width, self.view.bounds.size.width)];
  _tagView.backgroundColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.9 alpha:1.0];
  [self.view addSubview:_tagView];

  _refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_refreshButton setTitle:@"New tags!" forState:UIControlStateNormal];
  _refreshButton.frame = CGRectMake((self.view.bounds.size.width - 100) / 2, 40, 100, 40);
  [_refreshButton addTarget:self action:@selector(didClickRefresh:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_refreshButton];
 
}

- (void)didClickRefresh:(id)sender {
  [self generateTags];
}

- (void)viewWillAppear:(BOOL)animated {
  [self generateTags];
}

- (void)generateTags {
  NSMutableDictionary *tagDict = [NSMutableDictionary dictionary];
  for (int i = 0; i < 10; i++) {
    int value = rand() % 20;
    [tagDict setObject:[NSNumber numberWithInt:value] forKey:[NSString stringWithFormat:@"tag%d", i]];
  }
  
  HPLTagCloudGenerator *tagGenerator = [[HPLTagCloudGenerator alloc] init];
  tagGenerator.size = CGSizeMake(self.tagView.frame.size.width, self.tagView.frame.size.height);
  tagGenerator.tagDict = tagDict;
  
#if OLD_STYLE
  NSArray *views = [tagGenerator generateTagViews];
  
  for (UIView *view in _tagView.subviews) {
    [view removeFromSuperview];
  }

  for (UIView *view in views) {
    [_tagView addSubview:view];
  }
#else
  NSDictionary *tags = [tagGenerator generateTags];
  _tagLabelViews = [tagGenerator updateViews:_tagLabelViews inView:self.tagView withTags:tags animate:YES];
#endif
}

@end
