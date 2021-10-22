
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:success_stations/styling/colors.dart';

Widget shimmerB() {
    bool _enabled = true;
    return  Expanded(
       child:  Shimmer.fromColors(
        baseColor: AppColors.shimmer,
        highlightColor: AppColors.greySkalton,
        enabled: _enabled,
      child: ListView.builder(
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 18.0,
                      color: AppColors.shimmer,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: double.infinity,
                      height: 18.0,
                      color: AppColors.shimmer,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40.0,
                      height: 18.0,
                      color: AppColors.shimmer,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        itemCount: 10,
      ),
       )
    );  
  }

  Widget viewCardLoading(context) {
    bool _enabled = true;
    return  Expanded(
      child:  Shimmer.fromColors(
        baseColor: AppColors.shimmer,
        highlightColor: AppColors.greySkalton,
        enabled: _enabled,
        child:Card(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height/2,
          color: AppColors.shimmer,
        ),
      ),
    )
  );
}