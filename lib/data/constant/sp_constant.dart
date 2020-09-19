/// app缓存的常量key
class SpConstant {
  static const String SP_USER_INFO = "SP_USER_INFO";
  static const String SP_GLOBAL_PARAM = "SP_GLOBAL_PARAM";

  static const String SP_HOME_BEAN = "SP_HOME_BEAN";
  static const String SP_HOME_RECOMMEND_MOOD_LIST_BEAN = "SP_HOME_RECOMMEND_MOOD_LISTBEAN";
  static const String SP_HOME_NEWEST_MOOD_LIST_BEAN = "SP_HOME_NEWEST_MOOD_LISTBEAN";

  static const String SP_USER_FIRST_ENTER_HOME = "SP_USER_FIRST_ENTER_HOME";

  static const String SP_SET_TEST_SERVER = "SP_IS_TEST_SERVER";

  static const String SP_CARF_DEFINDEX = "SP_CARF_DEFINDEX";
  /// 每日第一次到历史测试页面的时候需要弹出当日的测试题界面, 第二次不用
  static const String SP_AUTO_DAILY_TEST_DATE = "SP_AUTO_DAILY_TEST_DATE";

  /// 房树人绘画界面中间的提示条
  static const String SP_SHOW_HTP_INNER_TIP = "SP_SHOW_HTP_INNER_TIP";

  /// 消息列表进入聊天页面 存一下聊天用户名 / 是对方否移除会话 和 是否关闭聊天 的状态 todo wanqiu 通过路由传值一直失败,暂时找不到原因,需要再优化
  static const String SP_CONVERSATION_NAME = "SP_CONVERSATION_NAME";
  static const String SP_CONVERSATION_REMOVE_CHAT = "SP_CONVERSATION_REMOVE_CHAT";
  static const String SP_CONVERSATION_CLOSE_CHAT = "SP_CONVERSATION_CLOSE_CHAT";

  /// 心情正文跟用户互动成功之后的弹窗提示  只提示一次
  static const String SP_SHOW_INTERACTION_DIALOG = "SP_SHOW_INTERACTION_DIALOG";

  /// H5调用Flutter分享 通过标识符注入js代码 获取分享的内容
  static const String SP_SHARE_WEB_DATA = "ShareData";  // 该值跟H5保持统一,如需更换需通知H5

  /// H5调用Flutter立马反馈 通过标识符注入js代码 调用原生跳转到建议反馈页面
  static const String SP_SUGGEST_NOW = "suggestNow";  // 该值跟H5保持统一,如需更换需通知H5

  /// ai version
  static int SP_AI_VERSION = 0;  // ai版本号

  /// 首页最新列表组件对应的 widget Key
  static const String SP_NEWEST_WIDGET_KEY = "Tab1";

  /// 首页推荐列表组件对应的 widget Key
  static const String SP_RECOMMEND_WIDGET_KEY = "Tab0";

  /// 性格测试列表页面用到 测试类型是MBTI 需要跟后台保持一致 如需改变需要同步
  static const String SP_TEST_TYPE_MBTI = "MBTI";

  /// 性格测试列表页面用到 测试类型是HTP  需要跟后台保持一致 如需改变需要同步
  static const String SP_TEST_TYPE_HTP = "HTP";

  /// 性格测试列表页面用到 测试类型是WEB  需要跟后台保持一致 如需改变需要同步
  static const String SP_TEST_TYPE_WEB = "WEB";

}
