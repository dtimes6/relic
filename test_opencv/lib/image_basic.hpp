/*
 * Copyright(C) Relic Fragments 2015. All rights reserved !
 */

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/objdetect.hpp>
#include <opencv2/video.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/calib3d.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/features2d.hpp>

#include <vector>
#include <string>

namespace Relic {

	typedef cv::Mat		Mat;
	typedef cv::Point3i	Color;
	typedef std::vector<Color> ColorMap;

	class Image : public Mat {
	public:
		Image(std::string const & filename);
	};

} // end namespace Relic
