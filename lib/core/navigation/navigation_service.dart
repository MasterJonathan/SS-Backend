import 'package:flutter/material.dart';



enum DashboardPage {
  
  overview,
  users,         
  products,      
  calendar,      
  charts,        
  forms,         
  profile,

  
  settings,
  userAdminManagement,

  bannerTop,
  kawanSS,

  beritaWeb,
  kontributorManagement,
  kontributorPost,

  chatManagement,
  
  socialnetworkanalysis,



  

  kawanSSManagement,
  contributor,
  kontributorComment,
  postinganTerlapor,
  reportManagement,

}

class NavigationService extends ChangeNotifier {

  DashboardPage _currentPage = DashboardPage.overview;

  
  DashboardPage get currentPage => _currentPage;


  void navigateTo(DashboardPage page) {
    if (_currentPage != page) { 
      _currentPage = page;
      notifyListeners();
    }
  }


}