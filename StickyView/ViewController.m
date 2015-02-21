//
//  ViewController.m
//  StickyView
//
//  Created by Ido Mizrachi on 2/19/15.
//  Copyright (c) 2015 Ido Mizrachi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *stickyHeaderView;
@property (nonatomic, assign) BOOL isHeaderStuck;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isHeaderStuck = NO;

    // Do any additional setup after loading the view, typically from a nib.
    [_scrollView addObserver: self
                  forKeyPath: NSStringFromSelector(@selector(contentOffset))
                     options:NSKeyValueObservingOptionNew
                     context: nil];
}

-(void) viewDidLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupScrollView];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupScrollView {
    NSUInteger numberOfView = 8;
    CGFloat height = _scrollView.bounds.size.height / 3.0;
    CGFloat red = 0, green = 0, blue = 1.0f;
    CGRect frame;
    
    frame = CGRectMake(0.0f, 0.0f, _scrollView.bounds.size.width, 100.0f);
    _headerView = [[UIView alloc] initWithFrame: frame];
    _headerView.backgroundColor = [UIColor colorWithRed: 1.0 green: 0.0 blue: 1.0 alpha: 1.0];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _headerView.translatesAutoresizingMaskIntoConstraints = YES;
    [_scrollView addSubview: _headerView];

    frame = CGRectMake(0.0f, 100, _scrollView.bounds.size.width, 90.0f);
    _stickyHeaderView = [[UIView alloc] initWithFrame: frame];
    _stickyHeaderView.backgroundColor = [UIColor colorWithRed: 0.0 green: 1.0 blue: 1.0 alpha: 1.0];
    _stickyHeaderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _stickyHeaderView.translatesAutoresizingMaskIntoConstraints = YES;
    [_scrollView addSubview: _stickyHeaderView];
    
    for (NSUInteger i = 0; i < numberOfView; i++) {
        frame = CGRectMake(0, 190.0f + i * height, _scrollView.bounds.size.width, height);
        red = green = (CGFloat) i / (CGFloat) numberOfView;
        UIView *view = [[UIView alloc] initWithFrame: frame];
        view.backgroundColor = [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f];
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        view.translatesAutoresizingMaskIntoConstraints = YES;
        [_scrollView addSubview: view];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, 190 + height * numberOfView);
    
}

-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    NSValue *value = change[@"new"];
    CGPoint point = value.CGPointValue;
    if (point.y >= 100) {
        if (! _isHeaderStuck) {
            _isHeaderStuck = YES;
            [_stickyHeaderView removeFromSuperview];
            [self.view addSubview: _stickyHeaderView];
            _stickyHeaderView.frame = CGRectMake(0, 0, _stickyHeaderView.bounds.size.width, _stickyHeaderView.bounds.size.height);
        }
    } else {
        if (_isHeaderStuck) {
            _isHeaderStuck = NO;
            [_stickyHeaderView removeFromSuperview];
            [_scrollView addSubview: _stickyHeaderView];
            _stickyHeaderView.frame = CGRectMake(0, 100, _stickyHeaderView.bounds.size.width, _stickyHeaderView.bounds.size.height);
        }
    }
}


@end
