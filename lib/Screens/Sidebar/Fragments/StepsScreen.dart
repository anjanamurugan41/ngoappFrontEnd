import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app/Constants/StringConstants.dart';


class StepsScreen extends StatefulWidget {
  @override
  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen>  {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
      color: Colors.transparent,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Start a Fundraiser in three simple steps", style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13.0),),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.start,size: 30,),
                    SizedBox(width: MediaQuery.of(context).size.width * .04 ,),
                     Text("Start your fundraiser",style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 17),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: DottedDecoration(
                    color: Colors.grey,
                    strokeWidth: 2,
                    linePosition: LinePosition.left,
                      ),
                  child: const Text('It’ll take only 2 minutes. Just tell us a few details about you and the ones you are raising funds for.'),
                ),
                SizedBox(height:MediaQuery.of(context).size.height * .02  ,),
                Row(
                  children: [
                    Icon(Icons.start,size: 30,),
                    SizedBox(width: MediaQuery.of(context).size.width * .04 ,),
                     Text("Share your fundraiser",style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  margin:  EdgeInsets.only(left: 17),
                  padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: DottedDecoration(
                    color: Colors.grey,
                    strokeWidth: 2,
                    linePosition: LinePosition.left,
                  ),
                  child:  Column(
                    children: [
                      Text('All you need to do is share the fundraiser with your friends and family. In no time, support will start pouring in.'),
                      SizedBox(height:MediaQuery.of(context).size.height * .01 ,),
                      Padding(
                        padding:  EdgeInsets.only(right:80),
                        child: Text("Share your fundraiser directly from dashboard on social media.",
                            style: TextStyle(fontSize: 5,fontWeight: FontWeight.bold,color: Colors.grey),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:MediaQuery.of(context).size.height * .02 ,),
                Row(
                  children: [
                    Icon(Icons.start,size: 30,),
                    SizedBox(width: MediaQuery.of(context).size.width * .04 ,),
                    Text("Withdraw Funds",style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  margin:  EdgeInsets.only(left: 17),
                  padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: DottedDecoration(
                    color: Colors.grey,
                    strokeWidth: 2,
                    linePosition: LinePosition.left,
                  ),
                  child:  Column(
                    children: [
                      Text('The funds raised can be withdrawn without any hassle directly to your bank account.'),
                      SizedBox(height:MediaQuery.of(context).size.height * .01 ,),
                      Padding(
                        padding: const EdgeInsets.only(right: 120),
                        child: Text("It takes only 5 minutes to withdraw funds on NGO.",
                          style: TextStyle(fontSize: 5,fontWeight: FontWeight.bold,color: Colors.grey),),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

