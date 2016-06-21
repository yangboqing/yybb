//
//  DlfromDefine.h
//  browser
//
//  Created by 王毅 on 14-6-17.
//
//

/*
 需要用到的参数说明
 index:为位置 或者 行数 或者 个数，也就是列表里的第几行，非列表的话就是第几个的位置
 ID:为分类ID  或者 专题ID  根据不同的宏，理解为相应的含义
 appid:为应用的appid
 beforepage：为详情页的上一级的视图或者控制器，上一级也从本类中选取，将本类中相应的成为上一级的宏作为参数传入其中
 */
//轮播类型
#define LUNBO_JINGXUAN  @"jingxuan"
#define LUNBO_GAME      @"game"
#define LUNBO_APP       @"app"
#define LUNBO_DISCOVERY @"discovery"

//市场精选
#define HOME_PAGE_JINGXUAN          @"kyclient_jingxuan"
//市场应用
#define HOME_PAGE_APP          @"kyclient_APP"
//市场游戏
#define HOME_PAGE_GAME          @"kyclient_GAME"

//首页精彩推荐
#define HOME_PAGE_RECOMMEND(index) [NSString stringWithFormat:@"kyclient_index_recommend_%ld",index]

#define HOME_PAGE_RECOMMEND_MY(section,row) [NSString stringWithFormat:@"kyclient_index_recommend_%ld_%ld",section,row]


//最新游戏
#define NEW_GAME(index) [NSString stringWithFormat:@"kyclient_new_game_%d",index]

//最新应用
#define NEW_APP(index) [NSString stringWithFormat:@"kyclient_new_app_%d",index]


//游戏排行榜-周排行
#define GAME_WEEK_RANKING(index) [NSString stringWithFormat:@"kyclient_ranking-game_week_%d",index]


//游戏排行榜-月排行
#define GAME_MONTH_RANKING(index) [NSString stringWithFormat:@"kyclient_ranking-game_month_%d",index]


//游戏排行榜-总排行
#define GAME_TOTAL_RANKING(index) [NSString stringWithFormat:@"kyclient_ranking-game_total_%d",index]


//应用排行榜-周排行
#define APP_WEEK_RANKING(index) [NSString stringWithFormat:@"kyclient_ranking-app_week_%d",index]


//应用排行榜-月排行
#define APP_MONTH_RANKING(index) [NSString stringWithFormat:@"kyclient_ranking-app_month_%d",index]


//应用排行榜-总排行
#define APP_TOTAL_RANKING(index) [NSString stringWithFormat:@"kyclient_ranking-app_total_%d",index]

//2.7新增 免费-应用
#define APP_FREE(index) [NSString stringWithFormat:@"kyclient_free_app_%d",index]
//2.7新增 免费-应用
#define GAME_FREE(index) [NSString stringWithFormat:@"kyclient_free_game_%d",index]


//热门游戏
#define HOT_GAME(index) [NSString stringWithFormat:@"kyclient_hots_game_%d",index]


//热门应用
#define HOT_APP(index) [NSString stringWithFormat:@"kyclient_hots_app_%d",index]

//封测游戏
#define FENGCE_GAME(index) [NSString stringWithFormat:@"kyclient_fengces_game_%d",index]

//分类应用
#define CATEGORY_APP(ID,index) [NSString stringWithFormat:@"kyclient_category_%@_%d",ID,index]


//专题应用
#define SPECIAL_APP(ID,index) [NSString stringWithFormat:@"kyclient_special_%@_%ld",ID,index]

//搜索应用
#define SEARCH_APP(index) [NSString stringWithFormat:@"kyclient_search_%d",index]


//首页轮播

//type四个参数选择:1.jingxuan 2.game 3.app 4.discovery
#define HOME_PAGE_LUNBO(type,index) [NSString stringWithFormat:@"kyclient_lunbo_%@_%ld",type,index]


