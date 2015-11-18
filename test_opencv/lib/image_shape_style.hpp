/*
 * Copyright(C) Relic Fragments 2015. All rights reserved !
 */

#include <vector>
#include <iostream>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/objdetect.hpp>
#include <opencv2/video.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/calib3d.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/features2d.hpp>

namespace imgproc {
	using cv::Mat;
	using cv::Point3i;
	void edges(Mat const & source, Mat& dst, bool isHelper = false) {
		if (!isHelper) {
			cv::cvtColor(source, dst, cv::COLOR_BGR2GRAY);
		}
		Mat const & s = isHelper ? source : dst;
		cv::GaussianBlur(s, dst, cv::Size(9,9), 1.5, 1.5);
		cv::Canny(dst, dst, 0, 30, 3);
	}
	void rgb_edges(Mat const & source, Mat& dst) {
		std::vector<Mat> channels;
		cv::split(source,channels);
		for (size_t i = 0; i < 3; ++i) {
			Mat c;
			edges(channels[i], c, true);
			if (i == 0) {
				dst = c;
			} else {
				for (int y = 0; y < c.rows; ++y) {
					for (int x = 0; x < c.cols; ++x) {
						if (c.ptr<uchar>(y)[x] == 255) {
							dst.ptr<uchar>(y)[x] = 255;
						}
					}
				}
			}
		}
	}
	void camera_split(Mat const & frame,
					  Mat& stable, Mat& moving,
					  Mat& hisMat,
					  Point3i const & stable_color = Point3i(255,255,255),
					  Point3i const & moving_color = Point3i(255,255,255)) {
		Mat edges;
		//cv::cvtColor(frame, frame, cv::COLOR_BGR2HSV_FULL);
		imgproc::edges(frame,edges);
		//imgproc::rgb_edges(frame, edges);
		if (hisMat.empty()) {
			hisMat = edges;
			for (int i = 0; i < frame.rows; ++i) {
				for (int j = 0; j < frame.cols; ++j) {
					hisMat.ptr<uchar>(i)[j] = 0;
				}
			}
		}
		for (int i = 0; i < frame.rows; ++i) {
			for (int j = 0; j < frame.cols; ++j) {
				if (edges.ptr<uchar>(i)[j] == 255) {
					if (hisMat.ptr<uchar>(i)[j] < 200) {
						hisMat.ptr<uchar>(i)[j]+= 15;
						if (hisMat.ptr<uchar>(i)[j] > 202) {
							hisMat.ptr<uchar>(i)[j] = 202;
						}
					}
				} else {
					if (hisMat.ptr<uchar>(i)[j] > 0) {
						hisMat.ptr<uchar>(i)[j]--;
					}
				}
			}
		}

		if (stable.empty()) { stable = frame.clone(); }
		if (moving.empty()) { moving = frame.clone(); }
		for (int i = 0; i < frame.rows; ++i) {
			for (int j = 0; j < frame.cols; ++j) {
				if (hisMat.ptr<uchar>(i)[j] >= 200) {
					stable.ptr<uchar>(i)[j*3+2] = stable_color.x;
					stable.ptr<uchar>(i)[j*3+1] = stable_color.y;
					stable.ptr<uchar>(i)[j*3+0] = stable_color.z;
				} else if (edges.ptr<uchar>(i)[j] == 255 &&
						  hisMat.ptr<uchar>(i)[j] >= 20) {
					moving.ptr<uchar>(i)[j*3+2] = moving_color.x;
					moving.ptr<uchar>(i)[j*3+1] = moving_color.y;
					moving.ptr<uchar>(i)[j*3+0] = moving_color.z;
				}
			}
		}
	}
}
