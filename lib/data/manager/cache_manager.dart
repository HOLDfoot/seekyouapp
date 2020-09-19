
import 'package:seekyouapp/data/constant/sp_constant.dart';
import 'package:seekyouapp/util/logger.dart';
import 'package:seekyouapp/util/sp_util.dart';

class CacheManager {

  static CacheManager _instance;

  CacheManager._();

  static CacheManager getInstance() {
    if (_instance == null) {
      _instance = CacheManager._();
    }
    return _instance;
  }

  void clearCache() async {
    SpUtil.remove(SpConstant.SP_USER_INFO);
    //SpUtil.remove(SpConstant.SP_GLOBAL_PARAM);
    SpUtil.remove(SpConstant.SP_HOME_BEAN);
    SpUtil.remove(SpConstant.SP_USER_FIRST_ENTER_HOME);
    //SpUtil.remove(SpConstant.SP_SET_TEST_SERVER);
    bool isRemove = await SpUtil.remove(SpConstant.SP_AUTO_DAILY_TEST_DATE);
    Logger.log("isRemove: $isRemove");
  }
}