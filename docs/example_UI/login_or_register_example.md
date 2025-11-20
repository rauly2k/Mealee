class SignInCreateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 428,
          height: 926,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 428,
                  height: 926,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/428x926"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 465,
                child: Container(
                  width: 428,
                  height: 461,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.50, -0.19),
                      end: Alignment(0.50, 1.00),
                      colors: [Colors.white, const Color(0x45E8DFDF), Colors.white.withValues(alpha: 0)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 666,
                child: SizedBox(
                  width: 388,
                  child: Text(
                    'Personalized meal plans tailored to your taste & health goals.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF101211),
                      fontSize: 17,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.47,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 756,
                child: Container(
                  width: 388,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 12,
                          right: 12,
                          bottom: 11,
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFA7315),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 364,
                              child: Text(
                                'Create Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 12,
                          right: 12,
                          bottom: 11,
                        ),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.50,
                              color: const Color(0xFFFA7315),
                            ),
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 364,
                              child: Text(
                                'Log In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFFA7315),
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 892,
                child: Container(
                  width: 428,
                  height: 34,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 147,
                        top: 14,
                        child: Container(
                          width: 134,
                          height: 5,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF030401),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 428,
                  height: 47,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 320,
                        top: 16,
                        child: Container(
                          width: 88,
                          height: 15,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 1,
                                child: Container(
                                  width: 23.04,
                                  height: 13.85,
                                  child: Stack(),
                                ),
                              ),
                              Positioned(
                                left: 30.04,
                                top: 0,
                                child: Container(
                                  width: 19.62,
                                  height: 14.42,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: -0.14,
                                        top: 0.71,
                                        child: Container(
                                          width: 19.62,
                                          height: 14.42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 19.62,
                                                  height: 14.42,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(),
                                                  child: Stack(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 56.66,
                                top: 0,
                                child: Container(
                                  width: 31.53,
                                  height: 15,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 2.24,
                                        top: 1,
                                        child: Container(
                                          width: 27.40,
                                          height: 13,
                                          child: Stack(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 301,
                        top: 6,
                        child: Container(
                          width: 6,
                          height: 6,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: ShapeDecoration(shape: OvalBorder()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 13,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 2,
                          children: [
                            Text(
                              '9:41',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF030401),
                                fontSize: 18,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}