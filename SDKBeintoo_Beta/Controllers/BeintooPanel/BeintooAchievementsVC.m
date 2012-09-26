/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
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


#import "BeintooAchievementsVC.h"
#import "Beintoo.h"

@implementation BeintooAchievementsVC

@synthesize achievementsArrayList,achievementsImages;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"achievements",@"BeintooLocalizable",@"Wallet");
	
	[walletView setTopHeight:20];
	[walletView setBodyHeight:460];

	achievementsTable.delegate	= self;
	achievementsTable.rowHeight	= 70.0;
	walletLabel.text		= NSLocalizedStringFromTable(@"hereiswallet",@"BeintooLocalizable",@"");
	

	_achievements               = [[BeintooAchievements alloc] init];
	_player                     = [[BeintooPlayer alloc] init];
    archiveAchievements         = [[NSMutableArray alloc] init];

	UIBarButtonItem *barCloseBtn = [[UIBarButtonItem alloc] initWithCustomView:[self closeButton]];
	[self.navigationItem setRightBarButtonItem:barCloseBtn animated:YES];
	[barCloseBtn release];
	
	self.achievementsArrayList = [[NSMutableArray alloc] init];
	self.achievementsImages    = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    if ([BeintooDevice isiPad]) {
        [self setContentSizeForViewInPopover:CGSizeMake(320, 436)];
    }
    
    _achievements.delegate	 = self;

    noAchievementsLabel.text		= NSLocalizedStringFromTable(@"noAchievementsLabel",@"BeintooLocalizable",@"");
    
    [self.achievementsArrayList removeAllObjects];
    [self.achievementsImages removeAllObjects];
    [achievementsTable reloadData];
    [noAchievementsLabel setHidden:YES];
    [achievementsTable deselectRowAtIndexPath:[achievementsTable indexPathForSelectedRow] animated:YES];
    [BLoadingView startActivity:self.view];
    [_achievements getAchievementsForCurrentUser];
}

#pragma mark -
#pragma mark Delegates

- (void)didGetAllUserAchievementsWithResult:(NSArray *)result{
    
	[self.achievementsArrayList removeAllObjects];
	[self.achievementsImages removeAllObjects];
	[noAchievementsLabel setHidden:YES];
	if ([result count] <= 0) {
		[noAchievementsLabel setHidden:NO];
	}
	if ([result isKindOfClass:[NSDictionary class]]) {
		[noAchievementsLabel setHidden:NO];
		[BLoadingView stopActivity];
		[achievementsTable reloadData];
		return;
	}
	
	for (int i = 0; i < [result count]; i++) {
        NSMutableDictionary *achievementEntry = [[NSMutableDictionary alloc] init];
        BImageDownload *download = [[BImageDownload alloc] init];
		
        @try {
			
			NSDictionary *currentAchievement = [[result objectAtIndex:i] objectForKey:@"achievement"];
            
			NSString *name          = [currentAchievement objectForKey:@"name"]; 
			NSString *description   = [currentAchievement objectForKey:@"description"]; 
			NSString *bedollarsVal	= [NSString stringWithFormat:@"%.0f", [[currentAchievement objectForKey:@"bedollars"] floatValue]];
			NSString *imageURL		= [currentAchievement objectForKey:@"imageURL"];
            
			NSString *blockedBy		= [currentAchievement objectForKey:@"blockedBy"];
			BOOL isBlockedByOthers = FALSE;
			if (blockedBy != nil) {
				isBlockedByOthers = TRUE;
			}
            
			download.delegate = self;
            
            if ([imageURL length] > 0) 
                download.urlString = [imageURL copy];
			
            if ([name length] > 0) 
                [achievementEntry setObject:name forKey:@"name"];
            
            if ([description length] > 0) 
                [achievementEntry setObject:description	forKey:@"description"];
            
            if ([bedollarsVal length] > 0) 
                [achievementEntry setObject:bedollarsVal forKey:@"bedollarsValue"];
            
            if ([imageURL length] > 0) 
                [achievementEntry setObject:imageURL forKey:@"imageURL"];
            
			if (isBlockedByOthers) {
				[achievementEntry setObject:blockedBy forKey:@"blockedBy"];
			}
            
			[achievementsArrayList addObject:achievementEntry];
			[achievementsImages addObject:download];
            
		}
		@catch (NSException * e) {
			BeintooLOG(@"BeintooException: %@ \n for object: %@", e, [result objectAtIndex:i]);
		}
        [download release];
        [achievementEntry release];
	}
    
    archiveAchievements = [result mutableCopy];
    
	[achievementsTable reloadData];
	[BLoadingView stopActivity];
    
    [self performSelector:@selector(updateProgress) withObject:nil afterDelay:0.2];
}

