/*
 * Copyright(C) Relic Fragments 2015. All rights reserved !
 */

#include <iostream>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/objdetect.hpp>
#include <opencv2/video.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/calib3d.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/features2d.hpp>
#include "image_shape_style.hpp"

using namespace cv;

typedef cv::Point3_<uint8_t> Pixel;
struct Clear {
	void operator()(Pixel &p, const int * position) const {
		p.x = 0;
		p.y = 0;
		p.z = 0;
	}
};

int main (int argc, char** argv) {
	namedWindow("edges");
	namedWindow("stable");
	namedWindow("moving");

	std::cout << "namedWindow created" << std::endl;

	VideoCapture* capture;
	const char* window0;
	if (argc == 1) {
		capture = new VideoCapture(0);
		window0 = "Camera 1";
	} else {
		std::cout << "file " << argv[1] << std::endl;
		capture = new VideoCapture(argv[1]);
		window0 = argv[1];

		long totolFrameNumber = (long)capture->get(CV_CAP_PROP_FRAME_COUNT);
		int  height = (int)capture->get(CV_CAP_PROP_FRAME_HEIGHT);
		int  width  = (int)capture->get(CV_CAP_PROP_FRAME_WIDTH);
		std::cout<<"视频总帧数："<<totolFrameNumber<<std::endl<<"一帧的像素高："<<height<<" 像素宽："<<width<<std::endl;
		double rate = capture->get(CV_CAP_PROP_FPS);
		std::cout<<"频率:"<<rate<<std::endl;
	}
	if(!capture->isOpened())  // check if we succeeded
		return -1;
	std::cout << "capture ready" << std::endl;

	int  height = (int)capture->get(CV_CAP_PROP_FRAME_HEIGHT);
	int  width  = (int)capture->get(CV_CAP_PROP_FRAME_WIDTH);
	Mat super_edges[2];
	Mat frame(width, height, CV_64FC4);
	bool first_time = true;
	int count = 0;
	while(true) {
		capture->read(frame);
		if (first_time) {
			std::cout << "Frame row,col:" << frame.rows << ","<< frame.cols << std::endl;
			first_time = false;
		}
		if (frame.empty()) break;
		Mat stable = frame.clone();
		Mat moving = frame.clone();
		//Clear c;
		//stable.forEach<Pixel>(c);
		//moving.forEach<Pixel>(c);
		imgproc::camera_split(frame, stable, moving, super_edges[0]);
		imgproc::camera_split(frame, frame,  frame,  super_edges[1], Point3i(255,0,0),Point3i(0,255,255));
		count++;
		if (count == 10000)
			count = 10000;
		imshow("edges",  frame);
		imshow("moving", moving);
		imshow("stable", stable);
		if(waitKey(30) >= 0) break;
	}

	delete capture;

	return 0;
}
