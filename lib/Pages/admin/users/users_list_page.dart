import 'package:e_commerce_grocery_application/Pages/admin/users/admin_add_user.dart';
import 'package:e_commerce_grocery_application/Pages/admin/users/edit_user_page.dart';
import 'package:e_commerce_grocery_application/Widgets/bottom_with_icon_title_widget.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  Map<String, dynamic> usersListData = {};
  bool isLoading = true;

  @override
  void initState() {
    _getUsersList(); //This function will call when screen apears.
    // TODO: implement initState
    super.initState();
  }

  void _getUsersList() async {
    usersListData = (await ProductService().fetchUsersList())!;

    print("=======resposne is $usersListData");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _appBarView(),
        Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: usersListData['users'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          // height: 100,
                          width: 40,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                            'Username: ${usersListData['users'][index]['name']}',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Address: ${usersListData['users'][index]['address']}',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Mobile:${usersListData['users'][index]['mobile']}',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Updated at:  ${formatDate(usersListData['users'][index]['created_at'])}',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                    top: 10,
                                    right: 40,
                                    child: InkWell(
                                      onTap: () async {
                                        bool? confirmDelete = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Update User"),
                                            content: Text(
                                                "Are you sure you want to inactive ${usersListData['users'][index]['name']}?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text("No"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmDelete == true) {
                                          setState(() {
                                            usersListData['users'][index]
                                                            ['isActive']
                                                        .toString() ==
                                                    'true'
                                                ? usersListData['users'][index]
                                                            ['isActive']
                                                        .toString() ==
                                                    'false'
                                                : usersListData['users'][index]
                                                            ['isActive']
                                                        .toString() ==
                                                    'true';
                                          });
                                          await ProductService().updateUserStatus(
                                              usersListData['users'][index]
                                                  ['id'],
                                              usersListData['users'][index]
                                                              ['isActive']
                                                          .toString() ==
                                                      'true'
                                                  ? "INACTIVE"
                                                  : "ACTIVE");

                                          _getUsersList();
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1, color: Colors.green)),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Text(
                                            usersListData['users'][index]
                                                            ['isActive']
                                                        .toString() ==
                                                    'true'
                                                ? "Active"
                                                : 'In Active',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    top: 10,
                                    right: 10,
                                    child: InkWell(
                                        onTap: () {
                                          _showBottomOptions(
                                              context,
                                              usersListData['users'][index]
                                                      ['id']
                                                  .toString(),
                                              usersListData['users'][index]);
                                        },
                                        child: Icon(Icons.more_horiz_rounded)))
                              ],
                            ),
                          ),
                        ),
                      );
                    }))
      ],
    ));
  }

  _appBarView() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.navigate_before, size: 35),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Navigate back to the previous screen
                      },
                    ),
                    Text(
                      'Users List',
                      style: GoogleFonts.notoSerif(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.4),
                      child: IconButton(
                        icon: Icon(Icons.add_circle_sharp, size: 36),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminAddUser(
                                      flag: false,
                                    )),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomOptions(BuildContext context, String userId, Map user) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              // buildBottomWithTitleIconWidget(
              //   context: context,
              //   icon: ImageUtils.active_user_icon,
              //   title: 'Active User',
              //   onTap: (){

              //   }
              // ),
              //  buildBottomWithTitleIconWidget(
              //   context: context,
              //   icon: ImageUtils.inactive_user_icon,
              //   title: 'In Active User',
              //   onTap: (){

              //   }
              // ),
              buildBottomWithTitleIconWidget(
                  context: context,
                  icon: ImageUtils.edit_user_icon,
                  title: 'Edit User',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditUserPage(
                        userData: user,
                      );
                    })).then((val) {
                      isLoading = true;
                      setState(() {});
                      _getUsersList();
                    });
                  }),
              buildBottomWithTitleIconWidget(
                context: context,
                icon: ImageUtils.delete_user_icon,
                title: 'Delete User',
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to delete this user?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close dialog on Cancel
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              usersListData = (await ProductService()
                                  .deleteUser(context, userId))!;
                              _getUsersList();
                              Navigator.of(context)
                                  .pop(); // Close dialog on Yes
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
