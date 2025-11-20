class LoginPhoneNumberError extends StatelessWidget {
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
                              side: BorderSide(color: const Color(0xFF030401)),
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
              Positioned(
                left: 20,
                top: 67,
                child: Container(
                  width: 388,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      SizedBox(
                        width: 388,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: const Color(0xFF030401),
                            fontSize: 28,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 388,
                        child: Text(
                          'Log in to access your personalized meal plans.',
                          style: TextStyle(
                            color: const Color(0xFF030401),
                            fontSize: 17,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w400,
                            height: 1.41,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 173,
                child: Container(
                  width: 388,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 388,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF8F8F8),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: const Color(0xFFD6D6D6),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              top: 13,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  color: const Color(0xFF696969),
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.47,
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
                left: 20,
                top: 243,
                child: Container(
                  width: 388,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 388,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF8F8F8),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: const Color(0xFFD6D6D6),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              top: 13,
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  color: const Color(0xFF696969),
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.47,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 348,
                              top: 13,
                              child: Container(
                                width: 24,
                                height: 24,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 24,
                                        height: 24,
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
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 214,
                top: 305,
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: const Color(0xFF030401),
                    fontSize: 17,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.47,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 515,
                child: Container(
                  width: 388,
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
                          'Log In',
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
              ),
              Positioned(
                left: 88,
                top: 847,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'New here? ',
                        style: TextStyle(
                          color: const Color(0xFF030401),
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.47,
                        ),
                      ),
                      TextSpan(
                        text: 'Create an account!',
                        style: TextStyle(
                          color: const Color(0xFF030401),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                left: 20,
                top: 421,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Container(
                      width: 184,
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF8F8F8),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFD6D6D6),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 184,
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF8F8F8),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFD6D6D6),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                top: 370,
                child: Container(
                  width: 388,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Container(
                        width: 106,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: const Color(0xFFD6D6D6),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Or Continue With',
                        style: TextStyle(
                          color: const Color(0xFF030401),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.46,
                        ),
                      ),
                      Container(
                        width: 105,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: const Color(0xFFD6D6D6),
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
                top: 644,
                child: Container(
                  width: 428,
                  height: 282,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFFD1D3D9)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 3,
                        top: 8,
                        child: Container(
                          width: 422,
                          height: 150,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 422,
                                  height: 42,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 37,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 37,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 37,
                                                  child: Text(
                                                    'Q',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 43,
                                        top: 0,
                                        child: Container(
                                          width: 36,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 36,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 36,
                                                  child: Text(
                                                    'W',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 85,
                                        top: 0,
                                        child: Container(
                                          width: 38,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 38,
                                                  child: Text(
                                                    'E',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 129,
                                        top: 0,
                                        child: Container(
                                          width: 36,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 36,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 36,
                                                  child: Text(
                                                    'R',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 171,
                                        top: 0,
                                        child: Container(
                                          width: 37,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 37,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 37,
                                                  child: Text(
                                                    'T',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 214,
                                        top: 0,
                                        child: Container(
                                          width: 37,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 37,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 37,
                                                  child: Text(
                                                    'Y',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 257,
                                        top: 0,
                                        child: Container(
                                          width: 36,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 36,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 36,
                                                  child: Text(
                                                    'U',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 299,
                                        top: 0,
                                        child: Container(
                                          width: 38,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 38,
                                                  child: Text(
                                                    'I',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 343,
                                        top: 0,
                                        child: Container(
                                          width: 36,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 36,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 36,
                                                  child: Text(
                                                    'O',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 385,
                                        top: 0,
                                        child: Container(
                                          width: 37,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 37,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 37,
                                                  child: Text(
                                                    'P',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
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
                                left: 19,
                                top: 54,
                                child: Container(
                                  width: 384,
                                  height: 42,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 38,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 38,
                                                  child: Text(
                                                    'A',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 44,
                                        top: 0,
                                        child: Container(
                                          width: 36,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 36,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 36,
                                                  child: Text(
                                                    'S',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 86,
                                        top: 0,
                                        child: Container(
                                          width: 38,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 38,
                                                  child: Text(
                                                    'D',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 130,
                                        top: 0,
                                        child: Container(
                                          width: 38,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 38,
                                                  child: Text(
                                                    'F',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 174,
                                        top: 0,
                                        child: Container(
                                          width: 36,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 36,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 36,
                                                  child: Text(
                                                    'G',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 216,
                                        top: 0,
                                        child: Container(
                                          width: 38,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 38,
                                                  child: Text(
                                                    'H',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 260,
                                        top: 0,
                                        child: Container(
                                          width: 38,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 38,
                                                  child: Text(
                                                    'J',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 304,
                                        top: 0,
                                        child: Container(
                                          width: 36,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 36,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 36,
                                                  child: Text(
                                                    'K',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 346,
                                        top: 0,
                                        child: Container(
                                          width: 38,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 7,
                                                child: SizedBox(
                                                  width: 38,
                                                  child: Text(
                                                    'L',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFF030401),
                                                      fontSize: 22,
                                                      fontFamily: 'SF Pro Display',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.27,
                                                      letterSpacing: 0.35,
                                                    ),
                                                  ),
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
                                left: 0,
                                top: 108,
                                child: Container(
                                  width: 422,
                                  height: 42,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 58,
                                        top: 0,
                                        child: Container(
                                          width: 306,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 39,
                                                  height: 42,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 39,
                                                          height: 42,
                                                          decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4.60),
                                                            ),
                                                            shadows: [
                                                              BoxShadow(
                                                                color: Color(0x4C000000),
                                                                blurRadius: 0,
                                                                offset: Offset(0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        top: 7,
                                                        child: SizedBox(
                                                          width: 39,
                                                          child: Text(
                                                            'Z',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xFF030401),
                                                              fontSize: 22,
                                                              fontFamily: 'SF Pro Display',
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.27,
                                                              letterSpacing: 0.35,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 45,
                                                top: 0,
                                                child: Container(
                                                  width: 37,
                                                  height: 42,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 37,
                                                          height: 42,
                                                          decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4.60),
                                                            ),
                                                            shadows: [
                                                              BoxShadow(
                                                                color: Color(0x4C000000),
                                                                blurRadius: 0,
                                                                offset: Offset(0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        top: 7,
                                                        child: SizedBox(
                                                          width: 37,
                                                          child: Text(
                                                            'X',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xFF030401),
                                                              fontSize: 22,
                                                              fontFamily: 'SF Pro Display',
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.27,
                                                              letterSpacing: 0.35,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 88,
                                                top: 0,
                                                child: Container(
                                                  width: 39,
                                                  height: 42,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 39,
                                                          height: 42,
                                                          decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4.60),
                                                            ),
                                                            shadows: [
                                                              BoxShadow(
                                                                color: Color(0x4C000000),
                                                                blurRadius: 0,
                                                                offset: Offset(0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        top: 7,
                                                        child: SizedBox(
                                                          width: 39,
                                                          child: Text(
                                                            'C',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xFF030401),
                                                              fontSize: 22,
                                                              fontFamily: 'SF Pro Display',
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.27,
                                                              letterSpacing: 0.35,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 133,
                                                top: 0,
                                                child: Container(
                                                  width: 40,
                                                  height: 42,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 40,
                                                          height: 42,
                                                          decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4.60),
                                                            ),
                                                            shadows: [
                                                              BoxShadow(
                                                                color: Color(0x4C000000),
                                                                blurRadius: 0,
                                                                offset: Offset(0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        top: 7,
                                                        child: SizedBox(
                                                          width: 40,
                                                          child: Text(
                                                            'V',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xFF030401),
                                                              fontSize: 22,
                                                              fontFamily: 'SF Pro Display',
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.27,
                                                              letterSpacing: 0.35,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 179,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 38,
                                                          height: 42,
                                                          decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4.60),
                                                            ),
                                                            shadows: [
                                                              BoxShadow(
                                                                color: Color(0x4C000000),
                                                                blurRadius: 0,
                                                                offset: Offset(0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        top: 7,
                                                        child: SizedBox(
                                                          width: 38,
                                                          child: Text(
                                                            'B',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xFF030401),
                                                              fontSize: 22,
                                                              fontFamily: 'SF Pro Display',
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.27,
                                                              letterSpacing: 0.35,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 223,
                                                top: 0,
                                                child: Container(
                                                  width: 38,
                                                  height: 42,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 38,
                                                          height: 42,
                                                          decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4.60),
                                                            ),
                                                            shadows: [
                                                              BoxShadow(
                                                                color: Color(0x4C000000),
                                                                blurRadius: 0,
                                                                offset: Offset(0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        top: 7,
                                                        child: SizedBox(
                                                          width: 38,
                                                          child: Text(
                                                            'N',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xFF030401),
                                                              fontSize: 22,
                                                              fontFamily: 'SF Pro Display',
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.27,
                                                              letterSpacing: 0.35,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 267,
                                                top: 0,
                                                child: Container(
                                                  width: 39,
                                                  height: 42,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 39,
                                                          height: 42,
                                                          decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(4.60),
                                                            ),
                                                            shadows: [
                                                              BoxShadow(
                                                                color: Color(0x4C000000),
                                                                blurRadius: 0,
                                                                offset: Offset(0, 1),
                                                                spreadRadius: 0,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        top: 7,
                                                        child: SizedBox(
                                                          width: 39,
                                                          child: Text(
                                                            'M',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xFF030401),
                                                              fontSize: 22,
                                                              fontFamily: 'SF Pro Display',
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.27,
                                                              letterSpacing: 0.35,
                                                            ),
                                                          ),
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
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 42,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 42,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 380,
                                        top: 0,
                                        child: Container(
                                          width: 42,
                                          height: 42,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 42,
                                                  height: 42,
                                                  decoration: ShapeDecoration(
                                                    color: const Color(0xFFABB0BC),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.60),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Color(0x4C000000),
                                                        blurRadius: 0,
                                                        offset: Offset(0, 1),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
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
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 3,
                        top: 170,
                        child: Container(
                          width: 422,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 6,
                            children: [
                              Container(
                                width: 91,
                                height: 42,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 91,
                                        height: 42,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFABB0BC),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.60),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: Color(0x4C000000),
                                              blurRadius: 0,
                                              offset: Offset(0, 1),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 11,
                                      child: SizedBox(
                                        width: 91,
                                        child: Text(
                                          '123',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF030401),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro Text',
                                            fontWeight: FontWeight.w400,
                                            height: 1.31,
                                            letterSpacing: -0.32,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 42,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 228,
                                          height: 42,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.60),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x4C000000),
                                                blurRadius: 0,
                                                offset: Offset(0, 1),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 11,
                                        child: SizedBox(
                                          width: 228,
                                          child: Text(
                                            'space',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xFF030401),
                                              fontSize: 16,
                                              fontFamily: 'SF Pro Text',
                                              fontWeight: FontWeight.w400,
                                              height: 1.31,
                                              letterSpacing: -0.32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 91,
                                height: 42,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 91,
                                        height: 42,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFABB0BC),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.60),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: Color(0x4C000000),
                                              blurRadius: 0,
                                              offset: Offset(0, 1),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 11,
                                      child: SizedBox(
                                        width: 91,
                                        child: Text(
                                          'return',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF030401),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro Text',
                                            fontWeight: FontWeight.w400,
                                            height: 1.31,
                                            letterSpacing: -0.32,
                                          ),
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
                        left: 31,
                        top: 235,
                        child: Container(
                          width: 366,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 23,
                            children: [
                            ,
                            ],
                          ),
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