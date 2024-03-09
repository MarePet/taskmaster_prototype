import 'package:flutter/material.dart';
import 'package:taskmaster/components/login_form.dart';
import 'package:taskmaster/components/register_form.dart';

class Body extends StatefulWidget {
  final bool loginActive;

  const Body({super.key, required this.loginActive});
  
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign in to \n Taskmaster',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'If you dont have an account',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text(
                    'You can',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Register here',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Image.asset('images/illustration-2.png', width: 300),
            ],
          ),
        ),
        Image.asset(
          'images/illustration-1.png',
          width: 300,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 4),
          child:  SizedBox(
            width: 400,
            child: widget.loginActive ? const FormLogin() : const FormRegister(),
          ),
        ),
      ],
    );
  }
}

// Widget _formLogin() {
//   return Column(
//     children: [
//       TextField(
//         decoration: InputDecoration(
//           hintText: 'Enter your e-mail',
//           fillColor: (Colors.blueGrey[50]!),
//           filled: true,
//           labelStyle: const TextStyle(fontSize: 12),
//           contentPadding: const EdgeInsets.only(left: 30),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//       ),
//       const SizedBox(
//         height: 30,
//       ),
//       TextField(
//         obscureText: true,
//         decoration: InputDecoration(
//           hintText: 'Password',
//           counterText: 'Forgot password?',
//           suffixIcon: const Icon(
//             Icons.visibility_off_outlined,
//             color: Colors.blueGrey,
//           ),
//           fillColor: (Colors.blueGrey[50]!),
//           filled: true,
//           labelStyle: const TextStyle(fontSize: 12),
//           contentPadding: const EdgeInsets.only(left: 30),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//       ),
//       const SizedBox(
//         height: 40,
//       ),
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//                 color: (Colors.deepPurple[100])!,
//                 spreadRadius: 10,
//                 blurRadius: 20)
//           ],
//         ),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15))),
//           onPressed: () {},
//           child: Container(
//             width: double.infinity,
//             height: 50,
//             alignment: Alignment.center,
//             child: const Text('Sing in'),
//           ),
//         ),
//       ),
//     ],
//   );
// }
