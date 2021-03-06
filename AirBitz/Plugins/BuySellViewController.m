//
//  BuySellViewController.m
//  AirBitz
//

#import "BuySellViewController.h"
#import "BuySellCell.h"
#import "PluginViewController.h"
#import "WalletHeaderView.h"
#import "Plugin.h"
#import "Util.h"

@interface BuySellViewController () <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, PluginViewControllerDelegate>
{
    PluginViewController *_pluginViewController;
}

@property (nonatomic, strong) WalletHeaderView    *activePluginsView;
@property (nonatomic, weak) IBOutlet UILabel      *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton     *backButton;
@property (nonatomic, weak) IBOutlet UITableView  *pluginTable;

@end

@implementation BuySellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    _pluginTable.dataSource = self;
    _pluginTable.delegate = self;
    _pluginTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _backButton.hidden = YES;

    _activePluginsView = [WalletHeaderView CreateWithTitle:NSLocalizedString(@"", nil) collapse:NO];
    _activePluginsView.btn_expandCollapse.hidden = YES;
    _activePluginsView.btn_addWallet.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _pluginTable.editing = NO;
}

#pragma mark - UITableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _activePluginsView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Plugin getPlugins] count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuySellCell";
    NSInteger row = [indexPath row];
 
    BuySellCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BuySellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Plugin *plugin = [[Plugin getPlugins] objectAtIndex:row];
    [cell setInfo:row tableHeight:[tableView numberOfRowsInSection:indexPath.section]];
    cell.text.text = plugin.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    Plugin *plugin = [[Plugin getPlugins] objectAtIndex:row];
    [self launchPlugin:plugin];
}

- (BOOL)launchPluginByCountry:(NSString *)country provider:(NSString *)provider
{
    Plugin *plugin = nil;
    for (Plugin *p in [Plugin getPlugins]) {
        if ([provider isEqualToString:p.provider]
          && [country isEqualToString:p.country]) {
            plugin = p;
        }
    }
    if (plugin != nil) {
        [self launchPlugin:plugin];
        return YES;
    }
    return NO;
}

- (void)launchPlugin:(Plugin *)plugin
{
    if (_pluginViewController != nil) {
        [_pluginViewController.view removeFromSuperview];
        [_pluginViewController removeFromParentViewController];

    }
    UIStoryboard *pluginStoryboard = [UIStoryboard storyboardWithName:@"Plugins" bundle: nil];
    _pluginViewController = [pluginStoryboard instantiateViewControllerWithIdentifier:@"PluginViewController"];
    _pluginViewController.delegate = self;
    _pluginViewController.plugin = plugin;

    [Util animateController:_pluginViewController parentController:self];
}

#pragma mark - PluginViewControllerDelegate

- (void)PluginViewControllerDone:(PluginViewController *)controller
{
    [Util animateOut:controller parentController:self complete:^(void) {
        _pluginViewController = nil;
    }];
}

@end
