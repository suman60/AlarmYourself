import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';


import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_skip_app_bar.dart';
import '../../../theme/text_style_helper.dart';
import '../../../theme/theme_helper.dart';
import '../../../networks/app_routes.dart';

class OnboardingTwoScreen extends StatefulWidget {
  const OnboardingTwoScreen({Key? key}) : super(key: key);

  @override
  _OnboardingTwoScreenState createState() => _OnboardingTwoScreenState();
}

class _OnboardingTwoScreenState extends State<OnboardingTwoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/osain.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.black_900,
      body: Column(
        children: [
          /// Top video + skip button
          SizedBox(
            width: double.infinity,
            height: 429.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gradient + video
                Container(
                  width: double.infinity,
                  height: 429.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF082257),
                        Color(0xFF0B0024),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: _controller.value.isInitialized
                        ? SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _controller.value.size.width,
                                height: _controller.value.size.height,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),

                /// Skip button
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: CustomSkipAppBar(
                      skipText: 'Skip',
                      skipTextColor: appTheme.white_A700,
                      backgroundColor: appTheme.transparentCustom,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Oxygen',
                      onSkipPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.appNavigationScreen,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// Title + subtitle
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore new horizons, one step at a time.',
                          style: TextStyleHelper.instance.headline28MediumPoppins.copyWith(
                            height: 1.21,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Every trip holds a stroy waiting to be lived. Let us guide you to experiences that inspire, connect, and last a lifetime.',
                          style: TextStyleHelper.instance.body14RegularOxygen.copyWith(
                            height: 1.43,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Dots indicator
                  Container(
                    margin: EdgeInsets.only(top: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDot(appTheme.deep_purple_A700),
                        SizedBox(width: 8.w),
                        _buildDot(appTheme.color4DFFFF),
                        SizedBox(width: 8.w),
                        _buildDot(appTheme.color4DFFFF),
                      ],
                    ),
                  ),

                  /// Next button
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 34.h, bottom: 34.h),
                      child: CustomButton(
                        text: 'Next',
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.onboardingThreeScreen,
                          );
                        },
                        backgroundColor: appTheme.deep_purple_A700,
                        textColor: appTheme.white_A700,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        borderRadius: 69.r,
                        width: 328.w,
                        height: 56.h,
                        padding: EdgeInsets.fromLTRB(112.w, 18.h, 112.w, 18.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      height: 8.h,
      width: 8.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