//详情页相关应用
#define DEVELOPER_OTHER_APP(appid,index) [NSString stringWithFormat:@"kyclient_developer_%@_%ld",appid,index]


//联通3G/4G免流量下载
#define CHINAUNICOM_FREE_FLOW(index) [NSString stringWithFormat:@"kyclient_unicomfreeflow_%ld",index]


//特权活动
#define PRIVILEGE_ACTIVITY(index) [NSString stringWithFormat:@"kyclient_privilegeactivity_%ld",index]


//详情页
#define APP_DETAIL(beforepage) [NSString stringWithFormat:@"%@_detail",beforepage]


//更新
#define APP_UPDATE(appid,index) [NSString stringWithFormat:@"kyclient_update_control_%@_%d",appid,index]


//优秀游戏
#define GOOD_GAME(index) [NSString stringWithFormat:@"kyclient_goodgame_%ld",index]

//优秀应用
#define GOOD_APP(index) [NSString stringWithFormat:@"kyclient_goodapp_%ld",index]

//修复应用
#define REPAIR_APP(index) [NSString stringWithFormat:@"kyclient_repairapp_%d",index]




//MY新增

#define SPECIAL_PUSH @"SPECIAL_PUSH"

#define FIND_LUNBO(type,index) [NSString stringWithFormat:@"find_lunbo_%@_%ld",type,index]
// 限免应用（限免金榜）

#define LIMITFREE_APP(index) [NSString stringWithFormat:@"kyclient_limitFree_%ld",index]

#define HOME_PAGE_LIMITFREE_APP(index) [NSString stringWithFormat:@"kyclient_recommend_limitFree_%ld",index]

// 免费应用（免费畅玩）
#define FREE_APP(index) [NSString stringWithFormat:@"kyclient_free_App_%ld",index]
#define HOME_PAGE_FREE_APP(index) [NSString stringWithFormat:@"kyclient_recommend_free_App_%ld",index]

// 免费游戏
#define FREE_GAME(index) [NSString stringWithFormat:@"kyclient_free_Game_%ld",index]
#define HOME_PAGE_FREE_GAME(index) [NSString stringWithFormat:@"kyclient_recommend_free_Game_%ld",index]

// 付费应用（畅销金榜）
#define PAID_APP(index) [NSString stringWithFormat:@"kyclient_Paid_App_%ld",index]
#define HOME_PAGE_PAID_APP(index) [NSString stringWithFormat:@"kyclient_recommend_Paid_App_%ld",index]

// 付费游戏
#define PAID_GAME(index) [NSString stringWithFormat:@"kyclient_Paid_Game_%ld",index]
#define HOME_PAGE_PAID_GAME(index) [NSString stringWithFormat:@"kyclient_recommend_Paid_Game_%ld",index]

// 装机必备应用
#define INSTALL_APP(index) [NSString stringWithFormat:@"kyclient_install-essential_%ld",index]

// 专题(专题库)
#define SPECIAL(index) [NSString stringWithFormat:@"kyclient_special_%ld",index]

#define SPECIAL_PUSH @"SPECIAL_PUSH"

// 优秀应用
#define EXCELLENT_APP(index) [NSString stringWithFormat:@"kyclient_excellent_app_%ld",index]

// 优秀游戏
#define EXCELLENT_GAME(index) [NSString stringWithFormat:@"kyclient_excellent_game_%ld",index]



#define DISCOVERY_PINGCE   @"pingce"
#define DISCOVERY_ACTIVE   @"active"
#define DISCOVERY_ZIXUN    @"zixun"
#define DISCOVERY_APPLEPIE @"applePie" // 苹果派
// 发现（特权活动 兼容）1、jingxuan 2、pingce 3、zixun 4、pingguopai
#define PRIVILEGE_ACTIVITY_MY(type,index) [NSString stringWithFormat:@"kyclient_privilegeactivity_%@_%ld",type,index]




// 详情页
#define DETAIL(beforepage) [NSString stringWithFormat:@"%@_detail",beforepage]
