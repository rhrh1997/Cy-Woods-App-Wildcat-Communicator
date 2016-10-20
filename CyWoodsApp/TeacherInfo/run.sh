#!/bin/sh
javac -cp .:json.jar TeacherInfo.java && java -cp .:json.jar TeacherInfo $@

