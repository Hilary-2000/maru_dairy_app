import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maru/pages/admin/admin_profile.dart';
import 'package:maru/pages/admin/admin_qr_code_finder.dart';
import 'package:maru/pages/admin/dashboard.dart';
import 'package:maru/pages/admin/edit_milk_price.dart';
import 'package:maru/pages/admin/edit_profile.dart';
import 'package:maru/pages/admin/generate_reports.dart';
import 'package:maru/pages/admin/inquiry_inbox.dart';
import 'package:maru/pages/admin/member_details.dart';
import 'package:maru/pages/admin/member_details_edit.dart';
import 'package:maru/pages/admin/member_history.dart';
import 'package:maru/pages/admin/membership.dart';
import 'package:maru/pages/admin/milk_prices.dart';
import 'package:maru/pages/admin/new_member.dart';
import 'package:maru/pages/admin/select_member_message.dart';
import 'package:maru/pages/admin/update_milk_prices.dart';
import 'package:maru/pages/member/changeMemberPassword.dart';
import 'package:maru/pages/member/confirmed_declined_collection.dart';
import 'package:maru/pages/member/edit_profile.dart';
import 'package:maru/pages/member/inbox.dart';
import 'package:maru/pages/member/member_milk_details.dart';
import 'package:maru/pages/member/member_reports.dart';
import 'package:maru/pages/member/membership.dart';
import 'package:maru/pages/member/view_profile.dart';
import 'package:maru/pages/super_admin/Technicians.dart';
import 'package:maru/pages/super_admin/administrator_details.dart';
import 'package:maru/pages/super_admin/administrator_list.dart';
import 'package:maru/pages/super_admin/edit_administrator.dart';
import 'package:maru/pages/super_admin/edit_super_admin_details.dart';
import 'package:maru/pages/super_admin/edit_technician.dart';
import 'package:maru/pages/super_admin/new_administrator.dart';
import 'package:maru/pages/super_admin/new_super_administrator.dart';
import 'package:maru/pages/super_admin/new_technician.dart';
import 'package:maru/pages/super_admin/super_admin_details.dart';
import 'package:maru/pages/super_admin/super_admin_list.dart';
import 'package:maru/pages/technician/edit_member_milk_data.dart';
import 'package:maru/pages/technician/technician_profile.dart';
import 'package:maru/pages/technician/technician_qr_scanner.dart';
import 'package:maru/pages/technician/capture_milk_data.dart';
import 'package:maru/pages/technician/collect_milk.dart';
import 'package:maru/pages/technician/dashboard.dart';
import 'package:maru/pages/technician/edit_technician_profile.dart';
import 'package:maru/pages/forgot_password.dart';
import 'package:maru/pages/maru_landing_page.dart';
import 'package:maru/pages/login_page.dart';
import 'package:maru/pages/login_or_signup.dart';
import 'package:maru/pages/member/dashboard.dart';
import 'package:maru/pages/member/history.dart';
import 'package:maru/pages/member/read_notification.dart';
import 'package:maru/pages/member/member_qrcode.dart';
import 'package:maru/pages/super_admin/dashboard.dart';
import 'package:maru/pages/super_admin/technician_details.dart';
import 'package:maru/pages/signup.dart';
import 'package:maru/pages/technician/technician_report.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const Maru(),
      "/login": (context) => const Login(),
      "/landing_page": (context) => const LoginOrSignup(),
      "/sign_up": (context) => const signUp(),
      "/forgot_password": (context) => const forgotPassword(),
      "/member_dashboard": (context) => const memberDashboard(),
      "/admin_dashboard": (context) => const adminDashboard(),
      "/technician_dashboard": (context) => const technicianDashboard(),
      "/super_admin_dashboard": (context) => const superAdminDashboard(),
      "/member_history": (context) => const memberHistory(),
      "/member_view_profile": (context) => const MemberProfile(),
      "/member_edit_profile": (context) => const EditProfile(),
      "/change_member_password": (context) => const ChangeMemberPassword(),
      "/member_membership": (context) => const MemberMembership(),
      "/member_inbox": (context) => const MemberInbox(),
      "/member_milk_details": (context) => const MemberMilkDetails(),
      "/member_qr_code": (context) => const MemberQrcode(),
      "/read_member_notification": (context) => const ReadMemberNotification(),
      "/technician_collect_milk": (context) => const CollectMilk(),
      "/technician_capture_milk_data": (context) => const CaptureMilkData(),
      "/edit_member_milk_data": (context) => const EditMemberMilkData(),
      "/technician_profile": (context) => const TechnicianProfile(),
      "/find_member_scanner": (context) => const TechnicianQrScanner(),
      "/edit_technician_profile": (context) => const EditTechnicianProfile(),
      "/admin_qr_code_finder": (context) => const AdminQrCodeFinder(),
      "/admin_inquiry_inbox": (context) => const InquiryInbox(),
      "/change_milk_price": (context) => const EditMilkPrice(),
      "/select_member_to_send_message": (context) => const SelectMemberMessage(),
      "/admin_member_details": (context) => const MemberDetails(),
      "/admin_edit_member_details": (context) => const MemberDetailsEdit(),
      "/decline_or_confirmed_collection": (context) => const ConfirmedDeclinedCollection(),
      "/admin_member_history": (context) => const MemberHistory(),
      "/new_member": (context) => const NewMember(),
      "/admin_profile": (context) => const AdminProfile(),
      "/admin_edit_profile": (context) => const AdminEditProfile(),
      "/milk_prices": (context) => const MilkPrices(),
      "/update_milk_prices": (context) => const UpdateMilkPrices(),
      "/admin_member_membership": (context) => const Membership(),
      "/manage_technicians": (context) => const Technicians(),
      "/technician_details": (context) => const TechnicianDetails(),
      "/edit_technician": (context) => const EditTechnician(),
      "/new_technician": (context)=> const NewTechnician(),
      "/administrators": (context) => const AdministratorList(),
      "/admin_details" : (context) => const AdministratorDetails(),
      "/edit_administrator" : (context) => const EditAdministrator(),
      "/new_administrator" : (context) => const NewAdministrator(),
      "/super_admin_list" : (context) => const SuperAdminList(),
      "/super_admin_details": (context) => const SuperAdminDetails(),
      "/edit_super_admin_details" : (context) => const EditSuperAdminDetails(),
      "/new_super_admin" : (context) => const NewSuperAdministrator(),
      "/generate_admin_report": (context) => const GenerateReports(),
      "/member_reports" : (context) => const MemberReports(),
      "/technician_reports" : (context) => const TechnicianReport()
    },
  ));
}
