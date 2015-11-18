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

using namespace cv;
using namespace std;

int main (int argc, char** argv) {
	namedWindow("show");
	namedWindow("merge");
	namedWindow("R");
	namedWindow("G");
	namedWindow("B");

	Mat frame = imread(argv[1]);
	Mat edges;
	cvtColor(frame, edges, COLOR_BGR2GRAY);
	GaussianBlur(edges, edges, Size(9,9), 1.5, 1.5);
	Canny(edges, edges, 0, 30, 3);

	vector<Mat> channels;
	vector<Mat> channels_edge;
	split(frame,channels);

	for (size_t i = 0; i < 3; ++i) {
		Mat edges;
		GaussianBlur(channels[i], edges, Size(9,9), 1.5, 1.5);
		Canny(edges, edges, 0, 30, 3);
		channels_edge.push_back(edges);
	}

	//Mat color_edge;
	//merge(channels_edge, color_edge);
	Mat color_edge(channels_edge[2]);
	for (size_t i = 0; i < 2; ++i) {
		Mat& c = channels_edge[i];
		for (int y = 0; y < c.rows; ++y) {
			for (int x = 0; x < c.cols; ++x) {
				if (c.ptr<uchar>(y)[x] == 255) {
					color_edge.ptr<uchar>(y)[x] = 255;
				}
			}
		}
	}

	bool show_original = false;
	while(1) {
		imshow("show",  show_original ? frame: edges);
		imshow("merge", show_original ? frame: color_edge);
		/*
		imshow("R", show_original ? channels[0] : channels_edge[0]);
		imshow("G", show_original ? channels[1] : channels_edge[1]);
		imshow("B", show_original ? channels[2] : channels_edge[2]);
		*/
		if(waitKey(30) >= 0) break;
		//show_original = !show_original;
	}
	return 0;
}
