/*******************************************************************************
 * Copyright 2011 Beintoo - author gpiazzese@beintoo.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "Beintoo.h"

@interface BeintooBestoreVC : UIViewController <UIWebViewDelegate, BeintooPlayerDelegate>
{
    IBOutlet UIWebView      *webView;
    BeintooPlayer           *beintooPlayer;
}

@property(nonatomic,assign) BOOL    isFromNotification;
@property(nonatomic, retain) IBOutlet UIWebView *webView;

@end
