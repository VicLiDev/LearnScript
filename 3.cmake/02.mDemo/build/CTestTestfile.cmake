# CMake generated Testfile for 
# Source directory: /home/lhj/Projects/LearnScript/3.cmake/mDemo
# Build directory: /home/lhj/Projects/LearnScript/3.cmake/mDemo/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(test_run "/home/lhj/Projects/LearnScript/3.cmake/mDemo/build/bin/demo" "5" "2")
set_tests_properties(test_run PROPERTIES  _BACKTRACE_TRIPLES "/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;1143;ADD_TEST;/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;0;")
add_test(test_usage "/home/lhj/Projects/LearnScript/3.cmake/mDemo/build/bin/demo")
set_tests_properties(test_usage PROPERTIES  PASS_REGULAR_EXPRESSION "Usage: .* base exponent" _BACKTRACE_TRIPLES "/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;1146;add_test;/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;0;")
add_test(test_5_2 "/home/lhj/Projects/LearnScript/3.cmake/mDemo/build/bin/demo" "5" "2")
set_tests_properties(test_5_2 PROPERTIES  PASS_REGULAR_EXPRESSION "is 25" _BACKTRACE_TRIPLES "/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;1151;add_test;/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;0;")
add_test(test_10_5 "/home/lhj/Projects/LearnScript/3.cmake/mDemo/build/bin/demo" "10" "5")
set_tests_properties(test_10_5 PROPERTIES  PASS_REGULAR_EXPRESSION "is 100000" _BACKTRACE_TRIPLES "/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;1157;add_test;/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;0;")
add_test(test_2_10 "/home/lhj/Projects/LearnScript/3.cmake/mDemo/build/bin/demo" "2" "10")
set_tests_properties(test_2_10 PROPERTIES  PASS_REGULAR_EXPRESSION "is 1024" _BACKTRACE_TRIPLES "/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;1163;add_test;/home/lhj/Projects/LearnScript/3.cmake/mDemo/CMakeLists.txt;0;")
subdirs("src/math")
subdirs("src")
