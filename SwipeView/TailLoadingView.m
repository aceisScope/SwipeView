//
//  TailLoadingView.m
//  SwipeViewExample
//
//  Created by B.H.Liu on 13-7-18.
//
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#import "TailLoadingView.h"

@implementation TailLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height/2 + 20.0f, frame.size.width, 20.0f)];
		_loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _loadingLabel.backgroundColor = [UIColor clearColor];
		_loadingLabel.font = [UIFont systemFontOfSize:10.0f];
		_loadingLabel.textColor = RGB(87, 108, 137);
		_loadingLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_loadingLabel];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
        _activityView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
		[self addSubview:_activityView];
        
        [self setIsVertical:NO];
        [self changeStatus:TailLoadingNormal];
    }
    return self;
}


#pragma mark - 
#pragma mark - private
- (void)changeStatus:(LoadingViewStatus)aStatus{
	
	switch (aStatus) {
		case TailLoadingDragging:
        {
			_loadingLabel.text = @"Release to load";
        }
			
			break;
		case TailLoadingNormal:
        {
			_loadingLabel.text = @"Drag to load";
			[_activityView stopAnimating];
        }
			
			break;
		case TailLoadingOngoing:
        {
			_loadingLabel.text = @"Loading...";
			[_activityView startAnimating];
        }
			
			break;
		default:
			break;
	}
	
	status = aStatus;
}

#pragma mark -
#pragma mark - ScrollView Methods

- (void)tailloadingScrollViewDidScroll:(UIScrollView *)scrollView
{	
	if (status == TailLoadingOngoing)
    {
        if (_isVertical) {
            CGFloat offset = MAX((scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height))* -1, 0);
            offset = MAX(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f, offset, 0.0f);
            scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height + 60);
        }else{
            CGFloat offset = MAX((scrollView.contentSize.width - (scrollView.contentOffset.x + scrollView.frame.size.width))* -1, 0);
            offset = MAX(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f, 0.0f, offset);
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width + 60, 0);
        }

	}
    else if (scrollView.isDragging)
    {
		
		BOOL isloading = NO;
		if ([_delegate respondsToSelector:@selector(tailloadDataSourceIsLoading:)]) {
			isloading = [_delegate tailloadDataSourceIsLoading:self];
		}
        
        if (!_isVertical) {
            if (status == TailLoadingDragging && scrollView.contentOffset.x + scrollView.frame.size.width < scrollView.contentSize.width+65.0f && scrollView.contentOffset.x > scrollView.contentSize.width && !isloading)
            {
                [self changeStatus:TailLoadingNormal];
            }
            else if (status == TailLoadingNormal && scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width+65.0f && !isloading)
            {
                [self changeStatus:TailLoadingDragging];
            }
        }else{
            if (status == TailLoadingDragging && scrollView.contentOffset.y + scrollView.frame.size.height < scrollView.contentSize.height+65.0f && scrollView.contentOffset.y > scrollView.contentSize.height && !isloading)
            {
                [self changeStatus:TailLoadingNormal];
            }
            else if (status == TailLoadingNormal && scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height+65.0f && !isloading)
            {
                [self changeStatus:TailLoadingDragging];
            }
        }

		
		if (scrollView.contentInset.right != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)tailloadingScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
	BOOL isloading = NO;
	if ([_delegate respondsToSelector:@selector(tailloadDataSourceIsLoading:)])
    {
		isloading = [_delegate tailloadDataSourceIsLoading:self];
	}
    
    if (!_isVertical) {
        if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width+65.0f && !isloading) {
            
            if ([_delegate respondsToSelector:@selector(tailloadingDidTriggerLoad:)])
            {
                [_delegate tailloadingDidTriggerLoad:self];
            }
            
            [self changeStatus:TailLoadingOngoing];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f, 0.0f, 60.f);
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width + 60, 0);
            [UIView commitAnimations];
            
        }
    }
    else{
        if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height+55.0f && !isloading) {
            
            if ([_delegate respondsToSelector:@selector(tailloadingDidTriggerLoad:)])
            {
                [_delegate tailloadingDidTriggerLoad:self];
            }
            
            [self changeStatus:TailLoadingOngoing];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f, 60.0f, 00.f);
            scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height + 60);
            [UIView commitAnimations];
            
        }
    }
	
}

- (void)tailloadingScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [self changeStatus:TailLoadingNormal];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsZero];
    if (!_isVertical) {
        if (scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width, 0);
        }
    }else{
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
        }
    }

	[UIView commitAnimations];
    
}


@end
