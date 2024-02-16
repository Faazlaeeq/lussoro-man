//child: Column(

                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(
                  //           height: MediaQuery.of(context).size.width,
                  //           width: MediaQuery.of(context).size.width,
                  //           // color: Colors.green,
                  //           child: ClipRRect(
                  //             child: Image.network(
                  //               itemdata!.data!.itemImages![0].imageUrl
                  //                   .toString(),
                  //               fit: BoxFit.contain,
                  //             ),
                  //           )),
                  //      //item name
                  //       Row(
                  //         children: [
                  //           Padding(
                  //               padding:
                  //                   EdgeInsets.only(left: 4.w, top: 7.3.h)),
                  //           Expanded(
                  //             child: Text(
                  //               itemdata!.data!.itemName.toString(),
                  //               overflow: TextOverflow.clip,
                  //               style: TextStyle(
                  //                 fontSize: 16.sp,
                  //                 fontFamily: 'Poppins_semibold',
                  //               ),
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       //catogeryname and preparation
                  //       Padding(
                  //         padding: EdgeInsets.only(left: 4.w, right: 4.w),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               itemdata!.data!.categoryInfo!.categoryName,
                  //               style: TextStyle(
                  //                 fontSize: 10.sp,
                  //                 fontFamily: 'Poppins',
                  //                 color: color.green,
                  //               ),
                  //             ),
                  //             Text(
                  //               itemdata!.data!.preparationTime,
                  //               style: TextStyle(
                  //                 fontSize: 10.sp,
                  //                 fontFamily: 'Poppins',
                  //                 color: Colors.grey,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //      //variation
                  //       Row(children: [
                  //         Padding(
                  //             padding: EdgeInsets.only(
                  //           left: 4.w,
                  //         )),
                  //         if (itemdata!.data!.hasVariation == "1") ...[
                  //           Text(
                  //             currency_position == "1"
                  //                 ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![0].productPrice.toString()))}"
                  //                 : "${numberFormat.format(double.parse(itemdata!.data!.variation![0].productPrice.toString()))}$currency",
                  //             style: TextStyle(
                  //               fontSize: 21.sp,
                  //               fontFamily: 'Poppins_bold',
                  //             ),
                  //           ),
                  //         ] else ...[
                  //           Text(
                  //             currency_position == "1"
                  //                 ? "$currency${numberFormat.format(double.parse(itemdata!.data!.price.toString()))}"
                  //                 : "${numberFormat.format(double.parse(itemdata!.data!.price.toString()))}$currency",
                  //             style: TextStyle(
                  //               fontSize: 21.sp,
                  //               fontFamily: 'Poppins_bold',
                  //             ),
                  //           ),
                  //         ],
                  //       ]),
                  //      //outof stock
                  //       Padding(
                  //         padding: EdgeInsets.only(
                  //           left: 4.w,
                  //           right: 4.w,
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.end,
                  //           children: [
                  //             if (itemdata!.data!.availableQty == "" ||
                  //                 int.parse(itemdata!.data!.availableQty
                  //                         .toString()) <=
                  //                     0) ...[
                  //               Text(
                  //                 'Out_of_Stock'.tr,
                  //                 style: TextStyle(
                  //                   fontFamily: 'Poppins',
                  //                   fontSize: 8.sp,
                  //                   color: color.grey,
                  //                 ),
                  //               ),
                  //             ] else if (itemdata!.data!.tax == "" ||
                  //                 itemdata!.data!.tax == "0") ...[
                  //               Text(
                  //                 'Inclusive_of_all_taxes'.tr,
                  //                 style: TextStyle(
                  //                   fontFamily: 'Poppins',
                  //                   fontSize: 8.sp,
                  //                   color: color.green,
                  //                 ),
                  //               ),
                  //             ] else ...[
                  //               Text(
                  //                 "${itemdata!.data!.tax}% ${'additional_tax'.tr}",
                  //                 style: TextStyle(
                  //                   fontFamily: 'Poppins',
                  //                   fontSize: 8.sp,
                  //                   color: color.red,
                  //                 ),
                  //               ),
                  //             ]
                  //           ],
                  //         ),
                  //       ),
                  //      //Description heading
                  //       Container(
                  //         margin: EdgeInsets.only(
                  //           left: 4.w,
                  //           right: 4.w,
                  //           top: 1.h,
                  //         ),
                  //         child: Text(
                  //           'Description',
                  //           style: TextStyle(
                  //               fontSize: 15.sp,
                  //               fontFamily: 'Poppins_semibold'),
                  //         ),
                  //       ),
                  //       if (itemdata!.data!.itemDescription == "" ||
                  //           itemdata!.data!.itemDescription == null) ...[
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //               left: 4.w, top: 1.h, right: 4.w),
                  //           alignment: Alignment.topLeft,
                  //           child: Text(
                  //             " - ",
                  //             style: TextStyle(
                  //                 fontSize: 10.5.sp, fontFamily: 'Poppins'),
                  //           ),
                  //         ),
                  //       ] else ...[
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //               left: 4.w, top: 1.h, right: 4.w),
                  //           alignment: Alignment.topLeft,
                  //           child: Text(
                  //             itemdata!.data!.itemDescription,
                  //             style: TextStyle(
                  //                 fontSize: 10.5.sp, fontFamily: 'Poppins'),
                  //           ),
                  //         ),
                  //       ],
                  //       // variantion of sizes
                  //       if (itemdata!.data!.hasVariation == "1") ...[
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //               left: 4.w, top: 2.h, bottom: 1.h, right: 4.w),
                  //           child: Text(
                  //             itemdata!.data!.attribute!,
                  //             style: TextStyle(
                  //                 fontFamily: 'Poppins_bold', fontSize: 15.sp),
                  //           ),
                  //         ),
                  //         Container(
                  //           padding: EdgeInsets.all(0),
                  //           height: itemdata!.data!.variation!.length * 6.5.h,
                  //           child: ListView.builder(
                  //             physics: NeverScrollableScrollPhysics(),
                  //             itemCount: itemdata!.data!.variation!.length,
                  //             itemBuilder: (context, index) {
                  //               return Padding(
                  //                 padding: EdgeInsets.only(
                  //                     left: 5.w, bottom: 1.h, right: 5.w),
                  //                 child: InkWell(
                  //                   onTap: () {
                  //                     select._variationselecationindex(index);
                  //                   },
                  //                   child: Row(
                  //                     children: [
                  //                       Obx(
                  //                         () => Container(
                  //                           height: 3.3.h,
                  //                           width: 3.3.h,
                  //                           decoration: BoxDecoration(
                  //                               color:
                  //                                   select._variationselecationindex ==
                  //                                           index
                  //                                       ? color.green
                  //                                       : Colors.transparent,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(50),
                  //                               border: Border.all(
                  //                                   color: color.green)),
                  //                           child: Icon(Icons.done,
                  //                               color:
                  //                                   select._variationselecationindex ==
                  //                                           index
                  //                                       ? Colors.white
                  //                                       : Colors.transparent,
                  //                               size: 13.sp),
                  //                         ),
                  //                       ),
                  //                       SizedBox(
                  //                         width: 4.w,
                  //                       ),
                  //                       Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           if (itemdata!
                  //                                       .data!
                  //                                       .variation![index]
                  //                                       .availableQty ==
                  //                                   "" ||
                  //                               int.parse(itemdata!
                  //                                       .data!
                  //                                       .variation![index]
                  //                                       .availableQty
                  //                                       .toString()) <=
                  //                                   0) ...[
                  //                             Text(
                  //                               itemdata!
                  //                                   .data!
                  //                                   .variation![index]
                  //                                   .variation!,
                  //                               style: TextStyle(
                  //                                 fontSize: 11.sp,
                  //                                 fontFamily:
                  //                                     'Poppins_semibold',
                  //                                 color: color.grey,
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               currency_position == "1"
                  //                                   ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))} ${'Out_of_Stock'.tr}"
                  //                                   : "${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}$currency ${'Out_of_Stock'.tr}",
                  //                               style: TextStyle(
                  //                                 fontSize: 8.sp,
                  //                                 fontFamily: 'Poppins',
                  //                                 color: color.grey,
                  //                               ),
                  //                             )
                  //                           ] else ...[
                  //                             Text(
                  //                               itemdata!
                  //                                   .data!
                  //                                   .variation![index]
                  //                                   .variation!,
                  //                               style: TextStyle(
                  //                                 fontSize: 11.sp,
                  //                                 fontFamily:
                  //                                     'Poppins_semibold',
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               currency_position == "1"
                  //                                   ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}"
                  //                                   : "${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}$currency",
                  //                               style: TextStyle(
                  //                                   fontSize: 8.sp,
                  //                                   fontFamily: 'Poppins'),
                  //                             )
                  //                           ]
                  //                         ],
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     //add ons
                  //       if (itemdata!.data!.addons!.isNotEmpty) ...[
                  //         Container(
                  //           alignment: Alignment.topLeft,
                  //           margin: EdgeInsets.only(
                  //               left: 4.w, bottom: 1.h, right: 4.w),
                  //           child: Text(
                  //             'Add_ons'.tr,
                  //             style: TextStyle(
                  //                 fontFamily: 'Poppins_bold', fontSize: 15.sp),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           height: itemdata!.data!.addons!.length * 6.5.h,
                  //           child: ListView.builder(
                  //             physics: NeverScrollableScrollPhysics(),
                  //             itemCount: itemdata!.data!.addons!.length,
                  //             itemBuilder: (context, index) {
                  //               return Padding(
                  //                 padding: EdgeInsets.only(
                  //                     left: 5.w, bottom: 1.h, right: 5.w),
                  //                 child: InkWell(
                  //                   onTap: () {
                  //                     setState(() {
                  //                       var addonobject =
                  //                           itemdata!.data!.addons![index];

                  //                       addonobject.isselected == true
                  //                           ? addonobject.isselected = false
                  //                           : addonobject.isselected = true;

                  //                       itemdata!.data!.addons!.removeAt(index);

                  //                       itemdata!.data!.addons!
                  //                           .insert(index, addonobject);
                  //                     });
                  //                   },
                  //                   child: Row(
                  //                     children: [
                  //                       Container(
                  //                         height: 3.3.h,
                  //                         width: 3.3.h,
                  //                         decoration: BoxDecoration(
                  //                             color: itemdata!
                  //                                         .data!
                  //                                         .addons![index]
                  //                                         .isselected ==
                  //                                     false
                  //                                 ? Colors.transparent
                  //                                 : color.green,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(7),
                  //                             border: Border.all(
                  //                                 color: color.green)),
                  //                         child: Icon(Icons.done,
                  //                             color: itemdata!
                  //                                         .data!
                  //                                         .addons![index]
                  //                                         .isselected ==
                  //                                     false
                  //                                 ? Colors.transparent
                  //                                 : Colors.white,
                  //                             size: 13.sp),
                  //                       ),
                  //                       SizedBox(
                  //                         width: 4.w,
                  //                       ),
                  //                       Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             itemdata!
                  //                                 .data!.addons![index].name!,
                  //                             style: TextStyle(
                  //                               fontSize: 11.sp,
                  //                               fontFamily: 'Poppins_semibold',
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             currency_position == "1"
                  //                                 ? "$currency${numberFormat.format(double.parse(itemdata!.data!.addons![index].price.toString()))}"
                  //                                 : "${numberFormat.format(double.parse(itemdata!.data!.addons![index].price.toString()))}$currency",
                  //                             style: TextStyle(
                  //                                 fontSize: 8.sp,
                  //                                 fontFamily: 'Poppins'),
                  //                           )
                  //                         ],
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //      //related product
                  //       if (itemdata!.relateditems!.isNotEmpty) ...[
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //             left: 4.w,
                  //             right: 4.w,
                  //             bottom: 1.h,
                  //             top: 1.h,
                  //           ),
                  //           child: Text(
                  //             'Related_roducts'.tr,
                  //             style: TextStyle(
                  //                 fontFamily: 'Poppins_semibold',
                  //                 fontSize: 14.5.sp),
                  //           ),
                  //         ),
                  //         Container(
                  //           padding: EdgeInsets.only(left: 2.w, right: 2.w),
                  //           height: 33.h,
                  //           child: ListView.builder(
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount: itemdata!.relateditems!.length,
                  //             itemBuilder: (context, index) => InkWell(
                  //               onTap: () {
                  //                 Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => Product(
                  //                           itemdata!.relateditems![index].id)),
                  //                 );
                  //               },
                  //               child: Container(
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(7),
                  //                       border: Border.all(
                  //                           width: 0.8.sp, color: Colors.grey)),
                  //                   margin: EdgeInsets.only(
                  //                     top: 1.h,
                  //                     left: 1.7.w,
                  //                     right: 1.7.w,
                  //                   ),
                  //                   height: 32,
                  //                   width: 45.w,
                  //                   child: Column(children: [
                  //                     Stack(
                  //                       children: [
                  //                         Container(
                  //                           height: 20.h,
                  //                           width: 46.w,
                  //                           decoration: BoxDecoration(
                  //                               borderRadius: BorderRadius.only(
                  //                                   topLeft: Radius.circular(5),
                  //                                   topRight:
                  //                                       Radius.circular(5))),
                  //                           child: ClipRRect(
                  //                             borderRadius: BorderRadius.only(
                  //                                 topLeft: Radius.circular(5),
                  //                                 topRight: Radius.circular(5)),
                  //                             child: Image.network(
                  //                               itemdata!.relateditems![index]
                  //                                   .imageUrl,
                  //                               fit: BoxFit.contain,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         if (itemdata!.relateditems![index]
                  //                                 .hasVariation ==
                  //                             "0") ...[
                  //                           if (itemdata!.relateditems![index]
                  //                                       .availableQty ==
                  //                                   "" ||
                  //                               int.parse(itemdata!
                  //                                       .relateditems![index]
                  //                                       .availableQty
                  //                                       .toString()) <=
                  //                                   0) ...[
                  //                             Positioned(
                  //                               child: Container(
                  //                                 alignment: Alignment.center,
                  //                                 height: 20.h,
                  //                                 width: 46.w,
                  //                                 color: Colors.black38,
                  //                                 child: Text(
                  //                                   'Out_of_Stock'
                  //                                       .tr,
                  //                                   style: TextStyle(
                  //                                     fontSize: 15.sp,
                  //                                     color: Colors.white,
                  //                                     fontFamily:
                  //                                         'poppins_semibold',
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ]
                  //                         ],
                  //                         Positioned(
                  //                             right: 5.0,
                  //                             top: 5.0,
                  //                             child: InkWell(
                  //                               onTap: () {
                  //                                 if (userid == "") {
                  //                                   Navigator.of(context)
                  //                                       .pushAndRemoveUntil(
                  //                                           MaterialPageRoute(
                  //                                               builder: (c) =>
                  //                                                   Login()),
                  //                                           (r) => false);
                  //                                 } else if (itemdata!
                  //                                         .relateditems![index]
                  //                                         .isFavorite ==
                  //                                     "0") {
                  //                                   removefavarite(
                  //                                       "favorite",
                  //                                       itemdata!
                  //                                           .relateditems![
                  //                                               index]
                  //                                           .id
                  //                                           .toString());
                  //                                 } else {
                  //                                   removefavarite(
                  //                                       "unfavorite",
                  //                                       itemdata!
                  //                                           .relateditems![
                  //                                               index]
                  //                                           .id
                  //                                           .toString());
                  //                                 }
                  //                               },
                  //                               child: Container(
                  //                                   height: 6.h,
                  //                                   width: 12.w,
                  //                                   padding:
                  //                                       EdgeInsets.all(9.sp),
                  //                                   decoration: BoxDecoration(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             12),
                  //                                     color: Colors.black26,
                  //                                   ),
                  //                                   child: itemdata!
                  //                                               .relateditems![
                  //                                                   index]
                  //                                               .isFavorite ==
                  //                                           "0"
                  //                                       ? SvgPicture.asset(
                  //                                           'Assets/Icons/Favorite.svg',
                  //                                           color: Colors.white,
                  //                                         )
                  //                                       : SvgPicture.asset(
                  //                                           'Assets/Icons/Favoritedark.svg',
                  //                                           color: Colors.white,
                  //                                         )),
                  //                             )),
                  //                       ],
                  //                     ),
                  //                     Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Padding(
                  //                           padding: EdgeInsets.only(
                  //                               left: 2.w,
                  //                               right: 2.w,
                  //                               top: 1.h),
                  //                           child: Row(
                  //                             children: [
                  //                               Text(
                  //                                 itemdata!
                  //                                     .relateditems![index]
                  //                                     .categoryInfo!
                  //                                     .categoryName,
                  //                                 style: TextStyle(
                  //                                     fontSize: 8.5.sp,
                  //                                     fontFamily: 'Poppins',
                  //                                     color: color.green,
                  //                                     fontWeight:
                  //                                         FontWeight.w600),
                  //                               ),
                  //                               Spacer(),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.only(
                  //                             left: 2.w,
                  //                             right: 2.w,
                  //                           ),
                  //                           child: Row(
                  //                             children: [
                  //                               Expanded(
                  //                                 child: Text(
                  //                                   itemdata!
                  //                                       .relateditems![index]
                  //                                       .itemName,
                  //                                   overflow:
                  //                                       TextOverflow.ellipsis,
                  //                                   style: TextStyle(
                  //                                       fontSize: 14,
                  //                                       fontFamily: 'Poppins',
                  //                                       fontWeight:
                  //                                           FontWeight.w600),
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.only(
                  //                               left: 2.w,
                  //                               right: 2.w,
                  //                               top: 1.3.h),
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                             children: [
                  //                               if (itemdata!.relateditems![index]
                  //                                   .hasVariation ==
                  //                                   "1") ...[
                  //                                 Text(
                  //                                   currency_position == "1"
                  //                                       ? "$currency${numberFormat.format(double.parse(itemdata!.relateditems![index].variation![0].productPrice.toString()))}"
                  //                                       : "${numberFormat.format(double.parse(itemdata!.relateditems![index].variation![0].productPrice.toString()))}$currency",
                  //                                   style: TextStyle(
                  //                                       fontSize: 13,
                  //                                       fontFamily: 'Poppins_bold',
                  //                                       fontWeight:
                  //                                       FontWeight.w600),
                  //                                 ),
                  //                               ] else ...[
                  //                                 Text(
                  //                                   currency_position == "1"
                  //                                       ? "$currency${numberFormat.format(double.parse(itemdata!.relateditems![index].price.toString()))}"
                  //                                       : "${numberFormat.format(double.parse(itemdata!.relateditems![index].price.toString()))}$currency",
                  //                                   style: TextStyle(
                  //                                       fontSize: 13,
                  //                                       fontFamily: 'Poppins_bold',
                  //                                       fontWeight:
                  //                                       FontWeight.w600),
                  //                                 ),
                  //                               ],
                  //                               if (itemdata!.relateditems![index]
                  //                                   .isCart ==
                  //                                   "0") ...[
                  //                                 InkWell(
                  //                                   onTap: () async {
                  //                                     if (itemdata!
                  //                                         .relateditems![
                  //                                     index]
                  //                                         .hasVariation ==
                  //                                         "1" ||
                  //                                         itemdata!
                  //                                             .relateditems![index]
                  //                                             .addons!
                  //                                             .isNotEmpty) {
                  //                                       cart = await Get.to(() =>
                  //                                           showvariation(itemdata!
                  //                                               .relateditems![
                  //                                           index]));
                  //                                       if (cart == 1) {
                  //                                         setState(() {
                  //                                           itemdata!
                  //                                               .relateditems![
                  //                                           index]
                  //                                               .isCart = "1";
                  //                                           itemdata!
                  //                                               .relateditems![
                  //                                           index]
                  //                                               .itemQty =
                  //                                               int.parse(
                  //                                                 itemdata!
                  //                                                     .relateditems![
                  //                                                 index]
                  //                                                     .itemQty!
                  //                                                     .toString(),
                  //                                               ) +
                  //                                                   1;
                  //                                         });
                  //                                       }
                  //                                     } else {
                  //                                       // if (userid == "") {
                  //                                       //   Navigator.of(context)
                  //                                       //       .pushAndRemoveUntil(
                  //                                       //       MaterialPageRoute(
                  //                                       //           builder: (c) =>
                  //                                       //               Login()),
                  //                                       //           (r) => false);
                  //                                       // } else {
                  //                                         addtocart(
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .id,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .itemName,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .imageName,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .itemType,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .tax,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .price);
                  //                                       }
                  //                                     // }
                  //                                   },
                  //                                   child: Container(
                  //                                       decoration: BoxDecoration(
                  //                                           borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(4),
                  //                                           border: Border.all(
                  //                                               color:
                  //                                               Colors.grey)),
                  //                                       height: 3.5.h,
                  //                                       width: 17.w,
                  //                                       child: Center(
                  //                                         child: Text(
                  //                                           'ADD'.tr,
                  //                                           style: TextStyle(
                  //                                               fontFamily:
                  //                                               'Poppins',
                  //                                               fontSize: 9.5.sp,
                  //                                               color: color.green),
                  //                                         ),
                  //                                       )),
                  //                                 ),
                  //                               ] else if (itemdata!
                  //                                   .relateditems![index]
                  //                                   .isCart ==
                  //                                   "1") ...[
                  //                                 Container(
                  //                                   height: 3.6.h,
                  //                                   width: 22.w,
                  //                                   decoration: BoxDecoration(
                  //                                     border: Border.all(
                  //                                         color: Colors.grey),
                  //                                     borderRadius:
                  //                                     BorderRadius.circular(5),
                  //                                   ),
                  //                                   child: Row(
                  //                                     mainAxisAlignment:
                  //                                     MainAxisAlignment
                  //                                         .spaceAround,
                  //                                     children: [
                  //                                       InkWell(
                  //                                           onTap: () {
                  //                                             loader.showErroDialog(
                  //                                               description: LocaleKeys
                  //                                                   .The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item
                  //                                                   .tr,
                  //                                             );
                  //                                           },
                  //                                           child: Icon(
                  //                                             Icons.remove,
                  //                                             color: color.green,
                  //                                             size: 16,
                  //                                           )),
                  //                                       Container(
                  //                                         decoration: BoxDecoration(
                  //                                           borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(3),
                  //                                         ),
                  //                                         child: Text(
                  //                                           itemdata!
                  //                                               .relateditems![
                  //                                           index]
                  //                                               .itemQty!
                  //                                               .toString(),
                  //                                           style: TextStyle(
                  //                                               fontSize: 10.sp),
                  //                                         ),
                  //                                       ),
                  //                                       InkWell(
                  //                                           onTap: () async {
                  //                                             if (itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .hasVariation ==
                  //                                                 "1" ||
                  //                                                 itemdata!
                  //                                                     .relateditems![
                  //                                                 index]
                  //                                                     .addons!
                  //                                                     .length >
                  //                                                     0) {
                  //                                               cart = await Get.to(
                  //                                                       () => showvariation(
                  //                                                       itemdata!
                  //                                                           .relateditems![
                  //                                                       index]));
                  //                                               if (cart == 1) {
                  //                                                 setState(() {
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .itemQty = int
                  //                                                       .parse(
                  //                                                     itemdata!
                  //                                                         .relateditems![
                  //                                                     index]
                  //                                                         .itemQty!
                  //                                                         .toString(),
                  //                                                   ) +
                  //                                                       1;
                  //                                                 });
                  //                                               }
                  //                                             } else {
                  //                                               addtocart(
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .id,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .itemName,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .imageName,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .itemType,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .tax,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .price);
                  //                                             }
                  //                                           },
                  //                                           child: Icon(
                  //                                             Icons.add,
                  //                                             color: color.green,
                  //                                             size: 16,
                  //                                           )),
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 0.2.h,
                  //                         )
                  //                       ],
                  //                     )
                  //                   ])),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //       SizedBox(
                  //         height: 9.h,
                  //       )
                  //     ],
                  //   ),
                  // ),