import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/model/accounts_model.dart';
import 'package:xiaoyanshuo_beta/pages/AccountsCards.dart';
import 'package:xiaoyanshuo_beta/pages/AddAccounts.dart';
import 'package:xiaoyanshuo_beta/utils/HttpManager.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:xiaoyanshuo_beta/utils/ResultData.dart';
import 'package:xiaoyanshuo_beta/widgets/MainDrawer.dart';
import 'package:xiaoyanshuo_beta/widgets/Notdatafound.dart';
import 'package:xiaoyanshuo_beta/widgets/charts/AreaAndLineChart.dart';
import 'package:xiaoyanshuo_beta/widgets/charts/PieCharts.dart';
import 'package:xiaoyanshuo_beta/widgets/charts/simpleBarCharts.dart';

class AccountsChart extends StatefulWidget {
  @override
  _AccountsChartState createState() => _AccountsChartState();
}

class _AccountsChartState extends State<AccountsChart>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List _tabs = ["分类统计", "收入支出", "余额变化"];
  List<AccountsModel> _accountsList ;

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void getData() async {
    ResultData res = await HttpManager.request(
        '/account?filter={"order":"time ASC","include":"cost_typePointer"}');
    
    if (res.code == 200 ) {
      List resList = res.data;
      List<AccountsModel> accountsData =
          resList.map((v) => AccountsModel.fromJson(v)).toList();
      setState(() {
        _accountsList = accountsData;
      });
    } else {
       Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(res.data),
      ));
    }
  }


  void _goToAddPage() async {
    
    var res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AddAccounts()));
    if (res !=null) {
      //处理页面返回的回调
      getData();
    }
  }
  
  //"分类统计",
  List<charts.Series<CostTypeMoney, String>>  pieData() {
    Map<String, int> mapCostType = {};
    //
    for (var item in _accountsList) {
      if (mapCostType != null && mapCostType[item.cost_type.name] != null) {
      
        mapCostType[item.cost_type.name] += item.money;
       
      } else {
        mapCostType[item.cost_type.name] = item.money;
      }
    }
    List<CostTypeMoney> CostTypeMoneyList = [];
    for (var item in mapCostType.keys) {
      CostTypeMoneyList.add(CostTypeMoney(item, mapCostType[item]));
    }
    CostTypeMoneyList.sort((b, a) => a.money.compareTo(b.money));

    return [
      new charts.Series<CostTypeMoney, String>(
        id: 'CostTypeMoney',
        domainFn: (CostTypeMoney costTypeMoney, _) => costTypeMoney.type,
        measureFn: (CostTypeMoney costTypeMoney, _) => costTypeMoney.money,
        data: CostTypeMoneyList,
         labelAccessorFn: (CostTypeMoney row, _) => '${row.type}: ${row.money}',
      )
    ];
  }

  

  // "余额统计"
  List<charts.Series<TimeSeriesMoney, DateTime>> lineData() {
    int amountMoney=0;
    Map<DateTime, int> mapAccount = {};
    //
    for (var item in _accountsList) {
      // if (mapAccount != null && mapAccount[DateTime.parse(item.time)] != null) {
      //  if(item.is_income) {
      //    mapAccount[DateTime.parse(item.time)] =amountMoney+ item.money;
      //  }else{
      //     mapAccount[DateTime.parse(item.time)] =amountMoney- item.money;
      //  }
      // } else {
      // }
        if(item.is_income) {
          amountMoney+= item.money;
         mapAccount[DateTime.parse(item.time)] =amountMoney;
       }else{
          amountMoney-= item.money;
        mapAccount[DateTime.parse(item.time)] =amountMoney;
       }
    }
    List<TimeSeriesMoney> TimeSeriesMoneyList = [];
    for (var item in mapAccount.keys) {
      TimeSeriesMoneyList.add(TimeSeriesMoney(item, mapAccount[item]));
    }
    TimeSeriesMoneyList.sort((a, b) => a.time.compareTo(b.time));

    return [
      new charts.Series<TimeSeriesMoney, DateTime>(
        id: 'TimeSeriesMoney',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesMoney timeSeriesMoney, _) => timeSeriesMoney.time,
        measureFn: (TimeSeriesMoney timeSeriesMoney, _) => timeSeriesMoney.money,
        data: TimeSeriesMoneyList,
      )
    ];
  }

  // "收入支出变化"
  List<charts.Series<TimeMoney, String>> barData() {
    Map<String, int> mapAccount1 = {};
    Map<String, int> mapAccount2 = {};
    List<TimeMoney> isIncomeTimeMoneyList1 = [];
    List<TimeMoney> isIncomeTimeMoneyList2 = [];
    List<AccountsModel> isIncomeList=_accountsList.where((v)=>v.is_income).toList();
    List<AccountsModel> notIncomeList=_accountsList.where((v)=>!v.is_income).toList();
    //1 收入
    for (var item in isIncomeList) {
      if (mapAccount1 != null && mapAccount1[item.time.substring(2,7)] != null) {
        mapAccount1[item.time.substring(2,7)] += item.money;
      } else {
        mapAccount1[item.time.substring(2,7)] = item.money;
      }
    }
  
    for (var item in mapAccount1.keys) {
      isIncomeTimeMoneyList1.add(TimeMoney(item, mapAccount1[item]));
    }
    isIncomeTimeMoneyList1.sort((a, b) => a.time.compareTo(b.time));
    //2 支出
    for (var item in notIncomeList) {
      if (mapAccount2 != null && mapAccount2[item.time.substring(2,7)] != null) {
        mapAccount2[item.time.substring(2,7)] += item.money;
      } else {
        mapAccount2[item.time.substring(2,7)] = item.money;
      }
    }
  
    for (var item in mapAccount2.keys) {
      isIncomeTimeMoneyList2.add(TimeMoney(item, mapAccount2[item]));
    }
    // isIncomeTimeMoneyList2.sort((a, b) => a.time.compareTo(b.time));

    return [
      new charts.Series<TimeMoney, String>(
        id: 'isIncome',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (TimeMoney timeMoney, _) => timeMoney.time,
        measureFn: (TimeMoney timeMoney, _) => timeMoney.money,
        data: isIncomeTimeMoneyList1,
      ),
      // ..setAttribute(charts.rendererIdKey, 'customSymbolAnnotation'),
        // Configure our custom bar target renderer for this series.
      //   ..setAttribute(charts.rendererIdKey, 'customArea'),
      new charts.Series<TimeMoney, String>(
        id: 'notIncome',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (TimeMoney timeMoney, _) => timeMoney.time,
        measureFn: (TimeMoney timeMoney, _) => timeMoney.money,
        data: isIncomeTimeMoneyList2,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_accountsList==null) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    }else if (_accountsList.isEmpty) {
      body = Notdatafound();
    } else {
      body = TabBarView(controller: _tabController, children: <Widget>[
        Card(child: DatumLegendWithMeasures(pieData(),animate: true,)),
        Card(
            child: StackedFillColorBarChart(
          barData(),
          animate: true,
        )),
        Card(child: CustomAxisTickFormatters(lineData(),animate: true),)
      ]);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("账单"),
          // backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _goToAddPage();
              },
            ),
            IconButton(
              icon: Icon(Icons.view_module),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AccountsCards();
                }));
              },
            )
          ],
          bottom: TabBar(
              controller: _tabController,
              // isScrollable: true,
              tabs: _tabs.map((v) => Tab(text: v)).toList()),
        ),
        drawer: MainDrawer(),
        body: body);
  }
}

class TimeMoney {
  final String time;
  final int money;

  TimeMoney(this.time, this.money);
}

class CostTypeMoney {
  final String type;
  final int money;

  CostTypeMoney(this.type, this.money);
}

class TimeSeriesMoney {
  final DateTime time;
  final int money;
  TimeSeriesMoney(this.time, this.money);
}