//
//  TailLoadingView.h
//  SwipeViewExample
//
//  Created by B.H.Liu on 13-7-18.
//
//

#import <UIKit/UIKit.h>


typedef enum{
    TailLoadingDragging = 0,
    TailLoadingOngoing,
    TailLoadingNormal
} LoadingViewStatus;

@class TailLoadingView;

@protocol TailloadingDelegate <NSObject>

- (void)tailloadingDidTriggerLoad:(TailLoadingView*)view;
- (BOOL)tailloadDataSourceIsLoading:(TailLoadingView*)view;

@end

@interface TailLoadingView : UIView
{
    UILabel *_loadingLabel;
    UIActivityIndicatorView *_activityView;
    LoadingViewStatus status;
}

@property (nonatomic,assign) id <TailloadingDelegate> delegate;
@property (nonatomic,readwrite) BOOL isVertical;

- (void)tailloadingScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)tailloadingScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)tailloadingScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
