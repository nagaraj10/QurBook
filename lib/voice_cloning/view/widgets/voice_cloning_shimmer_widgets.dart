import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/fhb_constants.dart';
import '../../../constants/variable_constant.dart';
import '../../../src/utils/screenutils/size_extensions.dart';

Widget familyMemberListLoader(){
 return Container(
   padding: const EdgeInsets.all(8),
   margin: EdgeInsets.fromLTRB(8, 16, 8, 8),
   decoration: BoxDecoration(
     borderRadius: BorderRadius.circular(10),
     border: Border.all(
       color: Colors.grey.withOpacity(0.4),
     ),
   ),
   child:Column(
     children: [
       Text(strFetchingList,
         style: TextStyle(
             color: Colors.grey[600],
             fontSize:mobileFontTitle,
         ),),
       SizedBox(height:10,),
       Shimmer.fromColors(
         baseColor: Colors.grey[300]!,
         highlightColor: Colors.grey[100]!,
         enabled: true,
         child: ListView.separated(
           padding: EdgeInsets.symmetric(horizontal: 10.w),
           separatorBuilder: (context,index){
             return SizedBox(height: 10.h,);
           },
           physics: NeverScrollableScrollPhysics(),
           scrollDirection: Axis.vertical,
           shrinkWrap: true,
           itemBuilder: (context,index){
             return  Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 border: Border.all(
                   color: Colors.grey,
                 ),
               ),
               child: Row(
                 children: [
                   Container(
                     decoration:  BoxDecoration(
                       shape:  BoxShape.circle,
                       color:Colors.grey,
                     ),
                     height:40.0.h,
                     width:40.0.h,
                   ),
                   SizedBox(width: 10.w,),
                   Expanded(child:Column(
                     children: [
                       Container(
                         width: double.infinity,
                         height: 10.h,
                         color: Colors.grey,
                       ),
                       SizedBox(height: 2.0.h,),
                       Container(
                         width: double.infinity,
                         height: 10.h,
                         color: Colors.grey,
                       ),
                       SizedBox(height: 2.0.h,),
                       Container(
                         width: double.infinity,
                         height: 10.h,
                         color: Colors.grey,
                       ),
                       SizedBox(height: 2.0.h,),
                     ],
                   ))
                 ],
               ),
             );
           },
           itemCount: 2,

         ),
       ),
     ],
   )
 );
}