- (void)updateProgress{
    for (int i = 0; i < [archiveAchievements count]; i++){
        if ([[archiveAchievements objectAtIndex:i] objectForKey:@"percentage"]){
            NSString *percentage   = [[archiveAchievements objectAtIndex:i] objectForKey:@"percentage"];
            [[achievementsArrayList objectAtIndex:i] setObject:percentage forKey:@"percentage"];
            NSUInteger indices[] = {0, i};
            NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
            UITableViewCell *cell = [achievementsTable cellForRowAtIndexPath:path];
            for (UIView *subview in cell.subviews){
                if ([subview isKindOfClass:[UIProgressView class]]){
                    UIProgressView *progessView = (UIProgressView *)subview;
                    [progessView setProgress:[percentage floatValue]/100 animated:YES];
                }
            }
            [path release];
        }
        else if ([[[archiveAchievements objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"UNLOCKED"]) {
            [[achievementsArrayList objectAtIndex:i] setObject:@"100" forKey:@"percentage"];
            NSUInteger indices[] = {0, i};
            NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
            UITableViewCell *cell = [achievementsTable cellForRowAtIndexPath:path];
            for (UIView *subview in cell.subviews){
                if ([subview isKindOfClass:[UIProgressView class]]){
                    UIProgressView *progessView = (UIProgressView *)subview;
                    [progessView setProgress:1.0 animated:YES];
                }
            }
            [path release];
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.achievementsArrayList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
   	int _gradientType = (indexPath.row % 2) ? GRADIENT_CELL_HEAD : GRADIENT_CELL_BODY;
	
	BTableViewCell *cell = (BTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil || TRUE) {
        cell = [[[BTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier andGradientType:_gradientType] autorelease];
    }	
	
	@try {

		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 180, 18)];
		textLabel.text = [[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"name"];
		textLabel.font = [UIFont systemFontOfSize:13];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 180, 18)];
		detailTextLabel.text = [[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"description"];
		detailTextLabel.font = [UIFont systemFontOfSize:12];
		detailTextLabel.numberOfLines = 1;
		detailTextLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7];
		detailTextLabel.backgroundColor = [UIColor clearColor];
		detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UILabel *bedollars = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 70, 20)];
		bedollars.text = @"Bedollars";
		bedollars.font = [UIFont systemFontOfSize:11];
		bedollars.textColor = [UIColor colorWithWhite:0 alpha:0.6];
		bedollars.backgroundColor = [UIColor clearColor];
		bedollars.textAlignment		= UITextAlignmentRight;
		bedollars.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin;
		bedollars.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
		
		NSString *value = [NSString stringWithFormat:@"%@",[[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"bedollarsValue"]]; 
		UILabel *bedollarsValue = [[UILabel alloc] initWithFrame:CGRectMake(240, 18, 70, 50)];
		bedollarsValue.text = [NSString stringWithFormat:@"+%@",value]; 
		bedollarsValue.font = [UIFont systemFontOfSize:20];
		bedollarsValue.textColor = [UIColor colorWithWhite:0 alpha:0.6];
		bedollarsValue.backgroundColor = [UIColor clearColor];
		bedollarsValue.textAlignment	= UITextAlignmentRight;
		bedollarsValue.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin;
		bedollarsValue.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
		
		if ([value intValue] > 0) {
			[cell addSubview:bedollars];
			[cell addSubview:bedollarsValue];
		}
        
        UIProgressView *progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(70, 50, self.view.frame.size.width - 70 - 70, 40)];
        progressBar.progressViewStyle = UIProgressViewStyleBar;
        progressBar.opaque = YES;
        progressBar.progress = 0.0;
        
        if ([[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"percentage"])
            [progressBar setProgress:([[[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"percentage"] floatValue] / 100) animated:NO];
        else if ([[[achievementsArrayList objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"UNLOCKED"])
            [progressBar setProgress:100 animated:NO];
        
        [cell addSubview: progressBar];
        [progressBar release];
        
		BImageDownload *download = [achievementsImages objectAtIndex:indexPath.row];
		UIImage *cellImage  = download.image;
        
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 55, 55)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.backgroundColor = [UIColor clearColor];
		[imageView setImage:cellImage];
		
		[cell addSubview:textLabel];
		[cell addSubview:detailTextLabel];
		[cell addSubview:imageView];
        
		[textLabel release];
		[detailTextLabel release];
		[imageView release];
		[bedollars release];
		[bedollarsValue release];
	}
	@catch (NSException * e) {
		//[_player logException:[NSString stringWithFormat:@"STACK: %@\n\nException: %@",[NSThread callStackSymbols],e]];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[achievementsTable deselectRowAtIndexPath:[achievementsTable indexPathForSelectedRow] animated:NO];
	[BPopup showPopupForAchievement:[achievementsArrayList objectAtIndex:indexPath.row] insideView:self.view];
}

#pragma mark -
#pragma mark BImageDownload Delegate Methods

- (void)bImageDownloadDidFinishDownloading:(BImageDownload *)download{
    NSUInteger index = [self.achievementsImages indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [achievementsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}

- (void)bImageDownload:(BImageDownload *)download didFailWithError:(NSError *)error{
    BeintooLOG(@"Beintoo - Image Loading Error: %@", [error localizedDescription]);
}

- (UIView *)closeButton{
    UIView *_vi = [[UIView alloc] initWithFrame:CGRectMake(-25, 5, 35, 35)];
    
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    _imageView.image = [UIImage imageNamed:@"bar_close_button.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	closeBtn.frame = CGRectMake(6, 6.5, 35, 35);
    [closeBtn addSubview:_imageView];
	[closeBtn addTarget:self action:@selector(closeBeintoo) forControlEvents:UIControlEventTouchUpInside];
    
    [_vi addSubview:closeBtn];
	
    return _vi;
}

- (void)closeBeintoo{
    BeintooNavigationController *navController = (BeintooNavigationController *)self.navigationController;
    [Beintoo dismissBeintoo:navController.type];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _achievements.delegate   = nil;
    
    @try {
		[BLoadingView stopActivity];
	}
	@catch (NSException * e) {
	}
}

- (void)dealloc {
	[self.achievementsArrayList release];
	[self.achievementsImages	release];
	[_player release];
	[_achievements release];
    [archiveAchievements release];
    [super dealloc];
}

@end
